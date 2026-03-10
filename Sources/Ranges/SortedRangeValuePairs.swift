/* *************************************************************************************************
 SortedRangeValuePairs.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */


internal struct _SortedRangeValuePairs<Bound, Value> where Bound: Comparable {
  typealias _Pair = (range: any GeneralizedRange<Bound>, value: Value)
  typealias _SendablePair = (range: any GeneralizedRange<Bound> & Sendable, value: Value)

  enum _Storage {
    case pairs([_Pair])
    case ranges([any GeneralizedRange<Bound>])
    case separated(ranges: [any GeneralizedRange<Bound>], values: [Value])
  }

  /// Storage for an array.
  internal private(set) var _storage: _Storage

  private init(_storage storage: _Storage) {
    self._storage = storage
    assert(self._storage.validateRanges())
  }

  init(carefullySortedPairs pairs: [_Pair]) {
    self.init(_storage: .pairs(pairs))
  }

  init(carefullySortedRanges ranges: [any GeneralizedRange<Bound>], values: [Value]) {
    self.init(_storage: .separated(ranges: ranges, values: values))
  }
}

extension _SortedRangeValuePairs._Storage: @unchecked Sendable where Bound: Sendable,
                                                                     Value: Sendable {}

extension _SortedRangeValuePairs: Sendable where Bound: Sendable, Value: Sendable {}

extension _SortedRangeValuePairs where Bound: Sendable {
  @inline(__always)
  func _assertSendableGeneralizedRangeProtocolConformances() {
    var assertionMessage: String {
      "All ranges must conform to `SendableGeneralizedRange`. " +
      "The protocol is currently internal because of [#87737](https://github.com/swiftlang/swift/issues/87737). " +
      "That means that all ranges passed to this function must be defined in Standard Library or SwiftRanges Module."
    }
    switch self._storage {
    case .pairs(let pairs):
      assert(pairs.allSatisfy({ $0.range is any SendableGeneralizedRange }), assertionMessage)
    case .ranges(let ranges):
      assert(ranges.allSatisfy({ $0 is any SendableGeneralizedRange }), assertionMessage)
    case .separated(ranges: let ranges, values: _):
      assert(ranges.allSatisfy({ $0 is any SendableGeneralizedRange }), assertionMessage)
    }
  }
}

extension _SortedRangeValuePairs where Bound: Sendable, Value: Sendable {
  init(carefullySortedPairs pairs: [_SendablePair]) {
    self.init(_storage: .pairs(pairs))
  }

  init(carefullySortedSendablePairs pairs: [_Pair]) {
    self.init(_storage: .pairs(pairs))
    _assertSendableGeneralizedRangeProtocolConformances()
  }
}

typealias _SortedRanges<Bound> = _SortedRangeValuePairs<Bound, Never> where Bound: Comparable

extension _SortedRangeValuePairs where Value == Never {
  init(carefullySortedRanges ranges: [any GeneralizedRange<Bound>]) {
    self.init(_storage: .ranges(ranges))
  }
}

extension _SortedRangeValuePairs where Bound: Sendable, Value == Never {
  init(carefullySortedRanges ranges: [any GeneralizedRange<Bound> & Sendable]) {
    self.init(_storage: .ranges(ranges))
  }

  init(carefullySortedSendableRanges ranges: [any GeneralizedRange<Bound>]) {
    self.init(_storage: .ranges(ranges))
    _assertSendableGeneralizedRangeProtocolConformances()
  }
}

extension _SortedRangeValuePairs._Storage {
  @inlinable
  var count: Int {
    switch self {
    case .pairs(let pairs):
      return pairs.count
    case .ranges(let ranges), .separated(ranges: let ranges, values: _):
      return ranges.count
    }
  }

  @inlinable
  var isEmpty: Bool {
    return self.count == 0
  }

  @inlinable
  func range(at index: Int) -> any GeneralizedRange<Bound> {
    switch self {
    case .pairs(let pairs):
      return pairs[index].range
    case .ranges(let ranges), .separated(ranges: let ranges, values: _):
      return ranges[index]
    }
  }

  @inlinable
  func value(at index: Int) -> Value? {
    switch self {
    case .pairs(let pairs):
      return pairs[index].value
    case .ranges:
      return nil
    case .separated(ranges: _, values: let values):
      return values[index]
    }
  }

  func validateRanges() -> Bool {
    if case .separated(let ranges, let values) = self {
      guard ranges.count == values.count else {
        return false
      }
    }

    let count = self.count
    switch count {
    case 0:
      return true
    case 1:
      return !self.range(at: 0).isEmpty
    default:
      break
    }

    assert(count > 1)
    for ii in 0..<(count - 1) {
      let range0 = range(at: ii)
      let range1 = range(at: ii + 1)
      guard (
        !range0.isEmpty &&
        !range1.isEmpty &&
        range0._isLessThanAndApartFrom(range1)
      ) else {
        return false
      }
    }
    return true
  }

  func index(whereRangeContains bound: Bound) -> Int? {
    func __binarySearch(indexRange: Range<Int>) -> Int? {
      if indexRange.isEmpty {
        return nil
      }
      let middleIndex = indexRange.lowerBound + ((indexRange.upperBound - indexRange.lowerBound) / 2)
      let middleRange = self.range(at: middleIndex)
      if middleRange.contains(bound) {
        return middleIndex
      }
      if middleRange.bounds!.lower._compare(bound, side: .lower) == .orderedDescending {
        return __binarySearch(indexRange: indexRange.lowerBound..<middleIndex)
      } else if middleIndex < indexRange.upperBound - 1 {
        return __binarySearch(indexRange: (middleIndex + 1)..<indexRange.upperBound)
      }
      return nil
    }
    return __binarySearch(indexRange: 0..<self.count)
  }

  enum _IndicesForReplacement: Equatable {
    /// There are ranges which overlap the range to be replaced with.
    case overlap(first: Int, last: Int)

    /// No overlaps. The range can be simply inserted at the index.
    case insertable(Int)
  }

  func indices(for range: any GeneralizedRange<Bound>) -> _IndicesForReplacement {
    assert(!range.isEmpty, "\(#function): Empty range?!")

    let count = self.count
    if count < 1 || range._isLessThanAndApartFrom(self.range(at: 0)) {
      return .insertable(0)
    }
    if self.range(at: count - 1)._isLessThanAndApartFrom(range) {
      return .insertable(count)
    }

    var firstIndexWhereOverlaps: Int? = nil
    DETERMINE_FIRST_INDEX: do {
      assert(count > 0)
      if range.overlaps(self.range(at: 0)) {
        firstIndexWhereOverlaps = 0
        break DETERMINE_FIRST_INDEX
      }

      assert(count > 1, "Must be already handled if `count` == 1")
      for ii in 0..<(count - 1) {
        let range0 = self.range(at: ii)
        let range1 = self.range(at: ii + 1)
        if range.overlaps(range0) {
          firstIndexWhereOverlaps = ii + 1
          break DETERMINE_FIRST_INDEX
        }
        if range0._isLessThanAndApartFrom(range) && range._isLessThanAndApartFrom(range1) {
          return .insertable(ii + 1)
        }
      }
    }

    assert(firstIndexWhereOverlaps != nil, "First Index Not Found?!")
    var lastIndexWhereOverlaps: Int? = nil
    for ii in (firstIndexWhereOverlaps!..<count).reversed() {
      if self.range(at: ii).overlaps(range) {
        lastIndexWhereOverlaps = ii
        break
      }
    }

    return .overlap(first: firstIndexWhereOverlaps!, last: lastIndexWhereOverlaps!)
  }
}

extension _SortedRangeValuePairs {
  @inlinable
  var count: Int { _storage.count }

  @inlinable
  var isEmpty: Bool { _storage.isEmpty }

  @inlinable
  func range(at index: Int) -> any GeneralizedRange<Bound> { _storage.range(at: index) }

  @inlinable
  func value(at index: Int) -> Value? { _storage.value(at: index) }

  @inlinable
  func index(whereRangeContains bound: Bound) -> Int? { _storage.index(whereRangeContains: bound) }

  subscript(_ bound: Bound) -> Value? {
    guard let index = self.index(whereRangeContains: bound) else {
      return nil
    }
    return self.value(at: index)
  }
}

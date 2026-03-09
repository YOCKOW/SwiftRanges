/* *************************************************************************************************
 SortedRangeValuePairs.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */


internal struct _SortedRangeValuePairs<Bound, Value> where Bound: Comparable {
  enum _Storage {
    case pairs([(range: any GeneralizedRange<Bound> & Sendable, value: Value)])
    case ranges([any GeneralizedRange<Bound> & Sendable])
  }

  /// Storage for an array.
  internal private(set) var _storage: _Storage

  init(carefullySortedPairs pairs: [(range: any GeneralizedRange<Bound> & Sendable, value: Value)]) {
    self._storage = .pairs(pairs)
    assert(self._storage.validateRanges())
  }
}

typealias _SortedRanges<Bound> = _SortedRangeValuePairs<Bound, Never> where Bound: Comparable

extension _SortedRangeValuePairs where Value == Never {
  init(carefullySortedRanges ranges: [any GeneralizedRange<Bound> & Sendable]) {
    self._storage = .ranges(ranges)
    assert(self._storage.validateRanges())
  }
}

extension _SortedRangeValuePairs._Storage: Sendable where Value: Sendable {}
extension _SortedRangeValuePairs: Sendable where Value: Sendable {}

extension _SortedRangeValuePairs._Storage {
  @inlinable
  var count: Int {
    switch self {
    case .pairs(let pairs):
      return pairs.count
    case .ranges(let ranges):
      return ranges.count
    }
  }

  @inlinable
  var isEmpty: Bool {
    return self.count == 0
  }

  @inlinable
  func range(at index: Int) -> any GeneralizedRange<Bound> & Sendable {
    switch self {
    case .pairs(let pairs):
      return pairs[index].range
    case .ranges(let ranges):
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
    }
  }

  func validateRanges() -> Bool {
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
  func range(at index: Int) -> any GeneralizedRange<Bound> & Sendable { _storage.range(at: index) }

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

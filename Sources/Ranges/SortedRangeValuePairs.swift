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
    /// No overlaps. The range can be simply inserted at the index.
    case insertable(Int)

    /// There are ranges which overlap the range to be replaced with.
    case overlap(first: Int, last: Int)
  }

  func indices(for range: any GeneralizedRange<Bound>) -> _IndicesForReplacement {
    assert(!range.isEmpty, "\(#function): Empty range?!")

    let count = self.count
    if count < 1 {
      return .insertable(0)
    }

    let firstRange = self.range(at: 0)
    if range._isLessThanAndApartFrom(firstRange) {
      return .insertable(0)
    }

    let lastRange = self.range(at: count - 1)
    if lastRange._isLessThanAndApartFrom(range) {
      return .insertable(count)
    }
    if lastRange.compare(range) == .orderedAscending && lastRange.overlaps(range)  {
      return .overlap(first: count - 1, last: count - 1)
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
        let nextRange = self.range(at: ii + 1)
        if range.overlaps(nextRange) {
          firstIndexWhereOverlaps = ii + 1
          break DETERMINE_FIRST_INDEX
        }

        let currentRange = self.range(at: ii)
        if currentRange._isLessThanAndApartFrom(range) && range._isLessThanAndApartFrom(nextRange) {
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


// MARK: - Insert & Remove

extension _SortedRangeValuePairs where Value == Never {
  @inlinable
  func contains(_ bound: Bound) -> Bool {
    return index(whereRangeContains: bound) != nil
  }
}

extension _SortedRangeValuePairs._Storage {
  private func _splitted(
    by range: any GeneralizedRange<Bound>
  ) -> (
    formerPairsOrRanges: any Collection,
    formerValues: (any Collection<Value>)?,
    latterPairsOrRanges: any Collection,
    latterValues: (any Collection<Value>)?
  ) {
    assert(!range.isEmpty, "\(#function): Empty range?!")

    switch self.indices(for: range) {
    case .insertable(let index):
      switch self {
      case .pairs(let pairs):
        return (
          formerPairsOrRanges: pairs[..<index],
          formerValues: nil,
          latterPairsOrRanges: pairs[index...],
          latterValues: nil
        )
      case .ranges(let ranges):
        return (
          formerPairsOrRanges: ranges[..<index],
          formerValues: nil,
          latterPairsOrRanges: ranges[index...],
          latterValues: nil
        )
      case .separated(ranges: let ranges, values: let values):
        return (
          formerPairsOrRanges: ranges[..<index],
          formerValues: values[..<index],
          latterPairsOrRanges: ranges[index...],
          latterValues: values[index...]
        )
      }
    case .overlap(first: let firstIndex, last: let lastIndex):
      typealias __Splitted = (
        formerRanges: ArraySlice<any GeneralizedRange<Bound>>,
        formerValues: ArraySlice<Value>?,
        latterRanges: ArraySlice<any GeneralizedRange<Bound>>,
        latterValues: ArraySlice<Value>?
      )
      func __split(
        ranges: [any GeneralizedRange<Bound>],
        values: [Value]?
      ) -> __Splitted {
        var formerRanges = ranges[..<firstIndex]
        var formerValues = values?[..<firstIndex]
        var latterRanges = ranges[lastIndex<..]
        var latterValues = values?[lastIndex<..]

        if firstIndex == lastIndex {
          switch ranges[firstIndex].subtracting(range) {
          case (let subtracted, nil):
            if subtracted.compare(range) == .orderedAscending {
              formerRanges.append(subtracted)
              if let theValue = values?[firstIndex] {
                formerValues!.append(theValue)
              }
            } else {
              latterRanges.insert(subtracted, at: latterRanges.startIndex)
              if let theValue = values?[firstIndex] {
                latterValues!.insert(theValue, at: latterValues!.startIndex)
              }
            }
          case (let subtractedL, let subtractedR?):
            // The range at `firstIndex` is splitted.
            formerRanges.append(subtractedL)
            latterRanges.insert(subtractedR, at: latterRanges.startIndex)
            if let theValue = values?[firstIndex] {
              formerValues!.append(theValue)
              latterValues!.insert(theValue, at: latterValues!.startIndex)
            }
          }
        } else {
          assert(firstIndex < lastIndex)

          let formerSubtracted = ranges[firstIndex].subtracting(range)
          assert(formerSubtracted.1 == nil)
          if !formerSubtracted.0.isEmpty {
            formerRanges.append(formerSubtracted.0)
            if let theValue = values?[firstIndex] {
              formerValues!.append(theValue)
            }
          }

          let latterSubtracted = ranges[lastIndex].subtracting(range)
          assert(latterSubtracted.1 == nil)
          if !latterSubtracted.0.isEmpty {
            latterRanges.append(latterSubtracted.0)
            if let theValue = values?[lastIndex] {
              latterValues!.append(theValue)
            }
          }
        }
        return (
          formerRanges: formerRanges,
          formerValues: formerValues,
          latterRanges: latterRanges,
          latterValues: latterValues
        )
      }

      let splitted: __Splitted = ({ () -> __Splitted in
        switch self {
        case .pairs(let pairs):
          let rangesAndValues: (
            ranges: [any GeneralizedRange<Bound>],
            values: [Value]
          ) = pairs.reduce(into: ([], [])) {
            $0.ranges.append($1.range)
            $0.values.append($1.value)
          }
          return __split(ranges: rangesAndValues.ranges, values: rangesAndValues.values)
        case .ranges(let ranges):
          return __split(ranges: ranges, values: nil)
        case .separated(let ranges, let values):
          return __split(ranges: ranges, values: values)
        }
      })()

      return (
        formerPairsOrRanges: splitted.formerRanges,
        formerValues: splitted.formerValues,
        latterPairsOrRanges: splitted.latterRanges,
        latterValues: splitted.latterValues
      )
    }
  }

  fileprivate mutating func _insertValue(
    _ value: Value?,
    forRange  range: any GeneralizedRange<Bound>,
    dontRemoveValueEvenIfValueIsNil: Bool = false
  ) {
    if range.isEmpty {
      return
    }

    let splitted = _splitted(by: range)
    switch (splitted.formerPairsOrRanges, splitted.latterPairsOrRanges) {
    case (
      let formerPairs as any Collection<_SortedRangeValuePairs._Pair>,
      let latterPairs as any Collection<_SortedRangeValuePairs._Pair>
    ):
      assert(splitted.formerValues == nil && splitted.latterValues == nil)

      var newPairs: [_SortedRangeValuePairs._Pair] = []
      newPairs.append(contentsOf: formerPairs)
      if let value = value {
        newPairs.append((range: range, value: value))
      }
      newPairs.append(contentsOf: latterPairs)
      self = .pairs(newPairs)
    case (
      let formerRanges as any Collection<any GeneralizedRange<Bound>>,
      let latterRanges as any Collection<any GeneralizedRange<Bound>>
    ):
      var newRanges: [any GeneralizedRange<Bound>] = []
      newRanges.append(contentsOf: formerRanges)
      if value != nil || dontRemoveValueEvenIfValueIsNil {
        newRanges.append(range)
      }
      newRanges.append(contentsOf: latterRanges)

      switch (splitted.formerValues, splitted.latterValues) {
      case (nil, nil):
        self = .ranges(newRanges)
      case (let formerValues?, let latterValues?):
        var newValues: [Value] = []
        newValues.append(contentsOf: formerValues)
        if let value = value {
          newValues.append(value)
        }
        newValues.append(contentsOf: latterValues)
        assert(newRanges.count == newValues.count, "Count unmatched?!")
        self = .separated(ranges: newRanges, values: newValues)
      default:
        fatalError("Unexpected splitted values?!")
      }
    default:
      fatalError("Unexpected splitted ranges?!")
    }
  }

  mutating func removeValues(in range: any GeneralizedRange<Bound>) {
    self._insertValue(nil, forRange: range)
  }
}

extension _SortedRangeValuePairs {
  mutating func insertValue(_ value: Value, forRange range: any GeneralizedRange<Bound>) {
    self._storage._insertValue(value, forRange: range)
  }

  mutating func insertValue(_ value: Value, forRange range: UnboundedRange) {
    self._storage._insertValue(value, forRange: TangibleUnboundedRange<Bound>())
  }

  mutating func removeValues(in range: any GeneralizedRange<Bound>) {
    self._storage.removeValues(in: range)
  }
}

extension _SortedRangeValuePairs where Value == Never {
  mutating func insertRange(_ range: any GeneralizedRange<Bound>) {
    self._storage._insertValue(nil, forRange: range, dontRemoveValueEvenIfValueIsNil: true)
  }

  mutating func removeRange(_ range: any GeneralizedRange<Bound>) {
    self._storage.removeValues(in: range)
  }
}


// MARK: - Limit

extension _SortedRangeValuePairs._Storage {
  func limited(within range: any GeneralizedRange<Bound>) -> Self {
    guard
      !range.isEmpty,
      case .overlap(first: let firstIndex, last: let lastIndex) = self.indices(for: range)
    else {
      switch self {
      case .pairs, .separated:
        return .separated(ranges: [], values: [])
      case .ranges:
        return .ranges([])
      }
    }

    switch self {
    case .pairs(let pairs):
      var limited = pairs[firstIndex...lastIndex]
      assert(!limited.isEmpty)

      let firstPair = limited.first!
      let firstRange = firstPair.range.intersection(range)
      assert(!firstRange.isEmpty)
      limited._setElementAtFirst((range: firstRange, value: firstPair.value))

      if limited.count > 1 {
        let lastPair = limited.last!
        let lastRange = lastPair.range.intersection(range)
        assert(!lastRange.isEmpty)
        limited._setElementAtLast((range: lastRange, value: lastPair.value))
      }

      return .pairs(limited._array)
    case .ranges(let ranges):
      var limited = ranges[firstIndex...lastIndex]
      assert(limited.isEmpty)

      let firstRange = limited.first!.intersection(range)
      assert(!firstRange.isEmpty)
      limited._setElementAtLast(firstRange)

      if limited.count > 1 {
        let lastRange = limited.last!.intersection(range)
        assert(!lastRange.isEmpty)
        limited._setElementAtLast(lastRange)
      }

      return .ranges(limited._array)
    case .separated(ranges: let ranges, values: let values):
      var limitedRanges = ranges[firstIndex...lastIndex]
      let limitedValues = values[firstIndex...lastIndex]

      let firstRange = limitedRanges.first!.intersection(range)
      assert(!firstRange.isEmpty)
      limitedRanges._setElementAtFirst(firstRange)

      if limitedRanges.count > 1 {
        let lastRange = limitedRanges.last!.intersection(range)
        assert(!lastRange.isEmpty)
        limitedRanges._setElementAtLast(lastRange)
      }

      return .separated(ranges: limitedRanges._array, values: limitedValues._array)
    }
  }
}

extension _SortedRangeValuePairs {
  @inlinable
  func limited(within range: any GeneralizedRange<Bound>) -> Self {
    return .init(_storage: self._storage.limited(within: range))
  }

  @inlinable
  func limited(within: UnboundedRange) -> Self {
    return self
  }
}


// MARK: - Normalization

extension _SortedRangeValuePairs._Storage where Value: Equatable {
  func normilized() -> Self {
    switch self {
    case .pairs(let pairs):
      var newPairs: [_SortedRangeValuePairs._Pair] = []
      for pair in pairs {
        if let lastPair = newPairs.last,
           lastPair.value == pair.value,
           let concatenated = lastPair.range.concatenating(pair.range) {
          newPairs._setElementAtLast((range: concatenated, value: lastPair.value))
        } else {
          newPairs.append(pair)
        }
      }
      return .pairs(newPairs)
    case .ranges:
      return self
    case .separated(let ranges, let values):
      var newRanges: [any GeneralizedRange<Bound>] = []
      var newValues: [Value] = []
      for (range, value) in zip(ranges, values) {
        if let lastRange = newRanges.last,
           let lastValue = newValues.last,
           lastValue == value,
           let concatenated = lastRange.concatenating(range) {
          newRanges._setElementAtLast(concatenated)
        } else {
          newRanges.append(range)
          newValues.append(value)
        }
      }
      assert(newRanges.count == newValues.count)
      return .separated(ranges: newRanges, values: newValues)
    }
  }
}

extension _SortedRangeValuePairs where Value: Equatable {
  func normalized() -> Self {
    return .init(_storage: self._storage.normilized())
  }
}


// MARK: - Equatable

extension _SortedRangeValuePairs._Storage: Equatable where Value: Equatable {
  private func _isConsideredEquivalent(
    to other: _SortedRangeValuePairs<Bound, Value>._Storage,
    rangeComparator: (any GeneralizedRange<Bound>, any GeneralizedRange<Bound>) -> Bool
  ) -> Bool {
    guard self.count == other.count else {
      return false
    }

    for ii in 0..<self.count {
      let myRange = self.range(at: ii)
      let otherRange = other.range(at: ii)
      guard rangeComparator(myRange, otherRange) else {
        return false
      }

      if let myValue = self.value(at: ii), let otherValue = other.value(at: ii) {
        guard myValue == otherValue else {
          return false
        }
      }
    }
    return true
  }

  /// Returns a Boolean value indicating the storage is equivalent to `other`.
  ///
  /// - Note:
  ///   - Both storages are normalized before comparison.
  ///   - Each range is compared by `isEquivalent(to:)`.
  @inlinable
  func isEquivalent(to other: _SortedRangeValuePairs<Bound, Value>._Storage) -> Bool {
    return self.normilized()._isConsideredEquivalent(
      to: other.normilized(),
      rangeComparator: { $0.isEquivalent(to: $1) }
    )
  }

  @inlinable
  func isEqual(to other: _SortedRangeValuePairs<Bound, Value>._Storage) -> Bool {
    return self._isConsideredEquivalent(to: other, rangeComparator: { $0.isEqual(to: $1) })
  }

  static func ==(
    lhs: _SortedRangeValuePairs<Bound, Value>._Storage,
    rhs: _SortedRangeValuePairs<Bound, Value>._Storage
  ) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}

extension _SortedRangeValuePairs: Equatable where Value: Equatable {
  @inlinable
  func isEquivalent(to other: _SortedRangeValuePairs<Bound, Value>) -> Bool {
    return self._storage.isEquivalent(to: other._storage)
  }

  @inlinable
  func isEqual(to other: _SortedRangeValuePairs<Bound, Value>) -> Bool {
    return self._storage.isEqual(to: other._storage)
  }

  static func ==(
    lhs: _SortedRangeValuePairs<Bound, Value>,
    rhs: _SortedRangeValuePairs<Bound, Value>
  ) -> Bool {
    return lhs.isEqual(to: rhs)
  }
}


// MARK: - Misc Extensions

private extension MutableCollection where Self: BidirectionalCollection {
  var _array: Array<Element> {
    .init(self)
  }

  mutating func _setElementAtFirst(_ newElement: Element) {
    self[self.startIndex] = newElement
  }

  mutating func _setElementAtLast(_ newElement: Element) {
    self[self.index(before: self.endIndex)] = newElement
  }
}

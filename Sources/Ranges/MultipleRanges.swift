/* *************************************************************************************************
 MultipleRanges.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

private func _bitCastArrayVoidToNone<T>(_ array: Array<(AnyRange<T>, Void)>) -> Array<AnyRange<T>> {
  assert(MemoryLayout<(AnyRange<T>, Void)>.size == MemoryLayout<AnyRange<T>>.size)
  return unsafeBitCast(array, to: Array<AnyRange<T>>.self)
}

private func _bitCastArrayNoneToVoid<T>(_ array: Array<AnyRange<T>>) -> Array<(AnyRange<T>, Void)> {
  assert(MemoryLayout<(AnyRange<T>, Void)>.size == MemoryLayout<AnyRange<T>>.size)
  return unsafeBitCast(array, to: Array<(AnyRange<T>, Void)>.self)
}

/// Represents multiple ranges.
public struct MultipleRanges<Bound> where Bound: Comparable {
  private var _rangeDictionary: RangeDictionary<Bound, Void>
  
  private init(_ rangeDictionary: RangeDictionary<Bound, Void>) {
    self._rangeDictionary = rangeDictionary
  }
  
  /// Creates an empty ranges.
  public init() {
    self._rangeDictionary = .init()
  }
  
  /// Creates an instance initialized with `ranges`.
  /// The ranges must be sorted in advance, and all ranges must not be overlapped each other.
  /// Furthermore, no ranges must be empty.
  /// You may not use this initializer usually.
  public init(carefullySortedRanges ranges: [AnyRange<Bound>]) {
    self._rangeDictionary = .init(carefullySortedRangesAndValues: _bitCastArrayNoneToVoid(ranges))
  }
  
  /// Creates an instace initialized with `ranges`.
  public init(_ ranges: [AnyRange<Bound>]) {
    self.init()
    self.ranges = ranges
  }
}

public typealias MultipleCountableRanges<Bound> =
  MultipleRanges<Bound> where Bound:Strideable, Bound.Stride:SignedInteger

extension MultipleRanges {
  public var isEmpty:Bool { return self._rangeDictionary.isEmpty }
}

extension MultipleRanges {
  public var ranges: [AnyRange<Bound>] {
    get {
      return _bitCastArrayVoidToNone(Array<(AnyRange<Bound>, Void)>(self._rangeDictionary))
    }
    set {
      self._rangeDictionary = .init()
      for range in newValue {
        if range.isEmpty { continue }
        self._rangeDictionary.insert(range: range)
      }
    }
  }
}

extension MultipleRanges: Sequence {
  public typealias Element = AnyRange<Bound>
  
  public struct Iterator: IteratorProtocol {
    public typealias Element = MultipleRanges.Element
    private var _rangeDictionaryIterator: RangeDictionary<Bound, Void>.Iterator
    fileprivate init(_ rangeDictionaryIterator: RangeDictionary<Bound, Void>.Iterator) {
      self._rangeDictionaryIterator = rangeDictionaryIterator
    }
    
    public mutating func next() -> AnyRange<Bound>? {
      return self._rangeDictionaryIterator.next()?.0
    }
  }
  
  public func makeIterator() -> MultipleRanges<Bound>.Iterator {
    return .init(self._rangeDictionary.makeIterator())
  }
}

extension MultipleRanges: Collection, BidirectionalCollection, RandomAccessCollection {
  public typealias Index = RangeDictionary<Bound, Void>.Index
  
  public subscript(_ index: Index) -> AnyRange<Bound> {
    return self._rangeDictionary[index].0
  }
  
  public var startIndex: Index {
    return self._rangeDictionary.startIndex
  }
  
  public var endIndex: Index {
    return self._rangeDictionary.endIndex
  }
  
  public func index(after ii: Index) -> Index {
    return self._rangeDictionary.index(after: ii)
  }
  
  public func index(before ii: Index) -> Index {
    return self._rangeDictionary.index(before: ii)
  }
}

// Array Literal
extension MultipleRanges: ExpressibleByArrayLiteral {
  public typealias ArrayLiteralElement = AnyRange<Bound>
  public init(arrayLiteral elements: AnyRange<Bound>...) {
    self.init(elements)
  }
}

// Equatable
extension MultipleRanges: Equatable {
  public static func ==(lhs:MultipleRanges<Bound>, rhs:MultipleRanges<Bound>) -> Bool {
    return lhs._rangeDictionary == rhs._rangeDictionary
  }
}

// INSERT
extension MultipleRanges {
  private mutating func _insert(_ newRange: AnyRange<Bound>) {
    if newRange.isEmpty { return }
    self._rangeDictionary.insert(range: newRange)
  }
  
  /// Inserts the given *countable* range.
  /// The range may be concatenated with other ranges included the receiver.
  public mutating func insert<R>(_ newRange:R)
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    guard let bounds = newRange.bounds, _validateBounds(bounds) else { return }
    self._insert(AnyRange(uncheckedBounds: bounds))
  }
  
  /// Inserts the given range.
  /// The range may be concatenated with other ranges included the receiver.
  public mutating func insert<R>(_ newRange:R) where R:GeneralizedRange, R.Bound == Bound {
    self._insert(AnyRange(uncheckedBounds: newRange.bounds))
  }
  
  /// Inserts an empty range.
  public mutating func insert(_:()) {
    // do nothing
  }
  
  /// Inserts an unbounded range.
  public mutating func insert(_:UnboundedRange) {
    self._rangeDictionary = .init([(AnyRange<Bound>(...), ())])
  }
}

extension MultipleRanges where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Inserts a single *countable* value
  public mutating func insert(singleValue value:Bound) {
    self.insert(value...value)
  }
}
extension MultipleRanges {
  /// Inserts a single value
  public mutating func insert(singleValue value:Bound) {
    self.insert(value...value)
  }
}

// CONTAINS
extension MultipleRanges {
  /// Returns a Boolean value that indicates
  /// whether one of ranges in the receiver contains the value or not.
  public func contains(_ value:Bound) -> Bool {
    return self._rangeDictionary[value] != nil
  }
}

extension MultipleRanges: Hashable where Bound: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.ranges)
  }
}

// INTERSECTION
extension MultipleRanges {
  /// Update the ranges to be the intersection of each ranges
  /// in the receiver and the given instance.
  public mutating func formIntersection(_ other:MultipleRanges<Bound>) {
    self = self.intersection(other)
  }
  
  /// Returns a new instance with the ranges that are the intersection of each ranges
  /// in the receiver and the given instance.
  public func intersection(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newDic: RangeDictionary<Bound, Void> = .init()
    for otherRange in other {
      for (newRange, _) in self._rangeDictionary.limited(within: otherRange) {
        newDic.insert(range: newRange)
      }
    }
    return MultipleRanges(newDic)
  }
}

// SUBTRACT
extension MultipleRanges {
  /// Subtract `range` from each range in the receiver.
  /// They will be treated as countable ranges.
  public mutating func subtract<R>(_ range: R)
    where R: GeneralizedRange, R.Bound == Bound, Bound: Strideable, Bound.Stride: SignedInteger
  {
    self._rangeDictionary.remove(range: .init(range))
  }
  
  /// Subtract `range` from each range in the receiver.
  public mutating func subtract<R>(_ range: R)
    where R: GeneralizedRange, R.Bound == Bound
  {
    self._rangeDictionary.remove(range: .init(range))
  }
  
  /// Returns a new instance with the ranges subtracting `range` from each range in the receiver.
  /// They will be treated as countable ranges.
  public func subtracting<R>(_ range: R) -> MultipleRanges<Bound>
    where R: GeneralizedRange, R.Bound == Bound, Bound: Strideable, Bound.Stride: SignedInteger
  {
    var newRanges = self
    newRanges.subtract(range)
    return newRanges
  }
  
  /// Returns a new instance with the ranges subtracting `range` from each range in the receiver.
  public func subtracting<R>(_ range:R) -> MultipleRanges<Bound>
    where R:GeneralizedRange, R.Bound == Bound
  {
    var newRanges = self
    newRanges.subtract(range)
    return newRanges
  }
  
  /// Subtract the ranges in `other` from each range in the receiver.
  public mutating func subtract(_ other: MultipleRanges<Bound>) {
    for otherRange in other {
      self.subtract(otherRange)
    }
  }
  
  /// Returns a new instance with the ranges subtracting each range in `other` from
  /// each range in the receiver.
  public func subtracting(_ other: MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.subtract(other)
    return newRanges
  }
  
  /// Subtract the single value.
  public mutating func subtract(singleValue value:Bound) {
    self.subtract(value...value)
  }
  
  /// Returns a new instance with subtracting the single value.
  public func subtracting(singleValue value:Bound) -> MultipleRanges<Bound> {
    return self.subtracting(value...value)
  }
}

// SYMMETRIC DIFFERENCE
extension MultipleRanges {
  /// Same as formUnion but not including intersection.
  public mutating func formSymmetricDifference(_ other: MultipleRanges<Bound>) {
    let intersection = self.intersection(other)
    self.formUnion(other)
    self.subtract(intersection)
  }
  
  /// Same as `self.union(other).subtracting(self.intersection(other))`.
  public func symmetricDifference(_ other: MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formSymmetricDifference(other)
    return newRanges
  }
}

// UNION
extension MultipleRanges {
  /// Adds the ranges in the given instance.
  /// Ranges will be concatenated if possible.
  public mutating func formUnion(_ other: MultipleRanges<Bound>) {
    for otherRange in other {
      self._rangeDictionary.insert(range: otherRange)
    }
  }
  
  /// Returns a new instance with the ranges of both this and the given instance.
  /// Ranges will be concatenated if possible.
  public func union(_ other: MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formUnion(other)
    return newRanges
  }
}

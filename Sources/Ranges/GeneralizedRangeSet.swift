/* *************************************************************************************************
 MultipleRanges.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

/// Represents multiple ranges.
public struct GeneralizedRangeSet<Bound> where Bound: Comparable {
  internal private(set) var _ranges: _SortedRanges<Bound>

  private init(_ranges ranges: _SortedRanges<Bound>) {
    self._ranges = ranges
  }
  
  /// Creates an empty ranges.
  public init() {
    self.init(_ranges: .init(carefullySortedRanges: []))
  }
  
  /// Creates an instance initialized with `ranges`.
  ///
  /// - Warning: The ranges must be sorted in advance,
  ///            and all ranges must not be overlapped each other.
  ///            Furthermore, no ranges must be empty.
  ///            You may not use this initializer usually.
  public init(carefullySortedRanges ranges: [any GeneralizedRange<Bound>]) {
    self.init(_ranges: .init(carefullySortedRanges: ranges))
  }
  
  /// Creates an instace initialized with `ranges`.
  public init(_ ranges: [any GeneralizedRange<Bound>]) {
    var sortedRanges = _SortedRanges<Bound>(carefullySortedRanges: [])
    for range in ranges {
      sortedRanges.insertRange(range._wellknownRange)
    }
    self.init(_ranges: sortedRanges)
  }
}

@available(*, deprecated, renamed: "GeneralizedRangeSet")
public typealias MultipleRanges = GeneralizedRangeSet

extension GeneralizedRangeSet: Sendable where Bound: Sendable {
  /// Creates a `Sendable` instance initialized with `ranges`.
  ///
  /// - Warning: The ranges must be sorted in advance,
  ///            and all ranges must not be overlapped each other.
  ///            Furthermore, no ranges must be empty.
  ///            You may not use this initializer usually.
  public init(carefullySortedRanges ranges: [any GeneralizedRange<Bound> & Sendable]) {
    self.init(_ranges: .init(carefullySortedRanges: ranges))
  }
}

public typealias GeneralizedCountableRangeSet<Bound> =
  GeneralizedRangeSet<Bound> where Bound:Strideable, Bound.Stride:SignedInteger

@available(*, deprecated, renamed: "GeneralizedCountableRangeSet")
public typealias MultipleCountableRanges = GeneralizedCountableRangeSet

extension GeneralizedRangeSet {
  public var isEmpty:Bool { return self._ranges.isEmpty }
}

extension GeneralizedRangeSet {
  public var ranges: [any GeneralizedRange<Bound>] {
    get {
      guard case .ranges(let ranges) = self._ranges._storage else {
        fatalError("Unexpected storage.")
      }
      return ranges
    }
    set {
      self = Self.init(newValue)
    }
  }
}

extension GeneralizedRangeSet: Sequence {
  public typealias Element = any GeneralizedRange<Bound>

  public struct Iterator: IteratorProtocol {
    public typealias Element = GeneralizedRangeSet.Element
    private var _iterator: Array<any GeneralizedRange<Bound>>.Iterator
    fileprivate init(_ iterator: Array<any GeneralizedRange<Bound>>.Iterator) {
      self._iterator = iterator
    }
    
    public mutating func next() -> (any GeneralizedRange<Bound>)? {
      return self._iterator.next()
    }
  }
  
  public func makeIterator() -> GeneralizedRangeSet<Bound>.Iterator {
    return .init(self.ranges.makeIterator())
  }
}

extension GeneralizedRangeSet: Collection, BidirectionalCollection, RandomAccessCollection {
  public struct Index: Equatable, Comparable {
    fileprivate let _value: Int
    fileprivate init(_ value: Int) {
      self._value = value
    }

    public static func == (lhs: GeneralizedRangeSet<Bound>.Index, rhs: GeneralizedRangeSet<Bound>.Index) -> Bool {
      return lhs._value == rhs._value
    }

    public static func < (lhs: GeneralizedRangeSet<Bound>.Index, rhs: GeneralizedRangeSet<Bound>.Index) -> Bool {
      return lhs._value < rhs._value
    }
  }

  public subscript(_ index: Index) -> any GeneralizedRange<Bound> {
    return self._ranges.range(at: index._value)
  }
  
  public var startIndex: Index {
    return .init(0)
  }
  
  public var endIndex: Index {
    return .init(self._ranges.count)
  }
  
  public func index(after ii: Index) -> Index {
    return .init(ii._value + 1)
  }
  
  public func index(before ii: Index) -> Index {
    return .init(ii._value - 1)
  }
}

// Array Literal
extension GeneralizedRangeSet: ExpressibleByArrayLiteral {
  public typealias ArrayLiteralElement = any GeneralizedRange<Bound>
  public init(arrayLiteral elements: any GeneralizedRange<Bound>...) {
    self.init(elements)
  }
}

// Equatable
extension GeneralizedRangeSet: Equatable {
  public static func ==(lhs:GeneralizedRangeSet<Bound>, rhs:GeneralizedRangeSet<Bound>) -> Bool {
    return lhs._ranges == rhs._ranges
  }
}

// INSERT
extension GeneralizedRangeSet {
  /// Inserts the given range.
  ///
  /// The range may be concatenated with other ranges included the receiver if `normalize` is `true`.
  @available(*, deprecated, message: "`GeneralizedRangeSet` is always normalized.")
  public mutating func insert<R>(
    _ newRange:R,
    normalize: Bool
  ) where R:GeneralizedRange, R.Bound == Bound {
    self._ranges.insertRange(newRange)
    if normalize {
      self._ranges = self._ranges.normalized()
    }
  }

  /// Inserts the given range.
  ///
  /// The range may be concatenated with other ranges included the receiver.
  public mutating func insert<R>(_ newRange:R) where R:GeneralizedRange, R.Bound == Bound {
    self._ranges.insertRange(newRange)
  }
  
  /// Inserts an empty range.
  public mutating func insert(_:()) {
    // do nothing
  }
  
  /// Inserts an unbounded range.
  public mutating func insert(_:UnboundedRange) {
    self._ranges = .init(carefullySortedRanges: [TangibleUnboundedRange<Bound>()])
  }
}

extension GeneralizedRangeSet {
  /// Inserts a single value
  public mutating func insert(singleValue value:Bound) {
    self.insert(value...value)
  }
}

// CONTAINS
extension GeneralizedRangeSet {
  /// Returns a Boolean value that indicates
  /// whether one of ranges in the receiver contains the value or not.
  public func contains(_ value:Bound) -> Bool {
    return self._ranges.contains(value)
  }
}

extension GeneralizedRangeSet: Hashable where Bound: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self._ranges)
  }
}

// INTERSECTION
extension GeneralizedRangeSet {
  /// Returns a new instance with the ranges that are the intersection of each ranges
  /// in the receiver and the given instance.
  public func intersection(_ other: GeneralizedRangeSet<Bound>) -> GeneralizedRangeSet<Bound> {
    var newRanges = _SortedRanges<Bound>(carefullySortedRanges: [])
    for otherRange in other {
      let intersection = self._ranges.limited(within: otherRange)
      for ii in 0..<intersection.count {
        newRanges.insertRange(intersection.range(at: ii))
      }
    }
    return GeneralizedRangeSet<Bound>(_ranges: newRanges)
  }

  /// Update the ranges to be the intersection of each ranges
  /// in the receiver and the given instance.
  public mutating func formIntersection(_ other:GeneralizedRangeSet<Bound>) {
    self = self.intersection(other)
  }
}

// SUBTRACT
extension GeneralizedRangeSet {
  /// Subtract `range` from each range in the receiver.
  public mutating func subtract<R>(_ range: R) where R: GeneralizedRange, R.Bound == Bound {
    self._ranges.removeRange(range)
  }

  /// Returns a new instance with the ranges subtracting `range` from each range in the receiver.
  public func subtracting<R>(_ range:R) -> GeneralizedRangeSet<Bound>
    where R:GeneralizedRange, R.Bound == Bound
  {
    var newRanges = self
    newRanges.subtract(range)
    return newRanges
  }
  
  /// Subtract the ranges in `other` from each range in the receiver.
  public mutating func subtract(_ other: GeneralizedRangeSet<Bound>) {
    for otherRange in other {
      self.subtract(otherRange)
    }
  }
  
  /// Returns a new instance with the ranges subtracting each range in `other` from
  /// each range in the receiver.
  public func subtracting(_ other: GeneralizedRangeSet<Bound>) -> GeneralizedRangeSet<Bound> {
    var newRanges = self
    newRanges.subtract(other)
    return newRanges
  }
  
  /// Subtract the single value.
  public mutating func subtract(singleValue value:Bound) {
    self.subtract(value...value)
  }
  
  /// Returns a new instance with subtracting the single value.
  public func subtracting(singleValue value:Bound) -> GeneralizedRangeSet<Bound> {
    return self.subtracting(value...value)
  }
}

// SYMMETRIC DIFFERENCE
extension GeneralizedRangeSet {
  /// Same as formUnion but not including intersection.
  public mutating func formSymmetricDifference(_ other: GeneralizedRangeSet<Bound>) {
    let intersection = self.intersection(other)
    self.formUnion(other)
    self.subtract(intersection)
  }
  
  /// Same as `self.union(other).subtracting(self.intersection(other))`.
  public func symmetricDifference(_ other: GeneralizedRangeSet<Bound>) -> GeneralizedRangeSet<Bound> {
    var newRanges = self
    newRanges.formSymmetricDifference(other)
    return newRanges
  }
}

// UNION
extension GeneralizedRangeSet {
  /// Adds the ranges in the given instance.
  /// Ranges will be concatenated if possible.
  public mutating func formUnion(_ other: GeneralizedRangeSet<Bound>) {
    for otherRange in other {
      self._ranges.insertRange(otherRange)
    }
  }
  
  /// Returns a new instance with the ranges of both this and the given instance.
  /// Ranges will be concatenated if possible.
  public func union(_ other: GeneralizedRangeSet<Bound>) -> GeneralizedRangeSet<Bound> {
    var newRanges = self
    newRanges.formUnion(other)
    return newRanges
  }
}

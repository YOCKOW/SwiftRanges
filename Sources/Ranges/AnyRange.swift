/***************************************************************************************************
 AnyRange.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

/// # AnyRange<Bound>
///
/// A type-erased range of `Bound`.
public struct AnyRange<Bound> where Bound:Comparable {
  private let _bounds: Bounds<Bound>?
  
  private init(checkedBounds:Bounds<Bound>?) {
    // `checkedBounds` must have been checked for its validity before this initializer is called.
    self._bounds = checkedBounds
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Creates a *countable* range.
  /// Pass `nil` if you want to create a instance that represents an empty range.
  public init(uncheckedBounds: Bounds<Bound>?) {
    if let bounds = uncheckedBounds, _validateBounds(bounds) {
      self.init(checkedBounds: bounds)
    } else {
      self.init(checkedBounds: nil)
    }
  }
}

extension AnyRange {
  /// Creates a range.
  /// Pass `nil` if you want to create a instance that represents an empty range.
  public init(uncheckedBounds: Bounds<Bound>?) {
    if let bounds = uncheckedBounds, _validateBounds(bounds) {
      self.init(checkedBounds: bounds)
    } else {
      self.init(checkedBounds: nil)
    }
  }
}

extension AnyRange {
  /// Creates a *countable* range from `range`.
  public init<T>(_ range:T)
    where T:GeneralizedRange, T.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    if case let any as AnyRange<Bound> = range {
      // `bounds` must have been already checked if it is an instance of `AnyRange`.
      self.init(checkedBounds:any.bounds)
    } else {
      self.init(uncheckedBounds:range.bounds)
    }
  }
  
  /// Creates a range form `range`.
  public init<T>(_ range:T) where T:GeneralizedRange, T.Bound == Bound {
    if case let any as AnyRange<Bound> = range {
      // `bounds` must have been already checked if it is an instance of `AnyRange`.
      self.init(checkedBounds:any.bounds)
    } else {
      self.init(uncheckedBounds:range.bounds)
    }
  }
}

extension AnyRange {
  /// Creates a range that contains only the indicated value.
  public init(singleValue:Bound) {
    self.init(singleValue...singleValue)
  }
}

extension AnyRange {
  /// Creates an empty range.
  public init() {
    self.init(checkedBounds:nil)
  }
  
  /// Creates an unbounded range.
  public init(_:UnboundedRange) {
    self.init(checkedBounds: (lower: .unbounded, upper: .unbounded))
  }
  
  /// An instance of `AnyRange` representing an empty range.
  public static var empty: AnyRange<Bound> { return AnyRange<Bound>() }
  
  /// An instance of `AnyRange` representing an unbounded range.
  public static var unbounded: AnyRange<Bound> { return AnyRange<Bound>(...) }
}

extension AnyRange: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return self._bounds
  }
}

extension AnyRange {
  public var isEmpty: Bool { return self._bounds == nil }
  public var isUnbounded: Bool {
    guard let bounds = self._bounds else { return false }
    return bounds.lower == .unbounded && bounds.upper == .unbounded
  }
}

extension AnyRange: Equatable {
  public static func ==(lhs:AnyRange, rhs:AnyRange) -> Bool {
    return lhs.compare(rhs) == .orderedSame
  }
}

extension AnyRange: Hashable, HashableRange where Bound: Hashable {}

extension AnyRange: CustomStringConvertible, CustomStringConvertibleRange where Bound: CustomStringConvertible {}

/***************************************************************************************************
 AnyRange.swift
   © 2018 YOCKOW.
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
  
  private init(_uncheckedBounds:Bounds<Bound>?) {
    guard let lower = _uncheckedBounds?.lower, let upper = _uncheckedBounds?.upper else {
      // Not required to be checked for its emptiness.
      self.init(checkedBounds:_uncheckedBounds)
      return
    }
    
    guard lower.bound <= upper.bound else {
      self.init(checkedBounds:nil)
      return
    }
    
    if lower.bound == upper.bound {
      guard lower.isIncluded && upper.isIncluded else {
        self.init(checkedBounds:nil)
        return
      }
    }
    
    // true is...
    // `lower.bound < upper.bound` or
    // `lower.bound == upper.bound && lower.isIncluded && upper.isIncluded`
    self.init(checkedBounds:_uncheckedBounds)
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Creates a *countable* range.
  /// Pass `nil` if you want to create a instance that represents an empty range.
  public init(uncheckedBounds bounds:Bounds<Bound>?) {
    // Emptiness of Open Range depends on countability.
    if let lower = bounds?.lower, let upper = bounds?.upper, !lower.isIncluded, !upper.isIncluded {
      // It is OpenRange<Bound>.
      if OpenRange<Bound>(uncheckedBounds:(lower:lower.bound, upper:upper.bound)).isEmpty {
        self.init(uncheckedBounds:nil)
        return
      }
    }
    self.init(_uncheckedBounds:bounds)
  }
}

extension AnyRange {
  /// Creates a range.
  /// Pass `nil` if you want to create a instance that represents an empty range.
  public init(uncheckedBounds bounds: Bounds<Bound>?) {
    self.init(_uncheckedBounds:bounds)
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
  /// Creates an empty range.
  public init() {
    self.init(checkedBounds:nil)
  }
  
  /// Creates an unbounded range.
  public init(_:UnboundedRange) {
    self.init(checkedBounds:(lower:nil, upper:nil))
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
    return bounds.lower == nil && bounds.upper == nil
  }
}

extension AnyRange: Equatable {
  public static func ==(lhs:AnyRange, rhs:AnyRange) -> Bool {
    return lhs.compare(rhs) == .orderedSame
  }
}

extension AnyRange:Hashable where Bound:Hashable {
  public func hash(into hasher:inout Hasher) {
    hasher.combine(self.bounds?.lower)
    hasher.combine(self.bounds?.upper)
  }
}

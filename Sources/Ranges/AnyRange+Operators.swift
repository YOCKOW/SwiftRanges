/* *************************************************************************************************
 AnyRange+Operators.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

prefix operator ....
postfix operator ....
prefix operator ...<
infix operator ....: RangeFormationPrecedence
infix operator ...<: RangeFormationPrecedence

/* ***** CLOSED RANGE ***** */
extension Comparable {
  /// Creates an instance of `AnyRange` that represents a closed range.
  @inlinable
  public static func ....(lhs: Self, rhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .included(lhs), upper: .included(rhs)))
  }
}
extension Strideable where Self.Stride: SignedInteger {
  /// Creates an instance of `AnyRange` that represents a *countable* closed range.
  @inlinable
  public static func ....(lhs: Self, rhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .included(lhs), upper: .included(rhs)))
  }
}

/* ***** LEFT OPEN RANGE ***** */
extension ExcludedLowerBound {
  /// Creates an instance of `AnyRange` that represents a left open range.
  @inlinable
  public static func ...(lhs: ExcludedLowerBound, rhs: Bound) -> AnyRange<Bound> {
    return AnyRange<Bound>(uncheckedBounds: (lower: .excluded(lhs.lowerBound),
                                             upper: .included(rhs)))
  }
}
extension ExcludedLowerBound where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Creates an instance of `AnyRange` that represents a *countable* left open range.
  @inlinable
  public static func ...(lhs: ExcludedLowerBound, rhs: Bound) -> AnyRange<Bound> {
    return AnyRange<Bound>(uncheckedBounds: (lower: .excluded(lhs.lowerBound),
                                             upper: .included(rhs)))
  }
}

/* ***** OPEN RANGE ***** */
extension ExcludedLowerBound {
  /// Creates an instance of `AnyRange` that represents a left open range.
  @inlinable
  public static func ...<(lhs: ExcludedLowerBound, rhs: Bound) -> AnyRange<Bound> {
    return AnyRange<Bound>(uncheckedBounds: (lower: .excluded(lhs.lowerBound),
                                             upper: .excluded(rhs)))
  }
}
extension ExcludedLowerBound where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Creates an instance of `AnyRange` that represents a *countable* left open range.
  @inlinable
  public static func ...<(lhs: ExcludedLowerBound, rhs: Bound) -> AnyRange<Bound> {
    return AnyRange<Bound>(uncheckedBounds: (lower: .excluded(lhs.lowerBound),
                                             upper: .excluded(rhs)))
  }
}

/* ***** PARTIAL RANGE FROM ***** */
extension Comparable {
  /// Creates an instance of `AnyRange` that represents a partial range "from".
  @inlinable
  public static postfix func ....(lhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .included(lhs), upper: .unbounded))
  }
}
extension Strideable where Self.Stride: SignedInteger {
  /// Creates an instance of `AnyRange` that represents a *countable* partial range "from".
  @inlinable
  public static postfix func ....(lhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .included(lhs), upper: .unbounded))
  }
}

/* ***** PARTIAL RANGE GREATER THAN ***** */
extension ExcludedLowerBound {
  /// Creates an instance of `AnyRange` that represents a partial range "greather than".
  @inlinable
  public static postfix func ...(lhs: ExcludedLowerBound) -> AnyRange<Bound> {
    return AnyRange<Bound>(uncheckedBounds: (lower: .excluded(lhs.lowerBound), upper: .unbounded))
  }
}
extension ExcludedLowerBound where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Creates an instance of `AnyRange` that represents a *countable* partial range "greather than".
  @inlinable
  public static postfix func ...(lhs: ExcludedLowerBound) -> AnyRange<Bound> {
    return AnyRange<Bound>(uncheckedBounds: (lower: .excluded(lhs.lowerBound), upper: .unbounded))
  }
}

/* ***** PARTIAL RANGE THROUGH ***** */
extension Comparable {
  /// Creates an instance of `AnyRange` that represents a partial range "through".
  @inlinable
  public static prefix func ....(rhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .unbounded, upper: .included(rhs)))
  }
}
extension Strideable where Self.Stride: SignedInteger {
  /// Creates an instance of `AnyRange` that represents a *countable* partial range "through".
  @inlinable
  public static prefix func ....(rhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .unbounded, upper: .included(rhs)))
  }
}

/* ***** PARTIAL RANGE UP TO ***** */
extension Comparable {
  /// Creates an instance of `AnyRange` that represents a partial range "up to".
  @inlinable
  public static prefix func ...<(rhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .unbounded, upper: .excluded(rhs)))
  }
}
extension Strideable where Self.Stride: SignedInteger {
  /// Creates an instance of `AnyRange` that represents a *countable* partial range "up to".
  @inlinable
  public static prefix func ...<(rhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .unbounded, upper: .excluded(rhs)))
  }
}

/* ***** RANGE ***** */
extension Comparable {
  /// Creates an instance of `AnyRange` that represents a range.
  @inlinable
  public static func ...<(lhs: Self, rhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .included(lhs), upper: .excluded(rhs)))
  }
}
extension Strideable where Self.Stride: SignedInteger {
  /// Creates an instance of `AnyRange` that represents a *countable* range.
  @inlinable
  public static func ...<(lhs: Self, rhs: Self) -> AnyRange<Self> {
    return AnyRange<Self>(uncheckedBounds: (lower: .included(lhs), upper: .excluded(rhs)))
  }
}

/***************************************************************************************************
 GeneralizedRange+Comparison.swift
   © 2018-2019,2025-2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import Foundation
 
extension GeneralizedRange {
  /// Compare two ranges.
  /// This function is declared as public, but it is intended to be used internally.
  ///
  /// ## Comparison Rules for GeneralizedRange:
  /// 1. Unbounded Range < [others] < Empty Range
  /// 2. (If they are not unbounded nor empty,)
  ///    First, compare their lower bounds.
  ///    Next, compare their upper bounds if the lower bounds are equal.
  /// 3. Regard `PartialRange(From|GreaterThan)`'s upper bound as +∞.
  /// 4. Regard `PartialRange(Through|UpTo)`'s lower bound as -∞.
  public func compare<T>(_ other:T) -> ComparisonResult
    where T:GeneralizedRange, T.Bound == Self.Bound
  {
    let myNilableBounds = self.bounds
    let otherNilableBounds = other.bounds
    
    // If one of them is empty...
    switch (myNilableBounds, otherNilableBounds) {
    case (nil, nil):
      return .orderedSame
    case (nil, _):
      return .orderedDescending
    case (_, nil):
      return .orderedAscending
    default:
      break
    }
    
    let myBounds = myNilableBounds!
    let otherBounds = otherNilableBounds!
    
    let lowerComparison = myBounds.lower._compare(otherBounds.lower, side: .lower)
    if lowerComparison != .definitelyOrderedSame {
      return lowerComparison.foundationComparisonResult
    }
    return myBounds.upper._compare(otherBounds.upper, side: .upper).foundationComparisonResult
  }

  @inlinable
  public func compare(_: ()) -> ComparisonResult {
    return self.compare(EmptyRange<Bound>())
  }

  @inlinable
  public func compare(_: UnboundedRange) -> ComparisonResult {
    return self.compare(TangibleUnboundedRange<Bound>())
  }
}

extension GeneralizedRange {
  /// Returns a Boolean value indicating whether the range is equal to `other`.
  /// Countability is not considered.
  public func isEqual<R>(to other: R) -> Bool where R: GeneralizedRange, R.Bound == Bound {
    return self.compare(other) == .orderedSame
  }

  public func isEqual(to: ()) -> Bool {
    return self.isEmpty
  }

  public func isEqual(to: UnboundedRange) -> Bool {
    guard let bounds = self.bounds else {
      return false
    }
    return bounds.lower == .unbounded && bounds.upper == .unbounded
  }

  /// Returns a Boolean value indicating whether the range can be considered equivalent to `other`.
  /// Countability is considered so that `(0..<100).isEquivalent(to: 0...99)` returns `true`.
  public func isEquivalent<R>(to other: R) -> Bool where R: GeneralizedRange, R.Bound == Bound {
    guard let myBounds = self.bounds, let otherBounds = other.bounds else {
      return self.isEqual(to: other)
    }

    let lowerComparison = myBounds.lower._compare(otherBounds.lower, side: .lower)
    let upperComparison = myBounds.upper._compare(otherBounds.upper, side: .upper)
    return (
      lowerComparison == .orderedAscendingButConsideredEquivalent ||
      lowerComparison == .definitelyOrderedSame ||
      lowerComparison == .orderedDescendingButConsideredEquivalent
    ) && (
      upperComparison == .orderedAscendingButConsideredEquivalent ||
      upperComparison == .definitelyOrderedSame ||
      upperComparison == .orderedDescendingButConsideredEquivalent
    )
  }
}

internal extension GeneralizedRange {
  func _isLessThanAndApartFrom(_ other: any GeneralizedRange<Bound>) -> Bool {
    return self.compare(other) == .orderedAscending && !self.overlaps(other) 
  }
}

@available(*, deprecated, message: "Comparison operators are deprecated. Use `.isEqual(to:)` instead.")
extension Optional where Wrapped: GeneralizedRange {
  public static func ==<R>(lhs: Optional, rhs: R?) -> Bool
    where R: GeneralizedRange, Wrapped.Bound == R.Bound
  {
    guard let range1 = lhs, let range2 = rhs else {
      return lhs == Optional<Wrapped>.none && rhs == Optional<R>.none
    }
    return range1.compare(range2) == .orderedSame
  }
  
  public static func !=<R>(lhs: Optional, rhs: R?) -> Bool
    where R: GeneralizedRange, Wrapped.Bound == R.Bound
  {
    return !(lhs == rhs)
  }
}

@available(*, deprecated, message: "Comparison operators are deprecated. Use `.compare(_:)` instead.")
extension GeneralizedRange {
  public static func < <T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return lhs.compare(rhs) == .orderedAscending
  }
  
  
  public static func >= <T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return !(lhs < rhs)
  }
  
  public static func > <T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return lhs.compare(rhs) == .orderedDescending
  }
  
  public static func <= <T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return !(lhs < rhs)
  }
}

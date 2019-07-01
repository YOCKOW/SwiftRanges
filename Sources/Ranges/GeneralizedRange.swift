/***************************************************************************************************
 GeneralizedRange.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


/// Represents a set of a lower bound and an upper bound.
public typealias Bounds<Bound> =
  (lower: Boundary<Bound>, upper: Boundary<Bound>) where Bound: Comparable

/// A protocol for all ranges.
public protocol GeneralizedRange: RangeExpression {
  /// Retunrs a set of a lower bound and an upper bound, or returns `nil` if the range is empty.
  var bounds: Bounds<Bound>? { get }
}

internal func __validateBounds<Bound>(_ uncheckedBounds: Bounds<Bound>) -> Bool where Bound: Comparable {
  switch (uncheckedBounds.lower, uncheckedBounds.upper) {
  case (.unbounded, _), (_, .unbounded):
    return true
  case (.included(let lower), .included(let upper)):
    return lower <= upper
  case (.included(let lower), .excluded(let upper)),
       (.excluded(let lower), .included(let upper)),
       (.excluded(let lower), .excluded(let upper)):
    return lower < upper
  }
}

/// Returns true if the range represented by the bounds is not empty.
internal func _validateBounds<Bound>(_ uncheckedBounds: Bounds<Bound>) -> Bool where Bound: Comparable {
  return __validateBounds(uncheckedBounds)
}

/// Returns true if the **countable** range represented by the bounds is not empty.
internal func _validateBounds<Bound>(_ uncheckedBounds: Bounds<Bound>) -> Bool
  where Bound: Strideable, Bound.Stride: SignedInteger
{
  if case .excluded(let lower) = uncheckedBounds.lower,
     case .excluded(let upper) = uncheckedBounds.upper
  {
    return lower.distance(to: upper) > 1
  }
  return __validateBounds(uncheckedBounds)
}


// Default implementation for functions that are required by `RangeExpression`
extension GeneralizedRange {
  public func contains(_ element:Bound) -> Bool {
    guard let bounds = self.bounds else { return false }
    
    let lowerComparison = bounds.lower._compare(element, side: .lower)
    let upperComparison = bounds.upper._compare(element, side: .upper)
    return (
      (lowerComparison == .orderedSame || lowerComparison == .orderedAscending)
      &&
      (upperComparison == .orderedSame || upperComparison == .orderedDescending)
    )
  }
  
  public func relative<C>(to collection: C) -> Range<Bound> where C:Collection, Bound == C.Index {
    guard let bounds = self.bounds else { return collection.startIndex..<collection.startIndex }
    
    let start: Bound = ({
      switch $0 {
      case .unbounded: return collection.startIndex
      case .included(let value): return value
      case .excluded(let value): return collection.index(after: value)
      }
    })(bounds.lower)
    
    let end: Bound = ({
      switch $0 {
      case .unbounded: return collection.endIndex
      case .included(let value): return collection.index(after: value)
      case .excluded(let value): return value
      }
    })(bounds.upper)
    
    return start..<end
  }
}

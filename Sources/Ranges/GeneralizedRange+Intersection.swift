/***************************************************************************************************
 GeneralizedRange+Intersection.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

private func _intersection<Bound>(_ lb:Bounds<Bound>?, _ rb:Bounds<Bound>?) -> Bounds<Bound>?
  where Bound: Comparable
{
  guard let leftBounds = lb, let rightBounds = rb else {
    // When at least one of them is empty, the intersection is also empty.
    return nil
  }
  
  let lower = _max(leftBounds.lower, rightBounds.lower, side: .lower)
  let upper = _min(leftBounds.upper, rightBounds.upper, side: .upper)
  
  return (lower:lower, upper:upper) // unchecked
}

extension GeneralizedRange {
  /// Returns a new *countable* range that is an intersection of `self` and `other`.
  public func intersection<R>(_ other:R) -> AnyRange<Bound>
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return AnyRange(uncheckedBounds:_intersection(self.bounds, other.bounds))
  }
  
  /// Returns a new range that is an intersection of `self` and `other`.
  public func intersection<R>(_ other:R) -> AnyRange<Bound>
    where R:GeneralizedRange, R.Bound == Bound
  {
    return AnyRange(uncheckedBounds:_intersection(self.bounds, other.bounds))
  }
  
  /// Returns `.empty`.
  public func intersection(_:()) -> AnyRange<Bound> {
    return .empty
  }
  
  /// Returns `AnyRange<Bound>(self)`
  public func intersection(_:UnboundedRange) -> AnyRange<Bound> {
    return AnyRange<Bound>(self)
  }
}

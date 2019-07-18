/***************************************************************************************************
 GeneralizedRange+Intersection.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension GeneralizedRange {
  /// Returns a new *countable* range that is an intersection of `self` and `other`.
  public func intersection<R>(_ other:R) -> AnyRange<Bound>
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return AnyRange<Bound>(self).intersection(AnyRange<Bound>(other))
  }
  
  /// Returns a new range that is an intersection of `self` and `other`.
  public func intersection<R>(_ other:R) -> AnyRange<Bound>
    where R:GeneralizedRange, R.Bound == Bound
  {
    return AnyRange<Bound>(self).intersection(AnyRange<Bound>(other))
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

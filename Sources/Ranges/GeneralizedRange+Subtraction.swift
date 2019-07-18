/***************************************************************************************************
 GeneralizedRange+Subtraction.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension GeneralizedRange {
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  /// They are handled as countable ranges.
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return AnyRange<Bound>(self).subtracting(AnyRange<Bound>(other))
  }
  
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound
  {
    return AnyRange<Bound>(self).subtracting(AnyRange<Bound>(other))
  }
}

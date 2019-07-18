/***************************************************************************************************
 GeneralizedRange+Concatenation.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension GeneralizedRange {
  /// Concatenate two ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  public func concatenating<R>(_ other:R) -> AnyRange<Bound>?
    where R: GeneralizedRange, R.Bound == Self.Bound
  {
    return AnyRange(self).concatenating(.init(other))
  }
  
  /// Concatenate two **countable** ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  public func concatenating<R>(_ other:R) -> AnyRange<Bound>?
    where R: GeneralizedRange, R.Bound == Self.Bound,
          R.Bound: Strideable, R.Bound.Stride: SignedInteger
  {
    return AnyRange(self).concatenating(.init(other))
  }
  
  /// Returns `AnyRange<Bound>(self)`
  public func concatenating(_:()) -> AnyRange<Bound>? {
    return AnyRange<Bound>(self)
  }
  
  /// Returns `.unbounded`
  public func concatenating(_:UnboundedRange) -> AnyRange<Bound>? {
    return .unbounded
  }
}

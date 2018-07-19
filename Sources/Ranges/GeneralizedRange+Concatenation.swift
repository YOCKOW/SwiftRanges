/***************************************************************************************************
 GeneralizedRange+Concatenation.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


///
/// Returns whether the two points are concatenatable or not.
/// - parameter upper: The upper bound of a range.
/// - parameter lower: The lower bound of another range.
private func _concatenatable<Bound>(upper:Boundary<Bound>?, lower:Boundary<Bound>?) -> Bool {
  guard let upperBound = upper, let lowerBound = lower else {
    // if one of them is nil, it's concatenatable.
    return true
  }
  
  // Check if
  // ------/
  //    /-------
  
  if upperBound.bound < lowerBound.bound { return false }
  if upperBound.bound > lowerBound.bound { return true }
  return upperBound.isIncluded || lowerBound.isIncluded
}

private func _concatenating<Bound>(_ b0:Bounds<Bound>, _ b1:Bounds<Bound>) -> Bounds<Bound>?
  where Bound: Comparable
{
  guard _concatenatable(upper:b0.upper, lower:b1.lower) &&
        _concatenatable(upper:b1.upper, lower:b0.lower)
    else
  {
      return nil
  }
  
  return (lower:_min(b0.lower, b1.lower, as:.lower),
          upper:_max(b0.upper, b1.upper, as:.upper))
}
 
extension GeneralizedRange {
  /// Concatenate two ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  /// *This method is independent on countability*
  public func concatenating<R>(_ other:R) -> AnyRange<Bound>?
    where R:GeneralizedRange, R.Bound == Bound
  {
    if self == other || other.bounds == nil { return AnyRange<Bound>(self) }
    if self.bounds == nil { return AnyRange<Bound>(other) }
    
    guard let bounds = _concatenating(self.bounds!, other.bounds!) else { return nil }
    return AnyRange(uncheckedBounds:bounds)
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

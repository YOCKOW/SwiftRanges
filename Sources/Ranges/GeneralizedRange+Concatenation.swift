/***************************************************************************************************
 GeneralizedRange+Concatenation.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension Boundary {
  /// Returns whether the two points are concatenatable or not.
  /// **`self` must be upper bound.**
  /// - parameter otherLowerBound: The lower bound of another range.
  fileprivate func __isConcatenatable(with otherLowerBound: Boundary<Value>) -> Bool {
    // always concatenatable when self or the lower bound is .unbounded
    guard let myValue = self.value, let otherLowerValue = otherLowerBound.value else { return true }
    
    
    // Check if
    // ------/
    //    /-------
    if myValue < otherLowerValue { return false }
    if myValue > otherLowerValue { return true }
    
    // if myValue == otherLowerValue
    if case (.excluded, .excluded) = (self, otherLowerBound) { return false }
    return true
  }
  
  /// Returns whether the two points are concatenatable or not.
  fileprivate func _isConcatenatable(with otherLowerBound: Boundary<Value>) -> Bool {
    return self.__isConcatenatable(with: otherLowerBound)
  }
}

extension Boundary where Value: Strideable, Value.Stride: SignedInteger {
  /// Returns whether the two points are concatenatable or not.
  /// They are considered as **countable**.
  fileprivate func _isConcatenatable(with otherLowerBound: Boundary<Value>) -> Bool {
    switch (self, otherLowerBound) {
    case (.included(let myValue), .included(let otherValue)):
      if myValue.distance(to: otherValue) <= 1 { return true }
      return false
    default:
      return self.__isConcatenatable(with: otherLowerBound)
    }
  }
}

/// Concatenate bounds.
private func _concatenating<Bound>(_ b0:Bounds<Bound>, _ b1:Bounds<Bound>) -> Bounds<Bound>?
  where Bound: Comparable
{
  guard b0.upper._isConcatenatable(with: b1.lower) && b1.upper._isConcatenatable(with: b0.lower) else {
    return nil
  }
  
  return (lower: _min(b0.lower, b1.lower, side: .lower),
          upper: _max(b0.upper, b1.upper, side: .upper))
}

/// Concatenate **countable** bounds.
private func _concatenating<Bound>(_ b0:Bounds<Bound>, _ b1:Bounds<Bound>) -> Bounds<Bound>?
  where Bound: Strideable, Bound.Stride: SignedInteger
{
  guard b0.upper._isConcatenatable(with: b1.lower) && b1.upper._isConcatenatable(with: b0.lower) else {
    return nil
  }
  
  return (lower: _min(b0.lower, b1.lower, side: .lower),
          upper: _max(b0.upper, b1.upper, side: .upper))
}
 
extension GeneralizedRange {
  private func _simplyConcatenating<R>(_ other: R) -> AnyRange<Bound>?
    where R: GeneralizedRange, R.Bound == Self.Bound
  {
    if self == other || other.bounds == nil { return AnyRange<Bound>(self) }
    if self.bounds == nil { return AnyRange<Bound>(other) }
    return nil
  }
  
  /// Concatenate two ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  public func concatenating<R>(_ other:R) -> AnyRange<Bound>?
    where R: GeneralizedRange, R.Bound == Self.Bound
  {
    if let simplyConcatenated = self._simplyConcatenating(other) { return simplyConcatenated }
    guard let bounds = _concatenating(self.bounds!, other.bounds!) else { return nil }
    return AnyRange(uncheckedBounds:bounds)
  }
  
  /// Concatenate two **countable** ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  public func concatenating<R>(_ other:R) -> AnyRange<Bound>?
    where R: GeneralizedRange, R.Bound == Self.Bound,
          R.Bound: Strideable, R.Bound.Stride: SignedInteger
  {
    if let simplyConcatenated = self._simplyConcatenating(other) { return simplyConcatenated }
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

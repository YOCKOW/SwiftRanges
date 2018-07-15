/***************************************************************************************************
 GeneralizedRange+Intersection.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension Boundary {
  fileprivate func _isApartFrom(_ other:Boundary<Bound>) -> Bool {
    // self is upper, other is lower...
    if self.bound < other.bound { return true }
    if self.bound > other.bound { return false }
    
    // From here self.bound == other.bound
    if self.isIncluded && other.isIncluded { return false }
    return true
  }
}

extension AnyRange {
  /// intersection that is independent on countability
  fileprivate func _intersection(_ other:AnyRange<Bound>) -> AnyRange<Bound>? {
    if self == other || other.isUnbounded { return self }
    if self.isEmpty || other.isEmpty { return .empty }
    if self.isUnbounded { return other }
    
    let (left, right) = self < other ? (self, other) : (other, self)
    
    let leftBounds = left.bounds!
    let rightBounds = right.bounds!
    
    if let leftUpper = leftBounds.upper,
      let rightLower = rightBounds.lower,
      leftUpper._isApartFrom(rightLower)
    {
      // No overlap
      return .empty
    }
    
    return nil
  }
}

extension GeneralizedRange {
  /// Returns a new *countable* range that is an intersection of `self` and `other`.
  public func intersection<R>(_ other:R) -> AnyRange<Bound>
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    if let range = AnyRange<Bound>(self)._intersection(AnyRange<Bound>(other)) { return range }
    
    let lower = Boundary<Bound>._max(self.bounds?.lower, other.bounds?.lower, as:.lower)
    let upper = Boundary<Bound>._min(self.bounds?.upper, other.bounds?.upper, as:.upper)
    return AnyRange(uncheckedBounds:(lower:lower, upper:upper))
  }
  
  /// Returns a new range that is an intersection of `self` and `other`.
  public func intersection<R>(_ other:R) -> AnyRange<Bound>
    where R:GeneralizedRange, R.Bound == Bound
  {
    if let range = AnyRange<Bound>(self)._intersection(AnyRange<Bound>(other)) { return range }
    
    let lower = Boundary<Bound>._max(self.bounds?.lower, other.bounds?.lower, as:.lower)
    let upper = Boundary<Bound>._min(self.bounds?.upper, other.bounds?.upper, as:.upper)
    return AnyRange(uncheckedBounds:(lower:lower, upper:upper))
  }
}

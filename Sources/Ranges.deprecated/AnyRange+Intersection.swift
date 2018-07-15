/***************************************************************************************************
 AnyRange+Intersection.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension AnyRange {
  private func _intersection_particularCases(_ other:AnyRange) -> AnyRange? {
    if self == other || other.isUnboundedRange { return self }
    if self.isEmpty || other.isEmpty { return .empty }
    if self.isUnboundedRange { return other }
    
    return nil
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Returns a new range with the elements that are common to both this range and the given range.
  /// They are handled as countable ranges.
  public func intersection(_ other:AnyRange) -> AnyRange {
    if let range = self._intersection_particularCases(other) { return range }
    
    guard self.overlaps(other) else { return .empty }
    
    let myBounds = self.bounds!
    let otherBounds = other.bounds!
    
    let lower = AnyRange.BoundRepresentation._max(myBounds.lower, otherBounds.lower, as:.lower)
    let upper = AnyRange.BoundRepresentation._min(myBounds.upper, otherBounds.upper, as:.upper)
    
    return AnyRange(uncheckedBounds:(lower:lower, upper:upper))
  }
}

extension AnyRange {
  /// Returns a new range with the elements that are common to both this range and the given range.
  public func intersection(_ other:AnyRange) -> AnyRange {
    if let range = self._intersection_particularCases(other) { return range }
    
    guard self.overlaps(other) else { return .empty }
    
    let myBounds = self.bounds!
    let otherBounds = other.bounds!
    
    let lower = AnyRange.BoundRepresentation._max(myBounds.lower, otherBounds.lower, as:.lower)
    let upper = AnyRange.BoundRepresentation._min(myBounds.upper, otherBounds.upper, as:.upper)
    
    return AnyRange(uncheckedBounds:(lower:lower, upper:upper))
  }
}

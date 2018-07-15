/***************************************************************************************************
 AnyRange+Concatenated.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension AnyRange.BoundRepresentation {
  fileprivate func _isConcatenatable(with other:AnyRange.BoundRepresentation) -> Bool {
    // PREMISE
    // * self is the upper bound of a smaller range.
    // * other is the lower bound of a larger range.
    
    if self.bound > other.bound { return true }
    if self.bound < other.bound { return false }
    
    // self.bound == other.bound
    
    return self.isIncluded || other.isIncluded
  }
}

extension AnyRange {
  /// Concatenate two ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  public func concatenated(with other:AnyRange<Bound>) -> AnyRange<Bound>? {
    if self == other || other.isEmpty { return self }
    if self.isEmpty { return other }
    if self.isUnboundedRange || other.isUnboundedRange {
      return .unbounded
    }
    
    // from here, both self and other is not empty nor unbounded. And self != other.
    
    let (less, greater) = self < other ? (self, other) : (other, self)
    // See "AnyRange+Comparable.swift" to know how to compare ranges.
    
    let bounds = (less.bounds!, greater.bounds!)
    
    let maxUpperBound = {(b0:BoundRepresentation?, b1:BoundRepresentation?) -> BoundRepresentation? in
      return AnyRange.BoundRepresentation._max(b0, b1, as:.upper)
    }
    
    switch (bounds.0.lower, bounds.1.lower, bounds.0.upper, bounds.1.upper) {
    case (nil, nil, let upper0?, let upper1?):
      // `less` and `greater` are PartialRange(Through|UpTo)
      return AnyRange<Bound>(uncheckedBounds:(lower:nil, upper:maxUpperBound(upper0, upper1)))
      
    case (nil, let lower1?, let upper0?, let nilableUpper1):
      // `less` is PartialRange(Through|UpTo)
      // `greater` is not
      guard upper0._isConcatenatable(with:lower1) else { return nil }
      return AnyRange<Bound>(uncheckedBounds:(lower:nil,
                                              upper:maxUpperBound(upper0, nilableUpper1)))
    
    case (let lower0?, let lower1?, let nilableUpper0, let nilableUpper1):
      // `lower0 < lower1` is always true because they are already sorted.
      assert(lower0._compare(lower1, as:.lower) == .orderedAscending)
      if let upper0 = nilableUpper0 {
        guard upper0._isConcatenatable(with:lower1) else { return nil }
      }
      return AnyRange<Bound>(uncheckedBounds:(lower:lower0,
                                              upper:maxUpperBound(nilableUpper0, nilableUpper1)))
      
    default:
      assertionFailure("default must never be executed.")
      return nil
    }
    
    
  }
}

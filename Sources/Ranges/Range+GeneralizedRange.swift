/***************************************************************************************************
 Range+GeneralizedRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension Range: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    if self.isEmpty { return nil }
    return (lower:Boundary<Bound>(bound:self.lowerBound, isIncluded:true),
            upper:Boundary<Bound>(bound:self.upperBound, isIncluded:false))
  }
}


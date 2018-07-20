/***************************************************************************************************
 PartialRangeFrom+GeneralizedRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension PartialRangeFrom: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return (lower:Boundary<Bound>(bound:self.lowerBound, isIncluded:true),
            upper:nil)
  }
}


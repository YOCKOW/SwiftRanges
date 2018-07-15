/***************************************************************************************************
 PartialRangeThrough+GeneralizedRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension PartialRangeThrough: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return (lower:nil,
            upper:Boundary<Bound>(bound:self.upperBound, isIncluded:true))
  }
}


/* *************************************************************************************************
 PartialRangeFrom+GeneralizedRange.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
extension PartialRangeFrom: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return (lower: .included(self.lowerBound), upper: .unbounded)
  }
}

extension PartialRangeFrom: GeneralizedCountableRange where Bound: Strideable,
                                                            Bound.Stride: SignedInteger {}

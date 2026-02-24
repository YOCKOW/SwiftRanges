/***************************************************************************************************
 ClosedRange+GeneralizedRange.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension ClosedRange: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    if self.isEmpty { return nil }
    return (lower: .included(self.lowerBound), upper: .included(self.upperBound))
  }
}

extension ClosedRange: GeneralizedCountableRange where Bound: Strideable,
                                                       Bound.Stride: SignedInteger {}

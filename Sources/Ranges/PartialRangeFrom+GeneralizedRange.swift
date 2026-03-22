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

  public var isEmpty: Bool {
    return false
  }
}

extension PartialRangeFrom: GeneralizedCountableRange where Bound: Strideable,
                                                            Bound.Stride: SignedInteger {}

extension PartialRangeFrom: @retroactive Equatable {}

extension PartialRangeFrom: @retroactive Hashable where Bound: Hashable {}

extension PartialRangeFrom: HashableRange where Bound: Hashable {}

extension PartialRangeFrom: SendableGeneralizedRange {}

/* *************************************************************************************************
 PartialRangeThrough+GeneralizedRange.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

extension PartialRangeThrough: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return (lower: .unbounded, upper: .included(self.upperBound))
  }

  public var isEmpty: Bool {
    return false
  }
}

extension PartialRangeThrough: GeneralizedCountableRange where Bound: Strideable,
                                                               Bound.Stride: SignedInteger {}

extension PartialRangeThrough: @retroactive Equatable {}

extension PartialRangeThrough: @retroactive Hashable where Bound: Hashable {}

extension PartialRangeThrough: HashableRange where Bound: Hashable {}

extension PartialRangeThrough: SendableGeneralizedRange {}

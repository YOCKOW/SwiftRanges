/* *************************************************************************************************
 PartialRangeUpTo+GeneralizedRange.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

extension PartialRangeUpTo: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return (lower: .unbounded, upper: .excluded(self.upperBound))
  }

  public var isEmpty: Bool {
    return false
  }
}

extension PartialRangeUpTo: GeneralizedCountableRange where Bound: Strideable,
                                                            Bound.Stride: SignedInteger {}

extension PartialRangeUpTo: SendableGeneralizedRange {}

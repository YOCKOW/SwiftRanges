/***************************************************************************************************
 PartialRangeUpTo+GeneralizedRange.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension PartialRangeUpTo: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return (lower: .unbounded, upper: .excluded(self.upperBound))
  }
}



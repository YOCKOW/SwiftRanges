/***************************************************************************************************
 Range+GeneralizedRange.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension Range: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    if self.isEmpty { return nil }
    return (lower: .included(self.lowerBound), upper: .excluded(self.upperBound))
  }
}


/***************************************************************************************************
 PartialRangeGreaterThan+PartialRangeFrom.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension PartialRangeGreaterThan {
  /// Always returns `true`
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    return true
  }
}

extension PartialRangeFrom {
  /// Always returns `true`
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return true
  }
}




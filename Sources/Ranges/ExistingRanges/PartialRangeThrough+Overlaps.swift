/***************************************************************************************************
 PartialRangeThrough+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
// PartialRangeThrough
extension PartialRangeThrough {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    return true
  }
}

// PartialRangeUpTo
extension PartialRangeThrough {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    return true
  }
}
extension PartialRangeUpTo {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    return true
  }
}


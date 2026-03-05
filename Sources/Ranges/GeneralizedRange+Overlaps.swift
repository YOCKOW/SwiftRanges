/* *************************************************************************************************
 GeneralizedRange+Overlaps.swift
   © 2018,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

 
extension GeneralizedRange {
  /// Returns whether the intersection of `self` and `other` is empty or not.
  public func overlaps<R>(
    _ other: R
  ) -> Bool where R: GeneralizedRange, R.Bound == Bound {
    return !self.intersection(other).isEmpty
  }
  
  /// Returns `false`.
  public func overlaps(_:()) -> Bool {
    return false
  }
  
  /// Returns `true`.
  public func overlaps(_:UnboundedRange) -> Bool {
    return true
  }
}

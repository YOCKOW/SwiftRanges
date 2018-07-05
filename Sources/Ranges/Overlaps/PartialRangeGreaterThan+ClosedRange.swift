/***************************************************************************************************
 PartialRangeGreaterThan+ClosedRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension PartialRangeGreaterThan {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    return false
  }
}

extension ClosedRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

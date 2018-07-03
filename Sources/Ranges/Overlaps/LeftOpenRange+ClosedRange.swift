/***************************************************************************************************
 LeftOpenRange+ClosedRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
}

extension ClosedRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

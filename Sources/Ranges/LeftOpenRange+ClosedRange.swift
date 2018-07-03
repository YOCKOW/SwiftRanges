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
    return (!other.isEmpty && self.contains(other.upperBound)) || (!self.isEmpty && other.contains(self.upperBound))
  }
}

extension ClosedRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

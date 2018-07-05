/***************************************************************************************************
 OpenRange+PartialRangeThrough.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    if self.isEmpty { return false }
    if other.upperBound > self.lowerBound { return true }
    return false
  }
}

extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}


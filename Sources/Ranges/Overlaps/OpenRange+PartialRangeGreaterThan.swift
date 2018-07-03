/***************************************************************************************************
 OpenRange+PartialRangeGreaterThan.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


extension OpenRange where Bound: Strideable, Bound.Stride: BinaryInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    if self.isEmpty { return false }
    if other.lowerBound.distance(to:self.upperBound) > 1 { return true }
    return false
  }
}

extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    if self.isEmpty { return false }
    if self.upperBound > other.lowerBound { return true }
    return false
  }
}

/***************************************************************************************************
 LeftOpenRange+PartialRangeUpTo.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension LeftOpenRange where Bound: Strideable, Bound.Stride: BinaryInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    if self.isEmpty { return false }
    return self.lowerBound.distance(to:other.upperBound) > 1
  }
}


extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.upperBound > self.lowerBound
  }
}


extension PartialRangeUpTo where Bound: Strideable, Bound.Stride: BinaryInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

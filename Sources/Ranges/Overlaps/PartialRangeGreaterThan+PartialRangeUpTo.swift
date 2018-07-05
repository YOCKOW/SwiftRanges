/***************************************************************************************************
 PartialRangeGreaterThan+PartialRangeUpTo.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension PartialRangeGreaterThan where Bound: Strideable, Bound.Stride: BinaryInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    return self.lowerBound.distance(to:other.upperBound) > 1
  }
}


extension PartialRangeGreaterThan {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    return other.upperBound > self.lowerBound
  }
}


extension PartialRangeUpTo where Bound: Strideable, Bound.Stride: BinaryInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return other.overlaps(self)
  }
}
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return other.overlaps(self)
  }
}



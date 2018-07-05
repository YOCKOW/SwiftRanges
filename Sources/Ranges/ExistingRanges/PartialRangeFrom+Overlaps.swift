/***************************************************************************************************
 PartialRangeFrom+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

// PartialRangeFrom
extension PartialRangeFrom {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    return true
  }
}

// PartialRangeThrough
extension PartialRangeFrom {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    return other.upperBound >= self.lowerBound
  }
}
extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

// PartialRangeUpTo
extension PartialRangeFrom {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    return other.upperBound > self.lowerBound
  }
}
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

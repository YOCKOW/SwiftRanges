/***************************************************************************************************
 ClosedRange+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

// PartialRangeFrom
extension ClosedRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.lowerBound <= self.upperBound
  }
}
extension PartialRangeFrom {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

// PartialRangeThrough
extension ClosedRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.upperBound >= self.lowerBound
  }
}
extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

// PartialRangeUpTo
extension ClosedRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.upperBound > self.lowerBound
  }
}
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

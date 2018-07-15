/***************************************************************************************************
 PartialRangeThrough+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
// ClosedRange
extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.upperBound >= other.lowerBound
  }
}

// LeftOpenRange
extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.upperBound > other.lowerBound
  }
}

// OpenRange
extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.upperBound > other.lowerBound
  }
}

// Range
extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.upperBound >= other.lowerBound
  }
}

// PartialRangeFrom
extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    return self.upperBound >= other.lowerBound
  }
}

// PartialRangeGreaterThan
extension PartialRangeThrough {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return self.upperBound > other.lowerBound
  }
}

// PartialRangeThrough
extension PartialRangeThrough {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    return true
  }
}

// PartialRangeUpTo
extension PartialRangeThrough {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    return true
  }
}

// UnboundedRange
extension PartialRangeThrough {
  /// Returns `true`
  public func overlaps(_:UnboundedRange) -> Bool {
    return true
  }
}

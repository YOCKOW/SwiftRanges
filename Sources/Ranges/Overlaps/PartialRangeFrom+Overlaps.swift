/***************************************************************************************************
 PartialRangeFrom+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
// ClosedRange
extension PartialRangeFrom {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound <= other.upperBound
  }
}

// LeftOpenRange
extension PartialRangeFrom {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound <= other.upperBound
  }
}

// OpenRange
extension PartialRangeFrom {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound < other.upperBound
  }
}

// Range
extension PartialRangeFrom {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound < other.upperBound
  }
}

// PartialRangeFrom
extension PartialRangeFrom {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    return true
  }
}

// PartialRangeGreaterThan
extension PartialRangeFrom {
  /// Returns `true`.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
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

// PartialRangeUpTo
extension PartialRangeFrom {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    return other.upperBound > self.lowerBound
  }
}

// UnboundedRange
extension PartialRangeFrom {
  /// Returns `true`
  public func overlaps(_:UnboundedRange) -> Bool {
    return true
  }
}



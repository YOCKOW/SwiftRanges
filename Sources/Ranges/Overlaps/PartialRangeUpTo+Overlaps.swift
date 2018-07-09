/***************************************************************************************************
 PartialRangeUpTo+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
// ClosedRange
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.upperBound > other.lowerBound
  }
}

// LeftOpenRange
extension PartialRangeUpTo where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return other.lowerBound.distance(to:self.upperBound) > 1
  }
}
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.upperBound > other.lowerBound
  }
}

// OpenRange
extension PartialRangeUpTo where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return other.lowerBound.distance(to:self.upperBound) > 1
  }
}
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.upperBound > other.lowerBound
  }
}

// Range
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.upperBound > other.lowerBound
  }
}

// PartialRangeFrom
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    return self.upperBound > other.lowerBound
  }
}

// PartialRangeGreaterThan
extension PartialRangeUpTo where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return other.lowerBound.distance(to:self.upperBound) > 1
  }
}
extension PartialRangeUpTo {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return self.upperBound > other.lowerBound
  }
}

// PartialRangeThrough
extension PartialRangeUpTo {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    return true
  }
}

// PartialRangeUpTo
extension PartialRangeUpTo {
  /// Returns `true`
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    return true
  }
}

// UnboundedRange
extension PartialRangeUpTo {
  /// Returns `true`
  public func overlaps(_:UnboundedRange) -> Bool {
    return true
  }
}


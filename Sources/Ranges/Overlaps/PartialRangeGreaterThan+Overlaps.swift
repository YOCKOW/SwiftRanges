/***************************************************************************************************
 PartialRangeGreaterThan+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
// ClosedRange
extension PartialRangeGreaterThan {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.contains(other.upperBound)
  }
}

// LeftOpenRange
extension PartialRangeGreaterThan {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound < other.upperBound
  }
}

// OpenRange
extension PartialRangeGreaterThan where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound.distance(to:other.upperBound) > 1
  }
}
extension PartialRangeGreaterThan {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound < other.upperBound
  }
}

// Range
extension PartialRangeGreaterThan where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound.distance(to:other.upperBound) > 1
  }
}
extension PartialRangeGreaterThan {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    if other.isEmpty { return false }
    return self.lowerBound < other.upperBound
  }
}

// PartialRangeFrom
extension PartialRangeGreaterThan {
  /// Always returns `true`
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    return true
  }
}

// PartialRangeGreaterThan
extension PartialRangeGreaterThan {
  /// Always returns `true`
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return true
  }
}

// PartialRangeThrough
extension PartialRangeGreaterThan {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    return other.upperBound > self.lowerBound
  }
}

// PartialRangeUpTo
extension PartialRangeGreaterThan where Bound: Strideable, Bound.Stride: SignedInteger {
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

// UnboundedRange
extension PartialRangeGreaterThan {
  /// Returns `true`
  public func overlaps(_:UnboundedRange) -> Bool {
    return true
  }
}

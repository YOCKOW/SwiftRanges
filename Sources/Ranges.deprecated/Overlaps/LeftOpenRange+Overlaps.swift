/***************************************************************************************************
 LeftOpenRange+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

// ClosedRange
extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
}

// LeftOpenRange
extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
}

// OpenRange
extension LeftOpenRange {
  private func _overlaps(_ other:OpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
}
extension LeftOpenRange where Bound:Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.lowerBound.distance(to:other.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}
extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

// Range
extension LeftOpenRange {
  private func _overlaps(_ other:Range<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound){ return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
}
extension LeftOpenRange where Bound:Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.lowerBound.distance(to:other.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}
extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

// PartialRangeFrom
extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    if self.isEmpty { return false }
    if self.upperBound >= other.lowerBound { return true }
    return false
  }
}

// PartialRangeGreaterThan
extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    if self.isEmpty { return false }
    if self.upperBound > other.lowerBound { return true }
    return false
  }
}

// PartialRangeThrough
extension LeftOpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    if self.isEmpty { return false }
    if other.upperBound > self.lowerBound { return true }
    return false
  }
}

// PartialRangeUpTo
extension LeftOpenRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
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

// UnboundedRange
extension LeftOpenRange {
  /// Returns `true` unless the receiver is not empty.
  public func overlaps(_:UnboundedRange) -> Bool {
    return !self.isEmpty
  }
}


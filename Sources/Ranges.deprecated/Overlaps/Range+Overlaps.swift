/***************************************************************************************************
 Range+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

// ClosedRange
extension Range {
  // Implemented in Swift Standard Library
  // public func overlaps(_ other:ClosedRange<Bound>) -> Bool {}
}

// LeftOpenRange
extension Range {
  private func _overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound){ return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
}
extension Range where Bound:Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if other.lowerBound.distance(to:self.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}
extension Range {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

// OpenRange
extension Range {
  private func _overlaps(_ other:OpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) && other.upperBound != self.lowerBound { return true }
    if other.contains(self.upperBound)  { return true }
    if self.upperBound == other.upperBound { return true }
    return false
  }
}
extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if other.lowerBound.distance(to:self.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}
extension Range {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

// Range
extension Range {
  // Implemented in Swift Standard Library
  // public func overlaps(_ other:Range<Bound>) -> Bool {}
}

// PartialRangeFrom
extension Range {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.lowerBound < self.upperBound
  }
}

// PartialRangeGreaterThan
extension Range {
  private func _overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    if self.isEmpty { return false }
    return self.upperBound > other.lowerBound
  }
}
extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    if self.isEmpty { return false }
    if other.lowerBound.distance(to:self.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}
extension Range {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

// PartialRangeThrough
extension Range {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.upperBound >= self.lowerBound
  }
}

// PartialRangeUpTo
extension Range {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    if self.isEmpty { return false }
    return self.lowerBound < other.upperBound
  }
}

// UnboundedRange
extension Range {
  /// Returns `true` unless the receiver is not empty.
  public func overlaps(_:UnboundedRange) -> Bool {
    return !self.isEmpty
  }
}


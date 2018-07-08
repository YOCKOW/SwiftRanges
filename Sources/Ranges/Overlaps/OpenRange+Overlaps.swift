/***************************************************************************************************
 OpenRange+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
// ClosedRange
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:ClosedRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) && self.upperBound != other.lowerBound { return true }
    return false
  }
}

// LeftOpenRange
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  private func _overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
}
extension OpenRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if other.lowerBound.distance(to:self.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

// OpenRange
extension OpenRange {
  private func _overlaps(_ other:OpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) { return true }
    if self.upperBound == other.upperBound { return true }
    return false
  }
}
extension OpenRange where Bound:Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.lowerBound.distance(to:other.upperBound) <= 1 { return false }
    if other.lowerBound.distance(to:self.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

// Range
extension OpenRange {
  private func _overlaps(_ other:Range<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) && self.upperBound != other.lowerBound { return true }
    if self.upperBound == other.upperBound { return true }
    return false
  }
}
extension OpenRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.lowerBound.distance(to:other.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    return self._overlaps(other)
  }
}


// PartialRangeFrom
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    if self.isEmpty { return false }
    if self.upperBound > other.lowerBound { return true }
    return false
  }
}

// PartialRangeGreaterThan
extension OpenRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.lowerBound.distance(to:self.upperBound) > 1
  }
}
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    if self.isEmpty { return false }
    return self.upperBound > other.lowerBound
  }
}

// PartialRangeThrough
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    if self.isEmpty { return false }
    if other.upperBound > self.lowerBound { return true }
    return false
  }
}

// PartialRangeUpTo
extension OpenRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    if self.isEmpty { return false }
    return self.lowerBound.distance(to:other.upperBound) > 1
  }
}
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.upperBound > self.lowerBound
  }
}

// UnboundedRange
extension OpenRange {
  /// Returns `true` unless the receiver is not empty.
  public func overlaps(_:UnboundedRange) -> Bool {
    return !self.isEmpty
  }
}



/***************************************************************************************************
 OpenRange+Range.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension OpenRange {
  fileprivate func _overlaps(_ other:Range<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) && self.upperBound != other.lowerBound { return true }
    if self.upperBound == other.upperBound { return true }
    return false
  }
}


extension OpenRange where Bound: Strideable, Bound.Stride: BinaryInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// Note: There is no element in common if, for example, the distance to the upper bound of `Range`
  /// from the lower bound of `OpenRange` is equal to or less than 1 (when `Bound` conforms to
  /// `Strideable` and its `Stride` conformts to `BinaryInteger`).
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


extension Range where Bound: Strideable, Bound.Stride: BinaryInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}
extension Range {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}


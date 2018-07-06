/***************************************************************************************************
 LeftOpenRange+Range.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 


extension LeftOpenRange {
  fileprivate func _overlaps(_ other:Range<Bound>) -> Bool {
    return (!other.isEmpty && self.contains(other.upperBound)) ||
      (!self.isEmpty && other.contains(self.upperBound)) ||
      (!self.isEmpty && !other.isEmpty && self.upperBound == other.upperBound)
  }
}


extension LeftOpenRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// Note: There is no element in common if the distance to the upper bound of `Range` from the
  /// lower bound of `LeftOpenRange` is equal to or less than 1 (when `Bound` conforms to
  /// `Strideable` and its `Stride` conformts to `SignedInteger`).
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


extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// Note: There is no element in common if the distance to the upper bound of `Range` from the
  /// lower bound of `LeftOpenRange` is equal to or less than 1 (when `Bound` conforms to
  /// `Strideable` and its `Stride` conformts to `SignedInteger`).
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}
extension Range {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

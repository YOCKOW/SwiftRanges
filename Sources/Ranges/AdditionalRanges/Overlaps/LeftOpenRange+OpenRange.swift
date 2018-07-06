/***************************************************************************************************
 LeftOpenRange+OpenRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension LeftOpenRange {
  fileprivate func _overlaps(_ other:OpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
}

extension LeftOpenRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// Note: There is no element in common if, for example, the distance to the upper bound of `Range`
  /// from the lower bound of `OpenRange` is equal to or less than 1 (when `Bound` conforms to
  /// `Strideable` and its `Stride` conformts to `SignedInteger`).
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


extension OpenRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// Note: There is no element in common if the distance to the upper bound of `Range` from the
  /// lower bound of `LeftOpenRange` is equal to or less than 1 (when `Bound` conforms to
  /// `Strideable` and its `Stride` conformts to `SignedInteger`).
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}
extension OpenRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    return other.overlaps(self)
  }
}

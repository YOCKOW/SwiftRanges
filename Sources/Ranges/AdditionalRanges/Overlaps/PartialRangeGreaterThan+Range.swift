/***************************************************************************************************
 PartialRangeGreaterThan+Range.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension PartialRangeGreaterThan {
  fileprivate func _overlaps(_ other:Range<Bound>) -> Bool {
    if other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    return false
  }
}


extension PartialRangeGreaterThan where Bound: Strideable, Bound.Stride: BinaryInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    if other.isEmpty { return false }
    if self.lowerBound.distance(to:other.upperBound) <= 1 { return false }
    return self._overlaps(other)
  }
}

extension PartialRangeGreaterThan {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:Range<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

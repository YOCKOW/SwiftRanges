/***************************************************************************************************
 ClosedRange+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension ClosedRange {
  // Implemented in Swift Standard Library
  // public func overlaps(_ other:ClosedRange<Bound>) -> Bool {}
  
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:LeftOpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) { return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
  
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:OpenRange<Bound>) -> Bool {
    if self.isEmpty || other.isEmpty { return false }
    if self.contains(other.upperBound) && other.upperBound != self.lowerBound { return true }
    if other.contains(self.upperBound) { return true }
    return false
  }
  
  // Implemented in Swift Standard Library
  // public func overlaps(_ other:Range<Bound>) -> Bool {}
  
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeFrom<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.lowerBound <= self.upperBound    
  }
  
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeGreaterThan<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.contains(self.upperBound)
  }
  
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeThrough<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.upperBound >= self.lowerBound
  }
  
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:PartialRangeUpTo<Bound>) -> Bool {
    if self.isEmpty { return false }
    return other.upperBound > self.lowerBound
  }
  
  /// Returns `true` unless the receiver is not empty.
  public func overlaps(_:UnboundedRange) -> Bool {
    return !self.isEmpty
  }
}

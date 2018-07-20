/***************************************************************************************************
 MultipleRanges+Union.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
extension MultipleRanges {
  /// Adds the ranges in the given instance.
  /// Ranges will be concatenated if possible.
  public mutating func formUnion(_ other:MultipleRanges<Bound>) {
    self.ranges.append(contentsOf:other.ranges)
  }
  
  /// Returns a new instance with the ranges of both this and the given instance.
  /// Ranges will be concatenated if possible.
  public func union(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formUnion(other)
    return newRanges
  }
}

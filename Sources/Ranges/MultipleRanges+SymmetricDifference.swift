/***************************************************************************************************
 MultipleRanges+SymmetricDifference.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
// symmetric diferrence == union - intersection
// It depends on countability

extension MultipleRanges where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Same as formUnion but not including intersection.
  /// They are treated as countable ranges.
  public mutating func formSymmetricDifference(_ other:MultipleRanges<Bound>) {
    let intersection = self.intersection(other)
    self.formUnion(other)
    self.subtract(intersection)
  }
  
  /// Same as `self.union(other).subtracting(self.intersection(other))`.
  /// They are treated as countable ranges.
  public func symmetricDifference(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formSymmetricDifference(other)
    return newRanges
  }
}

extension MultipleRanges {
  /// Same as formUnion but not including intersection.
  public mutating func formSymmetricDifference(_ other:MultipleRanges<Bound>) {
    let intersection = self.intersection(other)
    self.formUnion(other)
    self.subtract(intersection)
  }
  
  /// Same as `self.union(other).subtracting(self.intersection(other))`.
  public func symmetricDifference(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formSymmetricDifference(other)
    return newRanges
  }
}


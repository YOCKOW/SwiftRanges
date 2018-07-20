/***************************************************************************************************
 MultipleRanges+Intersection.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

// INTERSECTION depends on countability.
 
extension MultipleRanges where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Update the ranges to be the intersection of each ranges
  /// in the receiver and the given instance.
  /// They are treated as countable ranges.
  public mutating func formIntersection(_ other:MultipleRanges<Bound>) {
    var intersections: [AnyRange<Bound>] = []
    for myRange in self.ranges {
      for otherRange in other.ranges {
        intersections.append(myRange.intersection(otherRange))
      }
    }
    self.ranges = intersections
  }
  
  /// Returns a new instance with the ranges that are the intersection of each ranges
  /// in the receiver and the given instance.
  /// They are treated as countable ranges.
  public func intersection(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formIntersection(other)
    return newRanges
  }
}

extension MultipleRanges {
  /// Update the ranges to be the intersection of each ranges
  /// in the receiver and the given instance.
  public mutating func formIntersection(_ other:MultipleRanges<Bound>) {
    var intersections: [AnyRange<Bound>] = []
    for myRange in self.ranges {
      for otherRange in other.ranges {
        intersections.append(myRange.intersection(otherRange))
      }
    }
    self.ranges = intersections
  }
  
  /// Returns a new instance with the ranges that are the intersection of each ranges
  /// in the receiver and the given instance.
  public func intersection(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formIntersection(other)
    return newRanges
  }
}

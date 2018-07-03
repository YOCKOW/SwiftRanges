/***************************************************************************************************
 OpenRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
/// # OpenRange
/// A range that does not include neither its lower bound nor its upper bound.
public struct OpenRange<Bound: Comparable> {
  public let lowerBound: Bound
  public let upperBound: Bound
  public init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
    self.lowerBound = bounds.lower
    self.upperBound = bounds.upper
  }
}

/***************************************************************************************************
 Boundary.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


/// # Boundary
///
/// `Boundary` represents a bound for a range, and has a property `isIncluded` that indicates
/// whether the bound should be included or excluded.
public struct Boundary<Bound> where Bound: Comparable {
  public let bound: Bound
  public let isIncluded: Bool
  
  /// - parameter bound: The value for the bound.
  /// - parameter isIncluded: Pass `true` if the bound must be included.
  public init(bound value:Bound, isIncluded included:Bool) {
    self.bound = value
    self.isIncluded = included
  }
}

public typealias CountableBoundary<Bound> =
  Boundary<Bound> where Bound:Strideable, Bound.Stride:SignedInteger

extension Boundary: Equatable {
  public static func ==(lhs:Boundary<Bound>, rhs:Boundary<Bound>) -> Bool {
    return lhs.bound == rhs.bound && lhs.isIncluded == rhs.isIncluded
  }
}

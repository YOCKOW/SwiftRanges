/***************************************************************************************************
 GeneralizedRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


public typealias Bounds<Bound> =
  (lower:Boundary<Bound>?, upper:Boundary<Bound>?) where Bound:Comparable

public protocol GeneralizedRange: RangeExpression {
  /// Retunrs a set for a lower bound and an upper bound.   
  ///
  /// Returns `nil` if the receiver represents an empty range.
  /// `lower` is `nil` if the receiver represents a partial range whose lower bound is not defined.
  /// `upper` is `nil` if the receiver represents a partial range whose upper bound is not defined.
  /// Both `lower` and `upper` are nil if the receiver represents an unbounded range.
  var bounds: Bounds<Bound>? { get }
}

/***************************************************************************************************
 GeneralizedRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


/// Represents a set of a lower bound and an upper bound.
///
/// * `lower` is `nil` if it represents a partial range whose lower bound is not defined.
/// * `upper` is `nil` if it represents a partial range whose upper bound is not defined.
/// * Both `lower` and `upper` are nil if it represents an unbounded range.
public typealias Bounds<Bound> =
  (lower:Boundary<Bound>?, upper:Boundary<Bound>?) where Bound:Comparable

public protocol GeneralizedRange: RangeExpression {
  /// Retunrs a set of a lower bound and an upper bound.
  ///
  /// Returns `nil` if the receiver represents an empty range.
  /// `lower` is `nil` if the receiver represents a partial range whose lower bound is not defined.
  /// `upper` is `nil` if the receiver represents a partial range whose upper bound is not defined.
  /// Both `lower` and `upper` are nil if the receiver represents an unbounded range.
  var bounds: Bounds<Bound>? { get }
}

// Default implementation for functions that are required by `RangeExpression`
extension GeneralizedRange {
  public func contains(_ element:Bound) -> Bool {
    guard let bounds = self.bounds else { return false }
    if bounds.lower == nil && bounds.upper == nil { return true }
    
    if let lower = bounds.lower {
      guard lower.isIncluded ? element >= lower.bound : element > lower.bound else { return false }
    }
    if let upper = bounds.upper {
      guard upper.isIncluded ? element <= upper.bound : element < upper.bound else { return false }
    }
    
    return true
  }
  
  public func relative<C>(to collection: C) -> Range<Bound> where C:Collection, Bound == C.Index {
    guard let bounds = self.bounds else { return collection.startIndex..<collection.startIndex }
    
    let start: Bound = ({
      guard let lower = $0 else { return collection.startIndex }
      return lower.isIncluded ? lower.bound : collection.index(after:lower.bound)
    })(bounds.lower)
    
    let end: Bound = ({
      guard let upper = $0 else { return collection.endIndex }
      return upper.isIncluded ? collection.index(after:upper.bound) : upper.bound
    })(bounds.upper)
    
    return start..<end
  }
}

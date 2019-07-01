/***************************************************************************************************
 TangibleUnboundedRange.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

/// # TangibleUnboundedRange
///
/// A range that has no bounds. Because `UnboundedRange` in Swift Standard Library is a `typealias`
/// of the function `(UnboundedRange_) -> ()`, it is not able to be extended.
/// That is why this structure exists.
public struct TangibleUnboundedRange<Bound> where Bound:Comparable {
  public init() {}
  public init(_:UnboundedRange) {}
}

extension TangibleUnboundedRange  {
  public var isEmpty: Bool { return false }
}

extension TangibleUnboundedRange: Equatable {
  public static func ==(lhs:TangibleUnboundedRange<Bound>, rhs:TangibleUnboundedRange<Bound>) -> Bool {
    return true
  }
}

extension TangibleUnboundedRange: Hashable, HashableRange where Bound: Hashable {}

extension TangibleUnboundedRange: CustomStringConvertible {
  public var description: String {
    return "..."
  }
}

extension TangibleUnboundedRange: RangeExpression {
  public func contains(_ element: Bound) -> Bool {
    return true
  }
  
  public func relative<C>(to collection: C) -> Range<Bound> where C:Collection, Bound == C.Index {
    return collection.startIndex..<collection.endIndex
  }
  
}

extension TangibleUnboundedRange: GeneralizedRange {
  public var bounds:Bounds<Bound>? {
    return (lower: .unbounded, upper: .unbounded)
  }
}


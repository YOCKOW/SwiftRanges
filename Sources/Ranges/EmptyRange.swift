/***************************************************************************************************
 EmptyRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


/// # EmptyRange
///
/// A range that does not contain any elements.
public struct EmptyRange<Bound> where Bound:Comparable {}

extension EmptyRange  {
  public var isEmpty: Bool { return true }
}

extension EmptyRange: Equatable {
  public static func ==(lhs:EmptyRange<Bound>, rhs:EmptyRange<Bound>) -> Bool {
    return true
  }
}

extension EmptyRange: Hashable where Bound: Hashable {
  public var hashValue: Int {
    return 0
  }
}

extension EmptyRange: CustomStringConvertible {
  public var description: String {
    return "()"
  }
}

extension EmptyRange: RangeExpression {
  public func contains(_ element: Bound) -> Bool {
    return false
  }
  
  public func relative<C>(to collection: C) -> Range<Bound> where C:Collection, Bound == C.Index {
    return collection.startIndex..<collection.startIndex
  }
  
}

extension EmptyRange: GeneralizedRange {
  public var bounds:Bounds<Bound>? {
    return nil
  }
}

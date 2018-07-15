/***************************************************************************************************
 PartialRangeGreaterThan.swift
   © 2017-2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

/// # PartialRangeGreaterThan
/// 
/// A partial interval extending upward from a lower bound, but excluding the lower bound.
public struct PartialRangeGreaterThan<Bound: Comparable> {
  public let lowerBound: Bound
  public init(_ lowerBound: Bound) { self.lowerBound = lowerBound }
}

/// "Countable" PartialRangeGreaterThan
public typealias CountablePartialRangeGreaterThan<Bound> =
  PartialRangeGreaterThan<Bound> where Bound:Strideable, Bound.Stride:SignedInteger


postfix operator ..
public postfix func .. <T>(_ excludedLowerBound:ExcludedLowerBound<T>) -> PartialRangeGreaterThan<T> {
  return PartialRangeGreaterThan<T>(excludedLowerBound.lowerBound)
}

extension PartialRangeGreaterThan: Equatable {
  public static func ==(lhs:PartialRangeGreaterThan<Bound>, rhs:PartialRangeGreaterThan<Bound>) -> Bool {
    return lhs.lowerBound == rhs.lowerBound
  }
}

extension PartialRangeGreaterThan: Hashable where Bound: Hashable {
  public var hashValue: Int {
    return self.lowerBound.hashValue
  }
}

extension PartialRangeGreaterThan: CustomStringConvertible {
  public var description: String {
    return "\(self.lowerBound)<.."
  }
}

extension PartialRangeGreaterThan: RangeExpression {
  public func contains(_ element: Bound) -> Bool {
    return self.lowerBound < element
  }
  
  public func relative<C>(to collection: C) -> Range<Bound> where C: Collection, Bound == C.Index {
    let newLowerBound = collection.index(after:self.lowerBound)
    let newUpperBound = collection.endIndex
    return Range(uncheckedBounds:(lower:newLowerBound, upper:newUpperBound))
  }
}

extension PartialRangeGreaterThan: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return (lower:Boundary<Bound>(bound:self.lowerBound, isIncluded:false),
            upper:nil)
  }
}

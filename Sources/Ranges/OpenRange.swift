/***************************************************************************************************
 OpenRange.swift
   © 2017-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
/// # OpenRange
///
/// A range that does not include neither its lower bound nor its upper bound.
public struct OpenRange<Bound> where Bound: Comparable {
  public let lowerBound: Bound
  public let upperBound: Bound
  internal let _isEmpty: Bool // emptiness depends on its countability
}

/// "Countable" OpenRange
public typealias CountableOpenRange<Bound> =
  OpenRange<Bound> where Bound:Strideable, Bound.Stride:SignedInteger

extension OpenRange where Bound:Strideable, Bound.Stride:SignedInteger {
  public init(uncheckedBounds bounds:(lower:Bound, upper:Bound)) {
    self.lowerBound = bounds.lower
    self.upperBound = bounds.upper
    self._isEmpty = bounds.lower.distance(to:bounds.upper) <= 1
  }
}

extension OpenRange {
  public init(uncheckedBounds bounds:(lower:Bound, upper:Bound)) {
    self.lowerBound = bounds.lower
    self.upperBound = bounds.upper
    self._isEmpty = bounds.lower >= bounds.upper
  }
}


/// Make "lower<..<upper" available
infix operator ..<: RangeFormationPrecedence
public func ..< <T>(lhs:ExcludedLowerBound<T>, upper:T) -> OpenRange<T> {
  let lower = lhs.lowerBound
  precondition(lower <= upper, "Can't form Range with upperBound < lowerBound")
  return OpenRange(uncheckedBounds:(lower:lower, upper:upper))
}
public func ..< <T>(lhs:ExcludedCountableLowerBound<T>, upper:T) -> CountableOpenRange<T>
  where T:Strideable, T.Stride:SignedInteger
{
  let lower = lhs.lowerBound
  precondition(lower.distance(to:upper) >= 1, "Can't form Range with upperBound < lowerBound + 1 when bound is countable.")
  return CountableOpenRange(uncheckedBounds:(lower:lower, upper:upper))
}

extension OpenRange  {
  public var isEmpty: Bool { return self._isEmpty }
}

extension OpenRange: Equatable {
  public static func ==(lhs:OpenRange<Bound>, rhs:OpenRange<Bound>) -> Bool {
    return lhs.lowerBound == rhs.lowerBound && lhs.upperBound == rhs.upperBound
  }
}

extension OpenRange: RangeExpression {
  public func contains(_ element: Bound) -> Bool {
    return self.lowerBound < element && element < self.upperBound
  }
  
  public func relative<C>(to collection: C) -> Range<Bound> where C: Collection, Bound == C.Index {
    let newLowerBound = collection.index(after:self.lowerBound)
    return Range(uncheckedBounds:(lower:newLowerBound, upper:self.upperBound))
  }
}

extension OpenRange: GeneralizedRange {
  public var bounds:Bounds<Bound>? {
    if self.isEmpty { return nil }
    return (lower: .excluded(self.lowerBound), upper: .excluded(self.upperBound))
  }
}

extension OpenRange: Hashable, HashableRange where Bound: Hashable {}

extension OpenRange: CustomStringConvertible, CustomStringConvertibleRange where Bound: CustomStringConvertible {}

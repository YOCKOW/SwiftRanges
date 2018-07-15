/***************************************************************************************************
 LefOpenRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


/// # LeftOpenRange
/// A range that does not include its lower bound, but does include its upper bound.
/// Reference: [Interval - Wikipedia](https://en.wikipedia.org/wiki/Interval_(mathematics)#Terminology)
public struct LeftOpenRange<Bound: Comparable> {
  public let lowerBound: Bound
  public let upperBound: Bound
  public init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
    self.lowerBound = bounds.lower
    self.upperBound = bounds.upper
  }
}

/// "Countable" LeftOpenRange
public typealias CountableLeftOpenRange<Bound> =
  LeftOpenRange<Bound> where Bound:Strideable, Bound.Stride:SignedInteger

infix operator ..: RangeFormationPrecedence
public func .. <T>(lhs:ExcludedLowerBound<T>, upper:T) -> LeftOpenRange<T> {
  let lower = lhs.lowerBound
  guard lower <= upper else {
    fatalError("Can't form Range with upperBound < lowerBound")
  }
  return LeftOpenRange(uncheckedBounds:(lower:lower, upper:upper))
}

extension LeftOpenRange: RangeExpression {
  public func contains(_ element: Bound) -> Bool {
    return self.lowerBound < element && element <= self.upperBound
  }
  
  public func relative<C>(to collection: C) -> Range<Bound> where C: Collection, Bound == C.Index {
    let newLowerBound = collection.index(after:self.lowerBound)
    let newUpperBound = collection.index(after:self.upperBound)
    return Range(uncheckedBounds:(lower:newLowerBound, upper:newUpperBound))
  }
}

extension LeftOpenRange {
  public var isEmpty: Bool { return lowerBound >= upperBound }
}

extension LeftOpenRange: Equatable {
  public static func ==(lhs:LeftOpenRange<Bound>, rhs:LeftOpenRange<Bound>) -> Bool {
    return lhs.lowerBound == rhs.lowerBound && lhs.upperBound == rhs.upperBound
  }
}

extension LeftOpenRange: Hashable where Bound: Hashable {
  public var hashValue:Int {
    return self.lowerBound.hashValue ^ self.upperBound.hashValue
  }
}

extension LeftOpenRange: CustomStringConvertible {
  public var description: String {
    return "\(self.lowerBound)<..\(self.upperBound)"
  }
}

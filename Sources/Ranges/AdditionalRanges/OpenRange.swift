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

infix operator .<: RangeFormationPrecedence
public func .< <T>(lhs:ExcludedLowerBound<T>, upper:T) -> OpenRange<T> {
  let lower = lhs.lowerBound
  guard lower <= upper else {
    fatalError("Can't form Range with upperBound < lowerBound")
  }
  return OpenRange(uncheckedBounds:(lower:lower, upper:upper))
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

extension OpenRange {
  public var _isEmpty: Bool { return lowerBound >= upperBound }
}
extension OpenRange where Bound: Strideable, Bound.Stride: BinaryInteger {
  public var isEmpty: Bool {
    if self.lowerBound.distance(to:self.upperBound) <= 1 { return true }
    return self._isEmpty
  }
}
extension OpenRange  {
  public var isEmpty: Bool { return self._isEmpty }
}

extension OpenRange: Equatable {
  public static func ==(lhs:OpenRange<Bound>, rhs:OpenRange<Bound>) -> Bool {
    return lhs.lowerBound == rhs.lowerBound && lhs.upperBound == rhs.upperBound
  }
}

extension OpenRange: Hashable where Bound: Hashable {
  public var hashValue:Int {
    return self.lowerBound.hashValue ^ self.upperBound.hashValue
  }
}

extension OpenRange: CustomStringConvertible {
  public var description: String {
    return "\(self.lowerBound)<.<\(self.upperBound)"
  }
}

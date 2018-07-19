/***************************************************************************************************
 ExcludedLowerBound.swift
   © 2017-2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


/// Prepare workaround for "lower-open" ranges,
/// because "If an operator doesn’t begin with a dot, it can’t contain a dot elsewhere."
/// See [the document for Operators](https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html#ID418).
public struct ExcludedLowerBound<Bound> where Bound: Comparable {
  public let lowerBound:Bound
  public init(_ lowerBound:Bound) { self.lowerBound = lowerBound }
}

postfix operator <
/// Create an instance of `ExcludedLowerBound`
public postfix func < <T>(_ lowerBound:T) -> ExcludedLowerBound<T> where T: Comparable {
  return ExcludedLowerBound<T>(lowerBound)
}

/// If `Bound` of `ExcludedLowerBound` is "Countable",
/// it should be called `ExcludedCountableLowerBound`
public typealias ExcludedCountableLowerBound<Bound> =
  ExcludedLowerBound<Bound> where Bound:Strideable, Bound.Stride:SignedInteger

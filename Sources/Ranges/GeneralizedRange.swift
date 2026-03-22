/* *************************************************************************************************
 GeneralizedRange.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

/// A protocol for all ranges.
public protocol GeneralizedRange<Bound>: RangeExpression {
  /// Retunrs a set of a lower bound and an upper bound, or returns `nil` if the range is empty.
  var bounds: Bounds<Bound>? { get }

  /// A Boolean value indicating whether the range contains no elements.
  var isEmpty: Bool { get }
}

/// A generalized range whose `Bound` is countable.
public protocol GeneralizedCountableRange<Bound>: GeneralizedRange where Bound: Strideable,
                                                                         Bound.Stride: SignedInteger {}


/// A `Sendable` generalized range.
///
/// - Note: The reason why this protocol is `internal` is
///         [#87737](https://github.com/swiftlang/swift/issues/87737).
internal protocol SendableGeneralizedRange<Bound>: Sendable,
                                                   GeneralizedRange where Bound: Sendable {}

// MARK: - Contability

internal extension GeneralizedRange {
  @inlinable
  var _isCountable: Bool {
    return self is any GeneralizedCountableRange || _boundsAreCountable(self.bounds)
  }
}

internal extension GeneralizedCountableRange {
  @inlinable
  var _isCountable: Bool {
    return true
  }
}


// MARK: - Validation

@usableFromInline
internal func _validateBounds<Bound>(
  _ uncheckedBounds: Bounds<Bound>
) -> Bool where Bound: Comparable {
  switch (uncheckedBounds.lower, uncheckedBounds.upper) {
  case (.unbounded, _), (_, .unbounded):
    return true
  case (.excluded(let lower), .excluded(let upper)):
    if case let countableLower as any _CountableBoundProtocol = uncheckedBounds.lower,
       case let countableUpper as any _CountableBoundProtocol = uncheckedBounds.upper {
      func __canFormCountableOpenRange<B1, B2>(
        lower: B1,
        upper: B2
      ) -> Bool where B1: _CountableBoundProtocol, B2: _CountableBoundProtocol {
        return lower.value!.distance(to: upper.value! as! B1.Value) > 1
      }

      return __canFormCountableOpenRange(lower: countableLower, upper: countableUpper)
    }
    return lower < upper
  case (.excluded(let lower), .included(let upper)),
       (.included(let lower), .excluded(let upper)):
    return lower < upper
  case (.included(let lower), .included(let upper)):
    return lower <= upper
  }
}


// MARK: - Creation

internal func _makeRange<Bound>(
  uncheckedBounds: Bounds<Bound>
) -> any GeneralizedRange<Bound> where Bound: Comparable {
  guard _validateBounds(uncheckedBounds) else {
    return EmptyRange<Bound>()
  }

  switch uncheckedBounds {
  case (.included(let lower), .included(let upper)):
    return ClosedRange<Bound>(uncheckedBounds: (lower: lower, upper: upper))
  case (.excluded(let lower), .included(let upper)):
    return LeftOpenRange<Bound>(uncheckedBounds: (lower: lower, upper: upper))
  case (.excluded(let lower), .excluded(let upper)):
    return OpenRange<Bound>(uncheckedBounds: (lower: lower, upper: upper))
  case (.included(let lower), .unbounded):
    return PartialRangeFrom<Bound>(lower)
  case (.excluded(let lower), .unbounded):
    return PartialRangeGreaterThan<Bound>(lower)
  case (.unbounded, .included(let upper)):
    return PartialRangeThrough<Bound>(upper)
  case (.unbounded, .excluded(let upper)):
    return PartialRangeUpTo<Bound>(upper)
  case (.included(let lower), .excluded(let upper)):
    return Range<Bound>(uncheckedBounds: (lower: lower, upper: upper))
  case (.unbounded, .unbounded):
    return TangibleUnboundedRange<Bound>()
  }
}

// MARK: - Containment

internal func _contains<T>(bounds: Bounds<T>?, element: T) -> Bool where T: Comparable {
  guard let bounds = bounds else { return false }
  
  let lowerComparison = bounds.lower._compare(element, side: .lower)
  let upperComparison = bounds.upper._compare(element, side: .upper)
  return (
    (lowerComparison == .orderedSame || lowerComparison == .orderedAscending)
    &&
    (upperComparison == .orderedSame || upperComparison == .orderedDescending)
  )
}

// MARK: - Extensions

// Default implementation for functions that are required by `RangeExpression`
extension GeneralizedRange {
  public func contains(_ element:Bound) -> Bool {
    return _contains(bounds: self.bounds, element: element)
  }
  
  public func relative<C>(to collection: C) -> Range<Bound> where C:Collection, Bound == C.Index {
    guard let bounds = self.bounds else { return collection.startIndex..<collection.startIndex }
    
    let start: Bound = ({
      switch $0 {
      case .unbounded: return collection.startIndex
      case .included(let value): return value
      case .excluded(let value): return collection.index(after: value)
      }
    })(bounds.lower)
    
    let end: Bound = ({
      switch $0 {
      case .unbounded: return collection.endIndex
      case .included(let value): return collection.index(after: value)
      case .excluded(let value): return value
      }
    })(bounds.upper)
    
    return start..<end
  }
}

extension GeneralizedRange {
  /// Default implementation of `var isEmpty { get }`.
  /// A Boolean value indicating whether the range contains no elements.
  @inlinable
  public var isEmpty: Bool {
    guard let bounds = self.bounds else {
      return true
    }
    return !_validateBounds(bounds)
  }
}

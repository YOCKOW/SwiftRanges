/* *************************************************************************************************
 GeneralizedRange.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */


/// Represents a set of a lower bound and an upper bound.
public typealias Bounds<Bound> = (
  lower: GeneralizedRangeBound<Bound>,
  upper: GeneralizedRangeBound<Bound>
) where Bound: Comparable

/// A protocol for all ranges.
public protocol GeneralizedRange<Bound>: RangeExpression {
  /// Retunrs a set of a lower bound and an upper bound, or returns `nil` if the range is empty.
  var bounds: Bounds<Bound>? { get }
}

/// A generalized range whose `Bound` is countable.
public protocol GeneralizedCountableRange<Bound>: GeneralizedRange where Bound: Strideable,
                                                                         Bound.Stride: SignedInteger {}

internal func __validateBounds<Bound>(_ uncheckedBounds: Bounds<Bound>) -> Bool where Bound: Comparable {
  switch (uncheckedBounds.lower, uncheckedBounds.upper) {
  case (.unbounded, _), (_, .unbounded):
    return true
  case (.included(let lower), .included(let upper)):
    return lower <= upper
  case (.included(let lower), .excluded(let upper)),
       (.excluded(let lower), .included(let upper)),
       (.excluded(let lower), .excluded(let upper)):
    return lower < upper
  }
}

/// Returns true if the range represented by the bounds is not empty.
internal func _validateBounds<Bound>(_ uncheckedBounds: Bounds<Bound>) -> Bool where Bound: Comparable {
  return __validateBounds(uncheckedBounds)
}

/// Returns true if the **countable** range represented by the bounds is not empty.
internal func _validateBounds<Bound>(_ uncheckedBounds: Bounds<Bound>) -> Bool
  where Bound: Strideable, Bound.Stride: SignedInteger
{
  if case .excluded(let lower) = uncheckedBounds.lower,
     case .excluded(let upper) = uncheckedBounds.upper
  {
    return lower.distance(to: upper) > 1
  }
  return __validateBounds(uncheckedBounds)
}

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
  @inline(__always)
  var _wellknownRange: any GeneralizedRange<Bound> {
    switch self {
    case _ as ClosedRange<Bound>,
         _ as EmptyRange<Bound>,
         _ as LeftOpenRange<Bound>,
         _ as OpenRange<Bound>,
         _ as PartialRangeFrom<Bound>,
         _ as PartialRangeGreaterThan<Bound>,
         _ as PartialRangeThrough<Bound>,
         _ as PartialRangeUpTo<Bound>,
         _ as Range<Bound>,
         _ as TangibleUnboundedRange<Bound>:
      return self
    default:
      break
    }

    guard let bounds = self.bounds else {
      return EmptyRange<Bound>()
    }

    switch bounds {
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
}

/***************************************************************************************************
 GeneralizedRangeBound+Comparison.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import Foundation

extension GeneralizedRangeBound {
  internal enum _Side {
    case lower, upper
  }

  internal enum _ComparisonResult: Equatable {
    /// The left operand is definitely smaller than the right operand.
    case definitelyOrderedAscending

    /// The left operand is smaller than the right operand but can be considered equivalent.
    ///
    /// e.g.) .excluded(2) vs .included(3) at lower side;
    ///       .included(4) vs .excluded(5) at upper side
    case orderedAscendingButConsideredEquivalent

    /// The two operands are definitely equal.
    case definitelyOrderedSame

    /// The left operand is smaller than the right operand but can be considered equivalent.
    ///
    /// e.g.) .included(3) vs .excluded(2) at lower side;
    ///       .excluded(5) vs .included(4) at upper side
    case orderedDescendingButConsideredEquivalent

    /// The left operand is definitely greater than the right operand.
    case definitelyOrderedDescending

    var foundationComparisonResult: Foundation.ComparisonResult {
      switch self {
      case .definitelyOrderedAscending, .orderedAscendingButConsideredEquivalent:
        return .orderedAscending
      case .definitelyOrderedSame:
        return .orderedSame
      case .orderedDescendingButConsideredEquivalent, .definitelyOrderedDescending:
        return .orderedDescending
      }
    }
  }
}

private protocol _CountableBoundProtocol<Value> where Value: Strideable,
                                                      Value.Stride: SignedInteger {
  associatedtype Value
  var value: Value? { get }
}

extension GeneralizedRangeBound: _CountableBoundProtocol where Value: Strideable,
                                                               Value.Stride: SignedInteger {}

extension _CountableBoundProtocol {
  var nextValue: Value {
    guard let value = self.value else { fatalError("Unbounded?!") }
    return value.advanced(by: 1)
  }

  var previousValue: Value {
    guard let value = self.value else { fatalError("Unbounded?!") }
    return value.advanced(by: -1)
  }
}

extension GeneralizedRangeBound {
  internal func _compare(_ other: GeneralizedRangeBound<Value>, side: _Side) -> _ComparisonResult {
    if self == other {
      return .definitelyOrderedSame
    }

    // from here, self != other
    if self == .unbounded {
      return side == .lower ? .definitelyOrderedAscending : .definitelyOrderedDescending
    } else if other == .unbounded {
      return side == .lower ? .definitelyOrderedDescending : .definitelyOrderedAscending
    }
    
    // from here, both self and other are not .unbounded
    assert(self != other && self != .unbounded && other != .unbounded)
    let myValue = self.value!
    let otherValue = other.value!
    
    if myValue < otherValue {
      if case let countableSelf as any _CountableBoundProtocol<Value> = self {
        switch (side, self, other) {
        case (.lower, .excluded, .included), (.upper, .included, .excluded):
          if countableSelf.nextValue == otherValue {
            return .orderedAscendingButConsideredEquivalent
          }
        default:
          break
        }
      }
      return .definitelyOrderedAscending
    }

    if myValue > otherValue {
      if case let countableSelf as any _CountableBoundProtocol<Value> = self {
        switch (side, self, other) {
        case (.lower, .included, .excluded), (.upper, .excluded, .included):
          if countableSelf.previousValue == otherValue {
            return .orderedDescendingButConsideredEquivalent
          }
        default:
          break
        }
      }
      return .definitelyOrderedDescending
    }

    // from here, they have the same values
    assert(myValue == otherValue)
    if case .included = self {
      // other is not included
      return side == .lower ? .definitelyOrderedAscending : .definitelyOrderedDescending
    }
    return side == .lower ? .definitelyOrderedDescending : .definitelyOrderedAscending
  }
  
  internal func _compare(_ value: Value, side: _Side) -> ComparisonResult {
    switch (self, side) {
    case (.unbounded, .lower):
      return .orderedAscending
    case (.unbounded, .upper):
      return .orderedDescending
    case (.included(let myValue), _):
      if myValue < value { return .orderedAscending }
      if myValue == value { return .orderedSame }
      return .orderedDescending
    case (.excluded(let myValue), .lower):
      if myValue < value { return .orderedAscending }
      return .orderedDescending
    case (.excluded(let myValue), .upper):
      if myValue <= value { return .orderedAscending }
      return .orderedDescending
    }
  }
}

internal func _max<Bound>(
  _ firstBound: GeneralizedRangeBound<Bound>,
  _ otherBounds: GeneralizedRangeBound<Bound>...,
  side: GeneralizedRangeBound<Bound>._Side
) -> GeneralizedRangeBound<Bound> where Bound: Comparable {
  var max: GeneralizedRangeBound<Bound> = firstBound
  for boundary in otherBounds {
    if boundary == .unbounded && side == .upper { return .unbounded }
    if max._compare(boundary, side: side).foundationComparisonResult == .orderedAscending {
      max = boundary
    }
  }
  return max
}

internal func _min<Bound>(
  _ firstBounds: GeneralizedRangeBound<Bound>,
  _ otherBounds: GeneralizedRangeBound<Bound>...,
  side:GeneralizedRangeBound<Bound>._Side
) -> GeneralizedRangeBound<Bound> where Bound: Comparable {
  var min: GeneralizedRangeBound<Bound> = firstBounds
  for boundary in otherBounds {
    if boundary == .unbounded && side == .lower { return .unbounded }
    if min._compare(boundary, side: side).foundationComparisonResult == .orderedDescending {
      min = boundary
    }
  }
  return min
}



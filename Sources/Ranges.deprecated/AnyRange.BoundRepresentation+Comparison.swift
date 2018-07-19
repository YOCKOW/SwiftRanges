/***************************************************************************************************
 AnyRange.BoundRepresentation+Comparison.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Foundation

extension AnyRange.BoundRepresentation {
  internal enum _WhichBound {
    case lower, upper
  }
}

extension AnyRange.BoundRepresentation {
  /// See "AnyRange+Comparable.swift" to know how to compare ranges...
  internal func _compare(_ other:AnyRange.BoundRepresentation, as bound:_WhichBound) -> ComparisonResult {
    if self.bound < other.bound { return .orderedAscending }
    if self.bound > other.bound { return .orderedDescending }
    
    // from here, self.bound == other.bound
    if self.isIncluded == other.isIncluded { return .orderedSame }
    if self.isIncluded {
      // other is not included
      return bound == .lower ? .orderedAscending : .orderedDescending
    }
    return bound == .lower ? .orderedDescending : .orderedAscending
  }
}

extension AnyRange.BoundRepresentation {
  internal static func _max(
    _ firstBound:AnyRange.BoundRepresentation?,
    _ otherBounds:AnyRange.BoundRepresentation?...,
    as side:AnyRange.BoundRepresentation._WhichBound) -> AnyRange.BoundRepresentation?
  {
    if firstBound == nil && side == .upper { return nil }
    var nilableMax: AnyRange.BoundRepresentation? = firstBound
    
    for nilableBound in otherBounds {
      switch (nilableBound, side) {
      case (nil, .lower):
        break
      case (nil, .upper):
        return nil
      case (let bound?, _):
        if let max = nilableMax {
          if max._compare(bound, as:side) == .orderedAscending { nilableMax = bound }
        } else {
          // nilableMax == nil
          if side == .lower {
            nilableMax = bound
          } else {
            // nilableMax must not be nil here if side == .upper
            assertionFailure("nilableMax must not be nil.")
          }
        }
      }
    }
    
    return nilableMax
  }
  
  internal static func _min(
    _ firstBound:AnyRange.BoundRepresentation?,
    _ otherBounds:AnyRange.BoundRepresentation?...,
    as side:AnyRange.BoundRepresentation._WhichBound) -> AnyRange.BoundRepresentation?
  {
    if firstBound == nil && side == .lower { return nil }
    var nilableMin: AnyRange.BoundRepresentation? = firstBound
    
    for nilableBound in otherBounds {
      switch (nilableBound, side) {
      case (nil, .lower):
        return nil
      case (nil, .upper):
        break
      case (let bound?, _):
        if let min = nilableMin {
          if min._compare(bound, as:side) == .orderedDescending { nilableMin = bound }
        } else {
          // nilableMin == nil
          if side == .upper {
            nilableMin = bound
          } else {
            // nilableMin must not be nil here if side == .lower
            assertionFailure("nilableMin must not be nil.")
          }
        }
      }
    }
    
    return nilableMin
  }
}


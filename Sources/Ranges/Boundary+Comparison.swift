/***************************************************************************************************
 Boundary+Comparison.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import Foundation

extension Boundary {
  internal enum _Side {
    case lower, upper
  }
}

extension Boundary {
  internal func _compare(_ other:Boundary<Bound>, as side:_Side) -> ComparisonResult {
    if self.bound < other.bound { return .orderedAscending }
    if self.bound > other.bound { return .orderedDescending }
    
    // from here, self.bound == other.bound
    if self.isIncluded == other.isIncluded { return .orderedSame }
    if self.isIncluded {
      // other is not included
      return side == .lower ? .orderedAscending : .orderedDescending
    }
    return side == .lower ? .orderedDescending : .orderedAscending
  }
}

extension Boundary {
  internal static func _max(
    _ firstBoundary:Boundary?,
    _ otherBoundaries:Boundary?...,
    as side:Boundary._Side) -> Boundary?
  {
    if firstBoundary == nil && side == .upper { return nil }
    var nilableMax: Boundary? = firstBoundary
    
    for nilableBoundary in otherBoundaries {
      switch (nilableBoundary, side) {
      case (nil, .lower):
        break
      case (nil, .upper):
        return nil
      case (let boundary?, _):
        if let max = nilableMax {
          if max._compare(boundary, as:side) == .orderedAscending { nilableMax = boundary }
        } else {
          // nilableMax == nil
          if side == .lower {
            nilableMax = boundary
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
    _ firstBoundary:Boundary?,
    _ otherBoundaries:Boundary?...,
    as side:Boundary._Side) -> Boundary?
  {
    if firstBoundary == nil && side == .lower { return nil }
    var nilableMin: Boundary? = firstBoundary
    
    for nilableBoundary in otherBoundaries {
      switch (nilableBoundary, side) {
      case (nil, .lower):
        return nil
      case (nil, .upper):
        break
      case (let boundary?, _):
        if let min = nilableMin {
          if min._compare(boundary, as:side) == .orderedDescending { nilableMin = boundary }
        } else {
          // nilableMin == nil
          if side == .upper {
            nilableMin = boundary
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


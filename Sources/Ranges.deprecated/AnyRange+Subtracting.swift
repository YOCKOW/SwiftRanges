/***************************************************************************************************
 AnyRange+Subtracting.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

/* ***** Unbounded ****************************************************************************** */
extension AnyRange {
  private func _unboundedRange_subtracting(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    guard case .unboundedRange = self._range else { fatalError("Illegal function call.") }
    
    // self always overlaps other.
    // other is not empty nor unbounded.
    switch other._range {
    case .closedRange(let range):
      return (AnyRange(..<range.lowerBound), AnyRange(range.upperBound<..))
    case .leftOpenRange(let range):
      return (AnyRange(...range.lowerBound), AnyRange(range.upperBound<..))
    case .openRange(let range):
      return (AnyRange(...range.lowerBound), AnyRange(range.upperBound...))
    case .range(let range):
      return (AnyRange(..<range.lowerBound), AnyRange(range.upperBound...))
      
    case .partialRangeFrom(let range):
      return (AnyRange(..<range.lowerBound), nil)
    case .partialRangeGreaterThan(let range):
        return (AnyRange(...range.lowerBound), nil)
    case .partialRangeThrough(let range):
      return (AnyRange(range.upperBound<..), nil)
    case .partialRangeUpTo(let range):
      return (AnyRange(range.upperBound...), nil)
      
    default:
      fatalError("Illegal function call.")
    }
  }
}

/* ***** Upper Bounded ************************************************************************** */
extension AnyRange {
  private func _upperBounded_subtracting_lowerBounded(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self: ------------/
    // other:       /----------------
    guard let otherBounds = other.bounds, let otherLower = otherBounds.lower else {
      fatalError("Illegal function call.")
    }
    return (AnyRange(uncheckedBounds:(lower:nil, upper:~otherLower)), nil)
  }
}

extension AnyRange {
  private func _upperBounded_subtracting_greaterUpper(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self: -------------------/
    // other:     ?--------------------/
    guard let otherBounds = other.bounds else { fatalError("Illegal function call.") }
    if let otherLower = otherBounds.lower {
      //  self: -------------------/
      // other:     /--------------------/
      return (AnyRange(uncheckedBounds:(lower:nil, upper:~otherLower)), nil)
    } else {
      //  self: -------------------/
      // other: -------------------------/
      return (.empty, nil)
    }
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  private func _upperBounded_subtracting_lessUpper(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self: -------------------/
    // other:     ?--------/
    guard let myBounds = self.bounds, let myUpper = myBounds.upper,
          let otherBounds = other.bounds, let otherUpper = otherBounds.upper else {
      fatalError("Illegal function call.")
    }
    
    let range1 = AnyRange(uncheckedBounds:(lower:~otherUpper, upper:myUpper))
    if let otherLower = otherBounds.lower {
      //  self: -------------------/
      // other:     /-------/
      let range0 = AnyRange(uncheckedBounds:(lower:nil, upper:~otherLower))
      return (range0, range1)
    } else {
      //  self: -------------------/
      // other: ------------/
      return (range1, nil)
    }
  }
}
extension AnyRange {
  private func _upperBounded_subtracting_lessUpper(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self: -------------------/
    // other:     ?--------/
    guard let myBounds = self.bounds, let myUpper = myBounds.upper,
      let otherBounds = other.bounds, let otherUpper = otherBounds.upper else {
        fatalError("Illegal function call.")
    }
    
    let range1 = AnyRange(uncheckedBounds:(lower:~otherUpper, upper:myUpper))
    if let otherLower = otherBounds.lower {
      //  self: -------------------/
      // other:     /-------/
      let range0 = AnyRange(uncheckedBounds:(lower:nil, upper:~otherLower))
      return (range0, range1)
    } else {
      //  self: -------------------/
      // other: ------------/
      return (range1, nil)
    }
  }
}

/* ***** Lower Bounded ************************************************************************** */
extension AnyRange {
  private func _lowerBounded_subtracting_upperBounded(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self:     /------------
    // other: -----------/
    guard let otherUpper = other.bounds?.upper else { fatalError("Illegal function call.") }
    return (AnyRange(uncheckedBounds:(lower:~otherUpper, upper:nil)), nil)
  }
}

extension AnyRange {
  private func _lowerBounded_subtracting_lessLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self:    /-----------
    // other: /----?
    if let otherUpper = other.bounds?.upper {
      //  self:    /-----------
      // other: /-------/
      return (AnyRange(uncheckedBounds:(lower:~otherUpper, upper:nil)), nil)
    } else {
      //  self:    /-----------
      // other: /--------------
      return (.empty, nil)
    }
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  private func _lowerBounded_subtracting_greaterLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self:      /----------------
    // other:          /-----?
    guard let myLower = self.bounds?.lower, let otherLower = other.bounds?.lower else {
      fatalError("Illegal function call.")
    }
    let range0 = AnyRange(uncheckedBounds:(lower:myLower, upper:~otherLower))
    if let otherUpper = other.bounds?.upper {
      //  self:      /----------------
      // other:          /-----/
      let range1 = AnyRange(uncheckedBounds:(lower:~otherUpper, upper:nil))
      return (range0, range1)
    } else {
      //  self:      /----------------
      // other:          /------------
      return (range0, nil)
    }
  }
}
extension AnyRange {
  private func _lowerBounded_subtracting_greaterLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self:      /----------------
    // other:          /-----?
    guard let myLower = self.bounds?.lower, let otherLower = other.bounds?.lower else {
      fatalError("Illegal function call.")
    }
    let range0 = AnyRange(uncheckedBounds:(lower:myLower, upper:~otherLower))
    if let otherUpper = other.bounds?.upper {
      //  self:      /----------------
      // other:          /-----/
      let range1 = AnyRange(uncheckedBounds:(lower:~otherUpper, upper:nil))
      return (range0, range1)
    } else {
      //  self:      /----------------
      // other:          /------------
      return (range0, nil)
    }
  }
}

/* ***** Bounded - Lower-Bounded **************************************************************** */
extension AnyRange {
  private func _bounded_subtracting_lowerBounded_lessLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    guard let myLower = self.bounds?.lower, let otherLower = other.bounds?.lower else {
      fatalError("Illegal function call.")
    }
    assert(myLower._compare(otherLower, as:.lower) != .orderedAscending)
    
    //  self:       /----------/
    // other:   /------------------------
    return (.empty, nil)
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  private func _bounded_subtracting_lowerBounded_greaterLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    guard let myLower = self.bounds?.lower, let otherLower = other.bounds?.lower else {
      fatalError("Illegal function call.")
    }
    assert(myLower._compare(otherLower, as:.lower) != .orderedDescending)
    
    //  self:  /----------/
    // other:     /------------------------
    return (AnyRange(uncheckedBounds:(lower:myLower, upper:~otherLower)), nil)
  }
}
extension AnyRange {
  private func _bounded_subtracting_lowerBounded_greaterLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    guard let myLower = self.bounds?.lower, let otherLower = other.bounds?.lower else {
      fatalError("Illegal function call.")
    }
    assert(myLower._compare(otherLower, as:.lower) != .orderedDescending)
    
    //  self:  /----------/
    // other:     /------------------------
    return (AnyRange(uncheckedBounds:(lower:myLower, upper:~otherLower)), nil)
  }
}

/* ***** Bounded - Upper-Bounded **************************************************************** */
extension AnyRange {
  private func _bounded_subtracting_upperBounded_greaterUpper(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    guard let myUpper = self.bounds?.upper, let otherUpper = other.bounds?.upper else {
      fatalError("Illegal function call.")
    }
    assert(myUpper._compare(otherUpper, as:.upper) != .orderedDescending)
    
    //  self:    /----------/
    // other: --------------------/
    return (.empty, nil)
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  private func _bounded_subtracting_upperBounded_lessUpper(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self:    /----------/
    // other: --------/
    guard let myUpper = self.bounds?.upper, let otherUpper = other.bounds?.upper else {
      fatalError("Illegal function call.")
    }
    assert(myUpper._compare(otherUpper, as:.upper) != .orderedAscending)
    
    return (AnyRange(uncheckedBounds:(lower:~otherUpper, upper:myUpper)), nil)
  }
}
extension AnyRange {
  private func _bounded_subtracting_upperBounded_lessUpper(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self:    /----------/
    // other: --------/
    guard let myUpper = self.bounds?.upper, let otherUpper = other.bounds?.upper else {
      fatalError("Illegal function call.")
    }
    assert(myUpper._compare(otherUpper, as:.upper) != .orderedAscending)
    
    return (AnyRange(uncheckedBounds:(lower:~otherUpper, upper:myUpper)), nil)
  }
}

/* ***** Bounded - Bounded ********************************************************************** */
extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  private func _bounded_subtracting_bounded_lessLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self:       /----------/
    // other:   /----------?
    guard let myUpper = self.bounds?.upper, let otherUpper = other.bounds?.upper else {
      fatalError("Illegal function call.")
    }
    
    if myUpper._compare(otherUpper, as:.upper) == .orderedAscending {
      //  self:       /----------/
      // other:   /--------------------/
      return (.empty, nil)
    } else {
      //  self:       /----------/
      // other:   /---------/
      return (AnyRange(uncheckedBounds:(lower:~otherUpper, upper:myUpper)), nil)
    }
  }
}
extension AnyRange {
  private func _bounded_subtracting_bounded_lessLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self:       /----------/
    // other:   /----------?
    guard let myUpper = self.bounds?.upper, let otherUpper = other.bounds?.upper else {
      fatalError("Illegal function call.")
    }
    
    if myUpper._compare(otherUpper, as:.upper) == .orderedAscending {
      //  self:       /----------/
      // other:   /--------------------/
      return (.empty, nil)
    } else {
      //  self:       /----------/
      // other:   /---------/
      return (AnyRange(uncheckedBounds:(lower:~otherUpper, upper:myUpper)), nil)
    }
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  private func _bounded_subtracting_bounded_greaterLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self: /---------------------/
    // other:      /----------?
    guard
      let myBounds = self.bounds,
      let myLower = myBounds.lower, let myUpper = myBounds.upper,
      let otherBounds = other.bounds,
      let otherLower = otherBounds.lower, let otherUpper = otherBounds.upper
    else {
      fatalError("Illegal function call.")
    }
    
    let range0 = AnyRange(uncheckedBounds:(lower:myLower, upper:~otherLower))
    if myUpper._compare(otherUpper, as:.upper) == .orderedAscending {
      //  self: /---------------------/
      // other:      /-----------------------/
      return (range0, nil)
    } else {
      //  self: /---------------------/
      // other:      /----------/
      return (range0, AnyRange(uncheckedBounds:(lower:~otherUpper, upper:myUpper)))
    }
  }
}
extension AnyRange {
  private func _bounded_subtracting_bounded_greaterLower(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    //  self: /---------------------/
    // other:      /----------?
    guard
      let myBounds = self.bounds,
      let myLower = myBounds.lower, let myUpper = myBounds.upper,
      let otherBounds = other.bounds,
      let otherLower = otherBounds.lower, let otherUpper = otherBounds.upper
      else {
        fatalError("Illegal function call.")
    }
    
    let range0 = AnyRange(uncheckedBounds:(lower:myLower, upper:~otherLower))
    if myUpper._compare(otherUpper, as:.upper) == .orderedAscending {
      //  self: /---------------------/
      // other:      /-----------------------/
      return (range0, nil)
    } else {
      //  self: /---------------------/
      // other:      /----------/
      return (range0, AnyRange(uncheckedBounds:(lower:~otherUpper, upper:myUpper)))
    }
  }
}


/* ***** ALL ************************************************************************************ */
extension AnyRange {
  private func _subtracting(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    // The result must be .empty if...
    if self == other || self.isEmpty || other.isUnboundedRange { return (.empty, nil) }
    
    // The result must be equal to self if...
    if other.isEmpty || !self.overlaps(other) { return (self, nil) }
    
    // if self is unbounded...
    if self.isUnboundedRange { return self._unboundedRange_subtracting(other) }
    
    // From here, self is not empty nor unbounded, and other is not empty nor unbounded.
    // Furthermore, self always overlaps other.
    let myBounds = self.bounds!
    let otherBounds = other.bounds!
    
    switch (myBounds.lower, otherBounds.lower, myBounds.upper, otherBounds.upper) {
    case (nil, _, let myUpper?, let nilableOtherUpper):
      // self is upper-bounded
      if let otherUpper = nilableOtherUpper {
        if myUpper._compare(otherUpper, as:.upper) == .orderedAscending {
          return self._upperBounded_subtracting_greaterUpper(other)
        } else {
          // **Depends on countability**
          return self._upperBounded_subtracting_lessUpper(other)
        }
      } else {
        return self._upperBounded_subtracting_lowerBounded(other)
      }
      
    case (let myLower?, let nilableOtherLower, nil, _):
      // self is lower-bounded
      if let otherLower = nilableOtherLower {
        if myLower._compare(otherLower, as:.lower) == .orderedDescending {
          return self._lowerBounded_subtracting_lessLower(other)
        } else {
          // **Depends on countability**
          return self._lowerBounded_subtracting_greaterLower(other)
        }
      } else {
        return self._lowerBounded_subtracting_upperBounded(other)
      }
      
    case (let myLower?, let otherLower?, _?, nil):
      // self is bounded
      // other is lower-bounded
      if myLower._compare(otherLower, as:.lower) == .orderedDescending {
        return self._bounded_subtracting_lowerBounded_lessLower(other)
      } else {
        // **Depends on countability**
        return self._bounded_subtracting_lowerBounded_greaterLower(other)
      }
      
    case (_?, nil, let myUpper?, let otherUpper?):
      // self is bounded
      // other is upper-bounded
      if myUpper._compare(otherUpper, as:.upper) == .orderedAscending {
        return self._bounded_subtracting_upperBounded_greaterUpper(other)
      } else {
        // **Depends on countability**
        return self._bounded_subtracting_upperBounded_lessUpper(other)
      }
      
    case (let myLower?, let otherLower?, _?, _?):
      // both self and other are bounded.
      if myLower._compare(otherLower, as:.lower) == .orderedDescending {
        // **Depends on countability**
        return self._bounded_subtracting_bounded_lessLower(other)
      } else {
        // **Depends on countability**
        return self._bounded_subtracting_bounded_greaterLower(other)
      }
      
    default:
      fatalError("default must never be executed.")
    }
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  /// They are handled as countable ranges.
  public func subtracting(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    // `overlaps` depends on countability
    if !self.overlaps(other) { return (self, nil) }
    
    guard let myBounds = self.bounds, let otherBounds = other.bounds  else {
      return self._subtracting(other)
    }
    
    switch (myBounds.lower, otherBounds.lower, myBounds.upper, otherBounds.upper) {
    // Only cases depending on countability...
      
    case (nil, _, let myUpper?, let otherUpper?)
      where myUpper._compare(otherUpper, as:.upper) != .orderedAscending:
      return self._upperBounded_subtracting_lessUpper(other)
      
    case (let myLower?, let otherLower?, nil, _)
      where myLower._compare(otherLower, as:.lower) != .orderedDescending:
      return self._lowerBounded_subtracting_greaterLower(other)
      
    case (let myLower?, let otherLower?, _?, nil)
      where myLower._compare(otherLower, as:.lower) != .orderedDescending:
      return self._bounded_subtracting_lowerBounded_greaterLower(other)
      
    case (_?, nil, let myUpper?, let otherUpper?)
      where myUpper._compare(otherUpper, as:.upper) != .orderedAscending:
      return self._bounded_subtracting_upperBounded_lessUpper(other)
      
    case (let myLower?, let otherLower?, _?, _?):
      // both self and other are bounded.
      if myLower._compare(otherLower, as:.lower) == .orderedDescending {
        // **Depends on countability**
        return self._bounded_subtracting_bounded_lessLower(other)
      } else {
        // **Depends on countability**
        return self._bounded_subtracting_bounded_greaterLower(other)
      }
    
    default:
      return self._subtracting(other)
    }
  }
}

extension AnyRange {
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  public func subtracting(_ other:AnyRange) -> (AnyRange, AnyRange?) {
    return self._subtracting(other)
  }
}

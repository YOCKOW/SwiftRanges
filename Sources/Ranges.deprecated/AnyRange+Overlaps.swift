/***************************************************************************************************
 AnyRange+Overlaps.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

/* ***** ClosedRange **************************************************************************** */
extension AnyRange {
  /// `self._range` must be `.closedRange`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func _closedRange_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .closedRange(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .closedRange(let other_range):
      return my_range.overlaps(other_range)
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeFrom(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeThrough(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
    
    default:
      fatalError("Illegal function call.")
    }
  }
}

/* ***** LeftOpenRange ************************************************************************** */
extension AnyRange {
  /// `self._range` must be `.leftOpenRange`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func __leftOpenRange_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .leftOpenRange(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .closedRange(let other_range):
      return my_range.overlaps(other_range)
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeFrom(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeThrough(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      fatalError("Illegal function call.")
    }
  }
}
extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// `self._range` must be `.leftOpenRange`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  /// FOR COUNTABLE RANGES.
  private func _leftOpenRange_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .leftOpenRange(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      return self.__leftOpenRange_overlaps(other)
    }
  }
}
extension AnyRange {
  /// `self._range` must be `.leftOpenRange`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func _leftOpenRange_overlaps(_ other:AnyRange<Bound>) -> Bool {
    return self.__leftOpenRange_overlaps(other)
  }
}

/* ***** OpenRange ****************************************************************************** */
extension AnyRange {
  /// `self._range` must be `.openRange`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func __openRange_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .openRange(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .closedRange(let other_range):
      return my_range.overlaps(other_range)
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeFrom(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeThrough(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      fatalError("Illegal function call.")
    }
  }
}
extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// `self._range` must be `.openRange`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  /// FOR COUNTABLE RANGES.
  private func _openRange_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .openRange(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      return self.__openRange_overlaps(other)
    }
  }
}
extension AnyRange {
  /// `self._range` must be `.openRange`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func _openRange_overlaps(_ other:AnyRange<Bound>) -> Bool {
    return self.__openRange_overlaps(other)
  }
}

/* ***** Range ********************************************************************************** */
extension AnyRange {
  /// `self._range` must be `.range`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func __range_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .range(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .closedRange(let other_range):
      return my_range.overlaps(other_range)
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeFrom(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeThrough(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      fatalError("Illegal function call.")
    }
  }
}
extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// `self._range` must be `.range`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  /// FOR COUNTABLE RANGES.
  private func _range_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .range(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      return self.__range_overlaps(other)
    }
  }
}
extension AnyRange {
  /// `self._range` must be `.range`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func _range_overlaps(_ other:AnyRange<Bound>) -> Bool {
    return self.__range_overlaps(other)
  }
}

/* ***** PartialRangeFrom *********************************************************************** */
extension AnyRange {
  /// `self._range` must be `.partialRangeFrom`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func _from_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .partialRangeFrom(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .closedRange(let other_range):
      return my_range.overlaps(other_range)
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeFrom(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeThrough(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      fatalError("Illegal function call.")
    }
  }
}

/* ***** PartialRangeGreaterThan **************************************************************** */
extension AnyRange {
  /// `self._range` must be `.partialRangeGreaterThan`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func __greaterThan_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .partialRangeGreaterThan(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .closedRange(let other_range):
      return my_range.overlaps(other_range)
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeFrom(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeThrough(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      fatalError("Illegal function call.")
    }
  }
}
extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// `self._range` must be `.partialRangeGreaterThan`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  /// FOR COUNTABLE RANGES.
  private func _greaterThan_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .partialRangeGreaterThan(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      return self.__greaterThan_overlaps(other)
    }
  }
}
extension AnyRange {
  /// `self._range` must be `.partialRangeGreaterThan`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func _greaterThan_overlaps(_ other:AnyRange<Bound>) -> Bool {
    return self.__greaterThan_overlaps(other)
  }
}

/* ***** PartialRangeThrough ******************************************************************** */
extension AnyRange {
  /// `self._range` must be `.partialRangeThrough`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func _through_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .partialRangeThrough(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .closedRange(let other_range):
      return my_range.overlaps(other_range)
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeFrom(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeThrough(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      fatalError("Illegal function call.")
    }
  }
}

/* ***** PartialRangeUpTo *********************************************************************** */
extension AnyRange {
  /// `self._range` must be `.partialRangeUpTo`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func __upTo_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .partialRangeUpTo(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .closedRange(let other_range):
      return my_range.overlaps(other_range)
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
    case .range(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeFrom(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeThrough(let other_range):
      return my_range.overlaps(other_range)
    case .partialRangeUpTo(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      fatalError("Illegal function call.")
    }
  }
}
extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// `self._range` must be `.partialRangeUpTo`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  /// FOR COUNTABLE RANGES.
  private func _upTo_overlaps(_ other:AnyRange<Bound>) -> Bool {
    guard case .partialRangeUpTo(let my_range) = self._range else { fatalError("Illegal function call.") }
    
    switch other._range {
    case .leftOpenRange(let other_range):
      return my_range.overlaps(other_range)
    case .openRange(let other_range):
      return my_range.overlaps(other_range)
      
    case .partialRangeGreaterThan(let other_range):
      return my_range.overlaps(other_range)
      
    default:
      return self.__upTo_overlaps(other)
    }
  }
}
extension AnyRange {
  /// `self._range` must be `.partialRangeUpTo`.
  /// `other._range` must not be `.empty` nor `.unboundedRange`.
  private func _upTo_overlaps(_ other:AnyRange<Bound>) -> Bool {
    return self.__upTo_overlaps(other)
  }
}

/* ***** ALL ************************************************************************************ */
extension AnyRange {
  private func _overlaps(_ other:AnyRange<Bound>) -> Bool {
    switch (self._range, other._range) {
    case (.empty, _), (_, .empty):
      return false
    case (.unboundedRange, _), (_, .unboundedRange):
      return true
      
    case (.closedRange, _):
      return self._closedRange_overlaps(other)
    case (.leftOpenRange, _):
      return self._leftOpenRange_overlaps(other)
    case (.openRange, _):
      return self._openRange_overlaps(other)
    case (.range, _):
      return self._range_overlaps(other)
      
    case (.partialRangeFrom, _):
      return self._from_overlaps(other)
    case (.partialRangeGreaterThan, _):
      return self._greaterThan_overlaps(other)
    case (.partialRangeThrough, _):
      return self._through_overlaps(other)
    case (.partialRangeUpTo, _):
      return self._upTo_overlaps(other)
      
    }
  }
}
extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  /// They will be handled as countable ranges.
  public func overlaps(_ other:AnyRange<Bound>) -> Bool {
    switch (self._range, other._range) {
    case (.empty, _), (_, .empty):
      return false
    case (.unboundedRange, _), (_, .unboundedRange):
      return true
      
    case (.leftOpenRange, _):
      return self._leftOpenRange_overlaps(other)
    case (.openRange, _):
      return self._openRange_overlaps(other)
    case (.range, _):
      return self._range_overlaps(other)
      
    case (.partialRangeGreaterThan, _):
      return self._greaterThan_overlaps(other)
    case (.partialRangeUpTo, _):
      return self._upTo_overlaps(other)
      
    default:
      return self._overlaps(other)
      
    }
  }
}
extension AnyRange {
  /// Returns a Boolean value indicating whether this range and the given range contain an element
  /// in common.
  public func overlaps(_ other:AnyRange<Bound>) -> Bool {
    return self._overlaps(other)
  }
}

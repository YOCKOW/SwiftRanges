/* *************************************************************************************************
 GeneralizedRange+Subtraction.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@available(*, unavailable)
extension GeneralizedRange {
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  /// They are handled as countable ranges.
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return AnyRange<Bound>(self).subtracting(AnyRange<Bound>(other))
  }
  
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound
  {
    return AnyRange<Bound>(self).subtracting(AnyRange<Bound>(other))
  }
}

extension GeneralizedRange {
  fileprivate func _subtracting<R>(_ other: R) -> (
    any GeneralizedRange<Bound>,
    (any GeneralizedRange<Bound>)?
  ) where R: GeneralizedRange, R.Bound == Bound {
    guard let myBounds = self.bounds else {
      return (EmptyRange<Bound>(), nil)
    }
    guard let otherBounds = other.bounds else {
      return (self, nil)
    }

    // Not overlaps...
    if (
      myBounds.lower._compare(otherBounds.upper, side: .lower) == .definitelyOrderedDescending ||
      myBounds.upper._compare(otherBounds.lower, side: .upper) == .definitelyOrderedAscending
    ) {
      return (self, nil)
    }

    var subtracted: [any GeneralizedRange<Bound>] = []

    // /------ self -----
    //     /----- other -----
    if (
      otherBounds.lower != .unbounded &&
      myBounds.lower._compare(otherBounds.lower, side: .lower) == .definitelyOrderedAscending
    ) {
      let lowerRangeBounds: Bounds<Bound> = (
        lower: myBounds.lower,
        upper: ~otherBounds.lower
      )
      let lowerRange = _makeUncountableRange(lowerRangeBounds)
      if !lowerRange.isEmpty {
        subtracted.append(lowerRange)
      }
    }

    //      ----- self -----/
    // ----- other -----/
    if (
      otherBounds.upper != .unbounded &&
      myBounds.upper._compare(otherBounds.upper, side: .upper) == .definitelyOrderedDescending
    ) {
      let upperRangeBounds: Bounds<Bound> = (
        lower: ~otherBounds.upper,
        upper: myBounds.upper
      )
      let upperRange = _makeUncountableRange(upperRangeBounds)
      if !upperRange.isEmpty {
        subtracted.append(upperRange)
      }
    }

    switch subtracted.count {
    case 0:
      return (EmptyRange<Bound>(), nil)
    case 1:
      return (subtracted[0], nil)
    case 2:
      return (subtracted[0], subtracted[1])
    default:
      fatalError("Unexpected subtraction?!")
    }
  }

  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  public func subtracting<R>(_ other: R) -> (
    any GeneralizedRange<Bound>,
    (any GeneralizedRange<Bound>)?
  ) where R: GeneralizedRange, R.Bound == Bound {
    return self._subtracting(other)
  }
}

extension GeneralizedCountableRange {
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  public func subtracting<R>(_ other: R) -> (
    any GeneralizedCountableRange<Bound>,
    (any GeneralizedCountableRange<Bound>)?
  ) where R: GeneralizedRange, R.Bound == Bound {
    func __forceCountable(_ range: any GeneralizedRange<Bound>) -> any GeneralizedCountableRange<Bound> {
      return (
        (range as? any GeneralizedCountableRange<Bound>) ??
        range._wellknownRange as! any GeneralizedCountableRange<Bound>
      )
    }

    let subtracted = self._subtracting(other)
    return (
      __forceCountable(subtracted.0),
      subtracted.1.map(__forceCountable)
    )
  }
}

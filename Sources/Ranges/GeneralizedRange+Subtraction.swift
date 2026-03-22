/* *************************************************************************************************
 GeneralizedRange+Subtraction.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@available(
  *, unavailable,
  message: "Use `subtracting(_:) -> any GeneralizedRange<Bound>` instead."
)
extension GeneralizedRange {
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  /// They are handled as countable ranges.
  @available(*, deprecated)
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return AnyRange<Bound>(self).subtracting(AnyRange<Bound>(other))
  }
  
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  @available(*, deprecated)
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound
  {
    return AnyRange<Bound>(self).subtracting(AnyRange<Bound>(other))
  }
}

extension GeneralizedRange {
  public typealias SubtractionResult = (any GeneralizedRange<Bound>, (any GeneralizedRange<Bound>)?)

  fileprivate func _subtracting<R>(_ other: R) -> SubtractionResult where R: GeneralizedRange,
                                                                         R.Bound == Bound
  {
    var emptyResult: SubtractionResult {
      return (EmptyRange<Bound>(), nil)
    }

    var selfResult: SubtractionResult {
      return (self, nil)
    }

    guard let myBounds = self.bounds else {
      return emptyResult
    }

    if other.isEmpty {
      return selfResult
    }

    guard let intersectionBounds = self.intersection(other).bounds else {
      return selfResult
    }

    var subtracted: [any GeneralizedRange<Bound>] = []

    switch myBounds.lower._compare(intersectionBounds.lower, side: .lower) {
    case .definitelyOrderedSame, .orderedAscendingButConsideredEquivalent:
      break
    case .definitelyOrderedAscending:
      let lowerSubRange = _makeRange(
        uncheckedBounds: (
          lower: myBounds.lower,
          upper: ~intersectionBounds.lower
        )
      )
      if !lowerSubRange.isEmpty {
        subtracted.append(lowerSubRange)
      }
    case .definitelyOrderedDescending, .orderedDescendingButConsideredEquivalent:
      fatalError("Unexpected Intersection?!")
    }

    switch intersectionBounds.upper._compare(myBounds.upper, side: .upper) {
    case .definitelyOrderedSame, .orderedAscendingButConsideredEquivalent:
      break
    case .definitelyOrderedAscending:
      let upperSubRange = _makeRange(
        uncheckedBounds: (
          lower: ~intersectionBounds.upper,
          upper: myBounds.upper
        )
      )
      if !upperSubRange.isEmpty {
        subtracted.append(upperSubRange)
      }
    case .definitelyOrderedDescending, .orderedDescendingButConsideredEquivalent:
      fatalError("Unexpected Intersection?!")
    }


    switch subtracted.count {
    case 0:
      return emptyResult
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
        range.bounds.map({
          _makeRange(uncheckedBounds: $0) as! any GeneralizedCountableRange<Bound>
        })  ??
        EmptyRange<Bound>()
      )
    }

    let subtracted = self._subtracting(other)
    return (
      __forceCountable(subtracted.0),
      subtracted.1.map(__forceCountable)
    )
  }
}

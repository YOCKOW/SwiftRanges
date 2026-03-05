/* *************************************************************************************************
 GeneralizedRange+Intersection.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@available(
  *, unavailable,
   message: "Use `intersection(_:) -> {any|some} GeneralizedRange<Bound>` instead."
)
extension GeneralizedRange {
  /// Returns a new *countable* range that is an intersection of `self` and `other`.
  @available(*, deprecated)
  public func intersection<R>(_ other:R) -> AnyRange<Bound>
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return AnyRange<Bound>(self).intersection(AnyRange<Bound>(other))
  }
  
  /// Returns a new range that is an intersection of `self` and `other`.
  @available(*, deprecated)
  public func intersection<R>(_ other:R) -> AnyRange<Bound>
    where R:GeneralizedRange, R.Bound == Bound
  {
    return AnyRange<Bound>(self).intersection(AnyRange<Bound>(other))
  }
  
  /// Returns `.empty`.
  @available(*, deprecated)
  public func intersection(_:()) -> AnyRange<Bound> {
    return .empty
  }
  
  /// Returns `AnyRange<Bound>(self)`
  @available(*, deprecated)
  public func intersection(_:UnboundedRange) -> AnyRange<Bound> {
    return AnyRange<Bound>(self)
  }
}

extension GeneralizedRange {
  fileprivate func _intersectionBounds<R>(
    _ other: R
  ) -> Bounds<Bound>? where R: GeneralizedRange, R.Bound == Bound {
    guard let myBounds = self.bounds, let otherBounds = other.bounds else {
      return nil
    }
    let lower = _max(myBounds.lower, otherBounds.lower, side: .lower)
    let upper = _min(myBounds.upper, otherBounds.upper, side: .upper)
    return (lower: lower, upper: upper)
  }

  /// Returns a new range that is an intersection of `self` and `other`.
  public func intersection<R>(
    _ other: R
  ) -> any GeneralizedRange<Bound> where R: GeneralizedRange, R.Bound == Bound {
    guard let intersectionBounds = self._intersectionBounds(other) else {
      return EmptyRange<Bound>()
    }
    return _makeUncountableRange(intersectionBounds)
  }

  /// Returns an empty range.
  public func intersection(_: ()) -> some GeneralizedRange<Bound> {
    return EmptyRange<Bound>()
  }

  /// Returns `self`.
  public func intersection(_: UnboundedRange) -> some GeneralizedRange<Bound> {
    return self
  }
}

extension GeneralizedCountableRange {
  /// Returns a new coutable range that is an intersection of `self` and `other`.
  public func intersection<R>(
    _ other: R
  ) -> any GeneralizedCountableRange<Bound> where R: GeneralizedRange, R.Bound == Bound {
    guard let intersectionBounds = self._intersectionBounds(other) else {
      return EmptyRange<Bound>()
    }
    return _makeCountableRange(intersectionBounds)
  }

  /// Returns an empty range.
  public func intersection(_: ()) -> some GeneralizedCountableRange<Bound> {
    return EmptyRange<Bound>()
  }

  /// Returns `self`.
  public func intersection(_: UnboundedRange) -> some GeneralizedCountableRange<Bound> {
    return self
  }
}

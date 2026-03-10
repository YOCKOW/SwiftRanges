/* *************************************************************************************************
 GeneralizedRange+Concatenation.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@available(
  *, unavailable,
  message: "Use `concatenating(_:) -> ({any|some} GeneralizedRange<Bound>)?` instead."
)
extension GeneralizedRange {
  /// Concatenate two ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  @available(*, deprecated)
  public func concatenating<R>(_ other:R) -> AnyRange<Bound>?
    where R: GeneralizedRange, R.Bound == Self.Bound
  {
    return AnyRange(self).concatenating(.init(other))
  }
  
  /// Concatenate two **countable** ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  @available(*, deprecated)
  public func concatenating<R>(_ other:R) -> AnyRange<Bound>?
    where R: GeneralizedRange, R.Bound == Self.Bound,
          R.Bound: Strideable, R.Bound.Stride: SignedInteger
  {
    return AnyRange(self).concatenating(.init(other))
  }
  
  /// Returns `AnyRange<Bound>(self)`
  @available(*, deprecated)
  public func concatenating(_:()) -> AnyRange<Bound>? {
    return AnyRange<Bound>(self)
  }
  
  /// Returns `.unbounded`
  @available(*, deprecated)
  public func concatenating(_:UnboundedRange) -> AnyRange<Bound>? {
    return .unbounded
  }
}

extension GeneralizedRange {
  fileprivate func _concatenating<R>(
    _ other: R
  ) -> (any GeneralizedRange<Bound>)? where R: GeneralizedRange, R.Bound == Bound {
    guard let myBounds = self.bounds else {
      return other
    }
    guard let otherBounds = other.bounds else {
      return self
    }

    guard (
      myBounds.upper._isConcatenatable(with: otherBounds.lower) &&
      otherBounds.upper._isConcatenatable(with: myBounds.lower)
    ) else {
      return nil
    }
    return _makeRange(
      uncheckedBounds: (
        lower: _min(myBounds.lower, otherBounds.lower, side: .lower),
        upper: _max(myBounds.upper, otherBounds.upper, side: .upper)
      )
    )
  }

  /// Concatenate two ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  public func concatenating<R>(
    _ other: R
  ) -> (any GeneralizedRange<Bound>)? where R: GeneralizedRange, R.Bound == Bound {
    return _concatenating(other)
  }

  /// Returns `self`
  public func concatenating(_: ()) -> some GeneralizedRange<Bound> {
    return self
  }

  /// Returns an Unbounded Range.
  public func concatenating(_: UnboundedRange) -> some GeneralizedRange<Bound> {
    return TangibleUnboundedRange<Bound>()
  }
}

extension GeneralizedCountableRange {
  /// Concatenate two ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  public func concatenating<R>(
    _ other: R
  ) -> (any GeneralizedCountableRange<Bound>)? where R: GeneralizedRange, R.Bound == Bound {
    return _concatenating(other).map({ $0 as! any GeneralizedCountableRange<Bound> })
  }

  /// Returns `self`
  public func concatenating(_: ()) -> some GeneralizedCountableRange<Bound> {
    return self
  }

  /// Returns an Unbounded Range.
  public func concatenating(_: UnboundedRange) -> some GeneralizedCountableRange<Bound> {
    return TangibleUnboundedRange<Bound>()
  }
}

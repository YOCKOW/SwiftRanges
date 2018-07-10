/***************************************************************************************************
 AnyRange+BoundRepresentation.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension AnyRange {
  /// # BoundRepresentation
  ///
  /// Represents bound of ranges.
  public struct BoundRepresentation {
    let bound:Bound
    let isIncluded:Bool
    
    /// - parameter bound: The value to be regarded as a bound.
    /// - parameter included: Whether the bound should be included or not.
    public init(_ bound:Bound, isIncluded included:Bool) {
      self.bound = bound
      self.isIncluded = included
    }
  }
}

extension AnyRange.BoundRepresentation: Equatable {
  public static func ==(lhs:AnyRange.BoundRepresentation, rhs:AnyRange.BoundRepresentation) -> Bool {
    return lhs.bound == rhs.bound && lhs.isIncluded == rhs.isIncluded
  }
}

extension AnyRange {
  /// - parameter uncheckedBounds: A tuple of the lower and upper bounds of the range.
  ///                              Initialized as a partial range if one of bounds is `nil`.
  ///                              Initialized as a unbounded range if both bounds are `nil`.
  private init(
    _uncheckedBounds:(lower:AnyRange.BoundRepresentation?, upper:AnyRange.BoundRepresentation?)
  ) {
    switch _uncheckedBounds {
    case (nil, nil):
      self.init(...)
    case (let lower?, let upper?):
      
      switch (lower.isIncluded, upper.isIncluded) {
      case (true, true):
        self.init(ClosedRange<Bound>(uncheckedBounds:(lower:lower.bound, upper:upper.bound)))
      case (true, false):
        self.init(Range<Bound>(uncheckedBounds:(lower:lower.bound, upper:upper.bound)))
      case (false, true):
        self.init(LeftOpenRange<Bound>(uncheckedBounds:(lower:lower.bound, upper:upper.bound)))
      case (false, false):
        self.init(OpenRange<Bound>(uncheckedBounds:(lower:lower.bound, upper:upper.bound)))
      }
    case (let lower?, nil):
      if lower.isIncluded {
        self.init(PartialRangeFrom<Bound>(lower.bound))
      } else {
        self.init(PartialRangeGreaterThan<Bound>(lower.bound))
      }
    case (nil, let upper?):
      if upper.isIncluded {
        self.init(PartialRangeThrough<Bound>(upper.bound))
      } else {
        self.init(PartialRangeUpTo<Bound>(upper.bound))
      }
    }
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride: SignedInteger {
  /// - parameter uncheckedBounds: A tuple of the lower and upper bounds of the range.
  ///                              Initialized as a partial range if one of bounds is `nil`.
  ///                              Initialized as a unbounded range if both bounds are `nil`.
  /// - returns: An instance of `AnyRange` whose bound is countable.
  public init(
    uncheckedBounds:(lower:AnyRange.BoundRepresentation?, upper:AnyRange.BoundRepresentation?)
  ) {
    if let lower = uncheckedBounds.lower,
      let upper = uncheckedBounds.upper,
      !lower.isIncluded, !upper.isIncluded
    {
      self.init(OpenRange<Bound>(uncheckedBounds:(lower:lower.bound, upper:upper.bound)))
    } else {
      self.init(_uncheckedBounds:uncheckedBounds)
    }
  }
}
extension AnyRange {
  /// - parameter uncheckedBounds: A tuple of the lower and upper bounds of the range.
  ///                              Initialized as a partial range if one of bounds is `nil`.
  ///                              Initialized as a unbounded range if both bounds are `nil`.
  public init(
    uncheckedBounds:(lower:AnyRange.BoundRepresentation?, upper:AnyRange.BoundRepresentation?)
  ) {
    self.init(_uncheckedBounds:uncheckedBounds)
  }
}

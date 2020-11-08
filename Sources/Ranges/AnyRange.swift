/***************************************************************************************************
 AnyRange.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

/// # AnyRange<Bound>
///
/// A type-erased range of `Bound`.
public struct AnyRange<Bound> where Bound:Comparable {
  private var _anyBounds: _AnyBounds? = nil
  private init(_anyBounds: _AnyBounds?) {
    self._anyBounds = _anyBounds
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Creates a *countable* range.
  /// Pass `nil` if you want to create a instance that represents an empty range.
  public init(uncheckedBounds: Bounds<Bound>?) {
    self.init(_anyBounds: uncheckedBounds.flatMap(_AnyBounds.init(countableBounds:)))
  }
}

extension AnyRange {
  /// Creates a range.
  /// Pass `nil` if you want to create a instance that represents an empty range.
  public init(uncheckedBounds: Bounds<Bound>?) {
    self.init(_anyBounds: uncheckedBounds.flatMap(_AnyBounds.init(uncountableBounds:)))
  }
}

extension AnyRange {
  /// Creates a *countable* range from `range`.
  public init<T>(_ range:T)
    where T:GeneralizedRange, T.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    if case let any as AnyRange<Bound> = range {
      // `_bounds` must have been already checked if it is an instance of `AnyRange`.
      self.init(_anyBounds: any._anyBounds)
    } else {
      self.init(uncheckedBounds:range.bounds)
    }
  }
  
  /// Creates a range form `range`.
  public init<T>(_ range:T) where T:GeneralizedRange, T.Bound == Bound {
    if case let any as AnyRange<Bound> = range {
      // `bounds` must have been already checked if it is an instance of `AnyRange`.
      self.init(_anyBounds: any._anyBounds)
    } else {
      self.init(uncheckedBounds:range.bounds)
    }
  }
}

extension AnyRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Creates a *countable* range that contains only the indicated value.
  public init(singleValue: Bound) {
    self.init(singleValue...singleValue)
  }
}
extension AnyRange {
  /// Creates a range that contains only the indicated value.
  public init(singleValue: Bound) {
    self.init(singleValue...singleValue)
  }
}

extension AnyRange where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Creates a *countable* unbounded range.
  public init(_: UnboundedRange) {
    self.init(uncheckedBounds: (lower: .unbounded, upper: .unbounded))
  }
}
extension AnyRange {
  /// Creates an empty range.
  public init() {
    self.init(_anyBounds: nil)
  }
  
  /// Creates an unbounded range.
  public init(_: UnboundedRange) {
    self.init(uncheckedBounds: (lower: .unbounded, upper: .unbounded))
  }
  
  /// An instance of `AnyRange` representing an empty range.
  public static var empty: AnyRange<Bound> { return AnyRange<Bound>() }
  
  /// An instance of `AnyRange` representing an unbounded range.
  public static var unbounded: AnyRange<Bound> { return AnyRange<Bound>(...) }
}

extension AnyRange: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return self._anyBounds?.bounds(type: Bound.self)
  }
  
  public func contains(_ element: Bound) -> Bool {
    return self._anyBounds?.contains(element) ?? false
  }
}

extension AnyRange {
  public var isEmpty: Bool {
    return self._anyBounds == nil
  }
  
  public var isUnbounded: Bool {
    let bounds = self.bounds
    return bounds?.lower == .unbounded && bounds?.upper == .unbounded
  }
}

extension AnyRange: Equatable {
  public static func ==(lhs:AnyRange, rhs:AnyRange) -> Bool {
    return lhs.compare(rhs) == .orderedSame
  }
}

extension AnyRange: Hashable, HashableRange where Bound: Hashable {}

extension AnyRange: CustomStringConvertible, CustomStringConvertibleRange where Bound: CustomStringConvertible {}

extension AnyRange {
  /// Returns a new range that is an intersection of `self` and `other`.
  public func intersection(_ other: AnyRange<Bound>) -> AnyRange<Bound> {
    guard let myBounds = self._anyBounds, let otherBounds = other._anyBounds else { return .empty }
    return AnyRange(_anyBounds: myBounds.intersection(otherBounds))
  }
  
  /// Returns whether the intersection of `self` and `other` is empty or not.
  public func overlaps(_ other: AnyRange<Bound>) -> Bool {
    return !self.intersection(other).isEmpty
  }
  
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  public func subtracting(_ other: AnyRange<Bound>) -> (AnyRange<Bound>, AnyRange<Bound>?) {
    guard let myBounds = self._anyBounds else { return (.empty, nil) }
    guard let otherBounds = other._anyBounds else { return (self, nil) }
    
    switch myBounds.subtracting(otherBounds) {
    case (let nilableBounds, nil):
      return (AnyRange(_anyBounds: nilableBounds), nil)
    case (let bounds1?, let bounds2?):
      return (AnyRange(_anyBounds: bounds1), AnyRange(_anyBounds: bounds2))
    default:
      fatalError("\(#function): Unexpected result.")
    }
  }
  
  /// Concatenate two ranges if possible.
  /// Returns `nil` if the two ranges are apart.
  public func concatenating(_ other: AnyRange<Bound>) -> AnyRange<Bound>? {
    guard let myBounds = self._anyBounds else { return other }
    guard let otherBounds = other._anyBounds else { return self }
    return myBounds.concatenating(otherBounds).flatMap(AnyRange<Bound>.init)
  }
}

extension AnyRange {
  internal func _isLessThanAndApartFrom(_ other: AnyRange) -> Bool {
    return self < other && !self.overlaps(other)
  }
  
  internal func _isGreaterThanAndApartFrom(_ other: AnyRange) -> Bool {
    return other._isLessThanAndApartFrom(self)
  }
}

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
  private var _bounds: _AnyBounds? = nil
  private init(_bounds: _AnyBounds?) {
    self._bounds = _bounds
  }
  
  private init(uncheckedBounds: Bounds<Bound>?, initializer: (Bounds<Bound>) -> _AnyBounds?) {
    guard let bounds = uncheckedBounds else { self.init(_bounds: nil); return }
    if bounds.lower == .unbounded && bounds.upper == .unbounded {
      self.init(_bounds: _AnyBounds._UnboundedBounds())
    } else {
      self.init(_bounds: initializer(bounds))
    }
  }
}

extension AnyRange where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Creates a *countable* range.
  /// Pass `nil` if you want to create a instance that represents an empty range.
  public init(uncheckedBounds: Bounds<Bound>?) {
    self.init(uncheckedBounds: uncheckedBounds, initializer: _AnyBounds._CountableBounds.init)
  }
}

extension AnyRange {
  /// Creates a range.
  /// Pass `nil` if you want to create a instance that represents an empty range.
  public init(uncheckedBounds: Bounds<Bound>?) {
    self.init(uncheckedBounds: uncheckedBounds, initializer: _AnyBounds._UncountableBounds.init)
  }
}

extension AnyRange {
  /// Creates a *countable* range from `range`.
  public init<T>(_ range:T)
    where T:GeneralizedRange, T.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    if case let any as AnyRange<Bound> = range {
      // `_bounds` must have been already checked if it is an instance of `AnyRange`.
      self.init(_bounds: any._bounds)
    } else {
      self.init(uncheckedBounds:range.bounds)
    }
  }
  
  /// Creates a range form `range`.
  public init<T>(_ range:T) where T:GeneralizedRange, T.Bound == Bound {
    if case let any as AnyRange<Bound> = range {
      // `bounds` must have been already checked if it is an instance of `AnyRange`.
      self.init(_bounds: any._bounds)
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

extension AnyRange {
  /// Creates an empty range.
  public init() {
    self.init(_bounds: nil)
  }
  
  /// Creates an unbounded range.
  public init(_:UnboundedRange) {
    self.init(_bounds: _AnyBounds._UnboundedBounds())
  }
  
  /// An instance of `AnyRange` representing an empty range.
  public static var empty: AnyRange<Bound> { return AnyRange<Bound>() }
  
  /// An instance of `AnyRange` representing an unbounded range.
  public static var unbounded: AnyRange<Bound> { return AnyRange<Bound>(...) }
}

extension AnyRange: GeneralizedRange {
  public var bounds: Bounds<Bound>? {
    return self._bounds?.bounds(type: Bound.self)
  }
}

extension AnyRange {
  public var isEmpty: Bool { return self._bounds == nil }
  public var isUnbounded: Bool {
    return self._bounds is _AnyBounds._UnboundedBounds
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
    guard let myBounds = self._bounds, let otherBounds = other._bounds else { return .empty }
    return AnyRange(_bounds: myBounds.intersection(otherBounds))
  }
}

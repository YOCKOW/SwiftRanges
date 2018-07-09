/***************************************************************************************************
 AnyRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

/// # AnyRange
/// A container for ranges.
public struct AnyRange<Bound> where Bound: Comparable {
  internal enum _Range {
    case empty
    case unboundedRange
    case closedRange(ClosedRange<Bound>)
    case leftOpenRange(LeftOpenRange<Bound>)
    case openRange(OpenRange<Bound>)
    case range(Range<Bound>)
    case partialRangeFrom(PartialRangeFrom<Bound>)
    case partialRangeGreaterThan(PartialRangeGreaterThan<Bound>)
    case partialRangeThrough(PartialRangeThrough<Bound>)
    case partialRangeUpTo(PartialRangeUpTo<Bound>)
  }
  
  internal var _range: _Range = .empty
}

/// A container for countable ranges.
public typealias AnyCountableRange<Bound> =
  AnyRange<Bound> where Bound:Strideable, Bound.Stride:SignedInteger

extension AnyRange {
  fileprivate mutating func _init<R>(_ range:R) where R:RangeExpression, R.Bound == Bound {
    switch range {
    case let closed as ClosedRange<Bound>:
      self._range = closed.isEmpty ? .empty : .closedRange(closed)
    case let leftOpen as LeftOpenRange<Bound>:
      self._range = leftOpen.isEmpty ? .empty : .leftOpenRange(leftOpen)
    case let open as OpenRange<Bound>:
        self._range = open.isEmpty ? .empty : .openRange(open)
    case let range as Range<Bound>:
      self._range = range.isEmpty ? .empty : .range(range)
    case let from as PartialRangeFrom<Bound>:
      self._range = .partialRangeFrom(from)
    case let greater as PartialRangeGreaterThan<Bound>:
      self._range = .partialRangeGreaterThan(greater)
    case let through as PartialRangeThrough<Bound>:
      self._range = .partialRangeThrough(through)
    case let upTo as PartialRangeUpTo<Bound>:
      self._range = .partialRangeUpTo(upTo)
    default:
      fatalError("Unimplemented Range")
    }
  }
}

extension AnyRange {
  /// Initialize with an existing range.
  /// `range` must be "countable".
  public init<R>(_ range:R)
    where R:RangeExpression, R.Bound == Bound, Bound:Strideable, Bound.Stride: SignedInteger {
    
    // Emptiness of `OpenRange` depends on its countability.
    if case let open as OpenRange<Bound> = range {
      self._range = open.isEmpty ? .empty : .openRange(open)
    } else {
      self._init(range)
    }
  }
  
  /// Initialize with an existing range.
  public init<R>(_ range:R) where R:RangeExpression, R.Bound == Bound {
    self._init(range)
  }
  
  /// Initialize with an unbounded range.
  public init(_:UnboundedRange) {
    self._range = .unboundedRange
  }
}

extension AnyRange {
  private init(
    _uncheckedBounds:(lower:Bound?, upper:Bound?),
    including:(lowerBound:Bool, upperBound:Bool)
  ) {
    switch _uncheckedBounds {
    case (nil, nil):
      self.init(...)
    case (let lower?, let upper?):
      let bounds: (lower:Bound, upper:Bound) = (lower:lower, upper:upper)
      switch including {
      case (true, true):
        self.init(ClosedRange<Bound>(uncheckedBounds:bounds))
      case (true, false):
        self.init(Range<Bound>(uncheckedBounds:bounds))
      case (false, true):
        self.init(LeftOpenRange<Bound>(uncheckedBounds:bounds))
      case (false, false):
        self.init(OpenRange<Bound>(uncheckedBounds:bounds))
      }
    case (let lower?, nil):
      if including.lowerBound {
        self.init(PartialRangeFrom<Bound>(lower))
      } else {
        self.init(PartialRangeGreaterThan<Bound>(lower))
      }
    case (nil, let upper?):
      if including.upperBound {
        self.init(PartialRangeThrough<Bound>(upper))
      } else {
        self.init(PartialRangeUpTo<Bound>(upper))
      }
    }
  }
}
extension AnyRange where Bound:Strideable, Bound.Stride: SignedInteger {
  /// - parameter uncheckedBounds: A tuple of the lower and upper bounds of the range.
  ///                              Initialized as a partial range if one of bounds is `nil`.
  ///                              Initialized as a unbounded range if both bounds are `nil`.
  /// - parameter including: Specify whether the bound is included or not.
  /// - returns: an instance of `AnyRange<Bound>`(`AnyCountableRange<Bound>`).
  public init(
    uncheckedBounds:(lower:Bound?, upper:Bound?),
    including:(lowerBound:Bool, upperBound:Bool)
  ) {
    if let lower = uncheckedBounds.lower, let upper = uncheckedBounds.upper,
       !including.lowerBound, !including.upperBound {
      self.init(OpenRange<Bound>(uncheckedBounds:(lower:lower, upper:upper)))
    } else {
      self.init(_uncheckedBounds:uncheckedBounds, including:including)
    }
  }
}
extension AnyRange {
  /// - parameter uncheckedBounds: A tuple of the lower and upper bounds of the range.
  ///                              Initialized as a partial range if one of bounds is `nil`.
  ///                              Initialized as a unbounded range if both bounds are `nil`.
  /// - parameter including: Specify whether the bound is included or not.
  /// - returns: an instance of `AnyRange<Bound>`.
  public init(
    uncheckedBounds:(lower:Bound?, upper:Bound?),
    including:(lowerBound:Bool, upperBound:Bool)
  ) {
    self.init(_uncheckedBounds:uncheckedBounds, including:including)
  }
}

extension AnyRange {
  /// Initialize an instance with a single value.
  /// - parameter singleValue: The only value to be contained by the range.
  /// - returns: A range that is equal to `AnyRange<Bound>(singleValue...singleValue)`
  public init(singleValue:Bound) {
    self.init(singleValue...singleValue)
  }
}

extension AnyRange {
  /// Returns whether the receiver represents an empty range or not.
  public var isEmpty: Bool {
    if case .empty = self._range { return true }
    return false
  }
}

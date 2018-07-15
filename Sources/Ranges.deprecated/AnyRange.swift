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
    case let any as AnyRange<Bound>:
      self._range = any._range
      
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
  /// Initialize an instance with a single value.
  /// - parameter singleValue: The only value to be contained by the range.
  /// - returns: A range that is equal to `AnyRange<Bound>(singleValue...singleValue)`
  public init(singleValue:Bound) {
    self.init(singleValue...singleValue)
  }
}

extension AnyRange {
  /// An instance of `AnyRange` representing an empty range.
  public static var empty: AnyRange<Bound> { return AnyRange<Bound>() }
  
  /// An instance of `AnyRange` representing an unbounded range.
  public static var unbounded: AnyRange<Bound> { return AnyRange<Bound>(...) }
}

extension AnyRange {
  /// Returns whether the receiver represents an empty range or not.
  public var isEmpty: Bool {
    if case .empty = self._range { return true }
    return false
  }
  
  /// Returns whether the receiver represents an unbounded range or not.
  public var isUnboundedRange: Bool {
    if case .unboundedRange = self._range { return true }
    return false
  }
}

extension AnyRange: RangeExpression {
  public func relative<C>(to collection:C) -> Range<Bound> where C:Collection, Bound == C.Index {
    switch self._range {
    case .empty:
      return collection.startIndex..<collection.startIndex
    case .unboundedRange:
      return collection.startIndex..<collection.endIndex
      
    case .closedRange(let range):
      return range.relative(to:collection)
    case .leftOpenRange(let range):
      return range.relative(to:collection)
    case .openRange(let range):
      return range.relative(to:collection)
    case .range(let range):
      return range.relative(to:collection)
      
    case .partialRangeFrom(let range):
      return range.relative(to:collection)
    case .partialRangeGreaterThan(let range):
      return range.relative(to:collection)
    case .partialRangeThrough(let range):
      return range.relative(to:collection)
    case .partialRangeUpTo(let range):
      return range.relative(to:collection)
    }
  }
  
  public func contains(_ element: Bound) -> Bool {
    switch self._range {
    case .empty:
      return false
    case .unboundedRange:
      return true
      
    case .closedRange(let range):
      return range.contains(element)
    case .leftOpenRange(let range):
      return range.contains(element)
    case .openRange(let range):
      return range.contains(element)
    case .range(let range):
      return range.contains(element)
      
    case .partialRangeFrom(let range):
      return range.contains(element)
    case .partialRangeGreaterThan(let range):
      return range.contains(element)
    case .partialRangeThrough(let range):
      return range.contains(element)
    case .partialRangeUpTo(let range):
      return range.contains(element)
    }
  }
  
}

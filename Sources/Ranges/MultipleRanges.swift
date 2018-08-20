/***************************************************************************************************
 MultipleRanges.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
/// # MultipleRanges
///
/// Represents multiple ranges.
public struct MultipleRanges<Bound> where Bound:Comparable {
  private var _ranges: [AnyRange<Bound>] = []
}

public typealias MultipleCountableRanges<Bound> =
  MultipleRanges<Bound> where Bound:Strideable, Bound.Stride:SignedInteger

extension MultipleRanges {
  public var isEmpty:Bool { return self._ranges.isEmpty }
}

extension MultipleRanges {
  /// sort, and concatenate ranges if possible.
  private mutating func _normalize() {
    // First, sort them.
    let ranges = self._ranges.sorted(by:<)
    
    self._ranges.removeAll(keepingCapacity:true)
    
    appendRanges: for range in ranges {
      // if `range` is empty, the rest ranges are also empty because `ranges` are sorted.
      if range.isEmpty { break appendRanges }
      
      if self._ranges.isEmpty {
        self._ranges.append(range)
      } else {
        let last = self._ranges.last!
        if let concatenated = last.concatenating(range) {
          // When last range can be concatenated with the range...
          self._ranges.removeLast()
          self._ranges.append(concatenated)
          
          // No more elements are necessary
          // if `concatenated` is unbounded or `PartialRange(From|GreaterThan)`
          // because `ranges` has been already sorted.
          if let bounds = concatenated.bounds, bounds.upper == nil {
            break appendRanges
          }
        } else {
          // Simply append it.
          self._ranges.append(range)
        }
      }
    }
  }
  
  public var ranges: [AnyRange<Bound>] {
    get {
      return self._ranges
    }
    set {
      self._ranges = newValue
      self._normalize() // Always normalized.
    }
  }
}

// Array Literal
extension MultipleRanges: ExpressibleByArrayLiteral {
  public typealias ArrayLiteralElement = AnyRange<Bound>
  public init(arrayLiteral elements: AnyRange<Bound>...) {
    self.init()
    self.ranges = elements // normalized
  }
}

// Equatable
extension MultipleRanges: Equatable {
  public static func ==(lhs:MultipleRanges<Bound>, rhs:MultipleRanges<Bound>) -> Bool {
    return lhs.ranges == rhs.ranges
  }
}

// INSERT
extension MultipleRanges {
  private mutating func _insert<R>(_ newRange:R) where R:GeneralizedRange, R.Bound == Bound {
    let anyRange = AnyRange<Bound>(newRange)
    if anyRange.isEmpty { return }
    self.ranges.append(anyRange) // normalized
  }
  
  /// Inserts the given *countable* range.
  /// The range may be concatenated with other ranges included the receiver.
  public mutating func insert<R>(_ newRange:R)
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    if let bounds = newRange.bounds, let lower = bounds.lower, let upper = bounds.upper,
      !lower.isIncluded, !upper.isIncluded
    {
      // OpenRange
      self._insert(AnyRange<Bound>(uncheckedBounds:bounds))
    } else {
      self._insert(newRange)
    }
  }
  
  /// Inserts the given range.
  /// The range may be concatenated with other ranges included the receiver.
  public mutating func insert<R>(_ newRange:R) where R:GeneralizedRange, R.Bound == Bound {
    self._insert(newRange)
  }
  
  /// Inserts an empty range.
  public mutating func insert(_:()) {
    // do nothing
  }
  
  /// Inserts an unbounded range.
  public mutating func insert(_:UnboundedRange) {
    self._ranges = [AnyRange<Bound>(...)]
  }
  
  /// Inserts a single value
  public mutating func insert(singleValue value:Bound) {
    self._insert(value...value)
  }
}

// CONTAINS
extension MultipleRanges {
  /// Returns a Boolean value that indicates
  /// whether one of ranges in the receiver contains the value or not.
  public func contains(_ value:Bound) -> Bool {
    for range in self.ranges {
      if range.contains(value) { return true }
    }
    return false
  }
}

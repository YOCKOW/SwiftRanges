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
  /// sort, and concatenate ranges if possible.
  private mutating func _normalize() {
    // First, sort them.
    let ranges = self._ranges.sorted(by:<)
    
    self._ranges.removeAll(keepingCapacity:true)
    
    appendRanges: for range in ranges {
      if self._ranges.isEmpty {
        self._ranges.append(range)
      } else {
        let last = self._ranges.last!
        if let concatenated = last.concatenated(with:range) {
          // When last range can be concatenated with the range...
          self._ranges.removeLast()
          self._ranges.append(concatenated)
          
          // No more elements are necessary
          // if `concatenated` is `.unboundedRange` or `.partialRange(From|GreaterThan)`
          // because `ranges` has been already sorted.
          switch concatenated._range {
          case .unboundedRange, .partialRangeFrom, .partialRangeGreaterThan: break appendRanges
          default: break
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
  private mutating func _insert<R>(_ newRange:R) where R:RangeExpression, R.Bound == Bound {
    let anyRange = AnyRange<Bound>(newRange)
    if anyRange.isEmpty { return }
    
    self.ranges.append(anyRange) // normalized
  }
}
extension MultipleRanges {
  /// Inserts the given *countable* range.
  /// The range will be concatenated with other range included the receiver.
  public mutating func insert<R>(_ newRange:R)
    where R:RangeExpression, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    if let range = newRange as? OpenRange<Bound>, !range.isEmpty {
      self._insert(AnyRange<Bound>(range))
    } else {
      self._insert(newRange)
    }
  }
  
  /// Inserts the given range.
  /// The range will be concatenated with other range included the receiver.
  public mutating func insert<R>(_ newRange:R) where R:RangeExpression, R.Bound == Bound {
    self._insert(newRange)
  }
  
  /// Inserts unbounded range.
  public mutating func insert(_:UnboundedRange) {
    self._ranges = [AnyRange<Bound>(...)]
  }
  
  /// Inserts a single value
  public mutating func insert(singleValue value:Bound) {
    self._insert(value...value)
  }
}

extension MultipleRanges {
  private mutating func _init(_ ranges:[Any]) {
    for rr in ranges {
      switch rr {
      case let range as AnyRange<Bound>:
        self.insert(range)
      case let range as ClosedRange<Bound>:
        self.insert(range)
      case let range as LeftOpenRange<Bound>:
        self.insert(range)
      case let range as OpenRange<Bound>:
        self.insert(range)
      case let range as Range<Bound>:
        self.insert(range)
      case let range as PartialRangeFrom<Bound>:
        self.insert(range)
      case let range as PartialRangeGreaterThan<Bound>:
        self.insert(range)
      case let range as PartialRangeThrough<Bound>:
        self.insert(range)
      case let range as PartialRangeUpTo<Bound>:
        self.insert(range)
      default:
        fatalError("Unknown range or not a kind of range.")
      }
    }
  }
}
extension MultipleRanges where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Initialize an instance with *countable* `ranges`.
  /// Although the type of `ranges` is `Any...` due to the limitations of Swift,
  /// `ranges` must consist of instances that are a kind of range
  public init(_ ranges:Any...) {
    self.init()
    var newRanges:[Any] = []
    for range in ranges {
      switch range {
      case let range as OpenRange<Bound>:
        if range.isEmpty { continue }
      default:
        break
      }
      newRanges.append(range)
    }
    self._init(newRanges)
  }
}
extension MultipleRanges {
  /// Initialize an instance with `ranges`.
  /// Although the type of `ranges` is `Any...` due to the limitations of Swift,
  /// `ranges` must consist of instances that are a kind of range
  public init(_ ranges:Any...) {
    self.init()
    self._init(ranges)
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


// SUBTRACT
extension MultipleRanges where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Subtract `anotherRange` from each range in the receiver.
  /// They will be handled as countable ranges.
  public mutating func subtract(_ anotherRange:AnyRange<Bound>) {
    var subtractedRanges: [AnyRange<Bound>] = []
    
    var skipJudgment = false
    for range in self.ranges {
      if skipJudgment {
        subtractedRanges.append(range)
        continue
      }
      
      if let lower = range.bounds?.lower, let anotherUpper = anotherRange.bounds?.upper {
        if anotherUpper._compare(lower, as:.upper) == .orderedAscending {
          // there are no more ranges to be subtracted
          // because `self.ranges` is always sorted
          skipJudgment = true
          subtractedRanges.append(range)
          continue
        }
      }
      
      let sr = range.subtracting(anotherRange)
      subtractedRanges.append(sr.0)
      if let another = sr.1 { subtractedRanges.append(another) }
    }
    
    self.ranges = subtractedRanges
  }
  
  /// Returns an instance with the ranges subtracting `anotherRange` from
  /// each range in the receiver.
  /// They will be handled as countable ranges.
  public func subtracting(_ anotherRange:AnyRange<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.subtract(anotherRange)
    return newRanges
  }
  
  /// Subtract the ranges in `other` from each range in the receiver.
  /// They will be handled as countable ranges.
  public mutating func subtract(_ other:MultipleRanges<Bound>) {
    for range in other.ranges {
      self.subtract(range)
    }
  }
  
  /// Returns an instance with the ranges subtracting each range in `other` from
  /// each range in the receiver.
  /// They will be handled as countable ranges.
  public func subtracting(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.subtract(other)
    return newRanges
  }
}
extension MultipleRanges {
  /// Subtract `anotherRange` from each ranges in the receiver.
  public mutating func subtract(_ anotherRange:AnyRange<Bound>) {
    var subtractedRanges: [AnyRange<Bound>] = []
    
    var skipJudgment = false
    for range in self.ranges {
      if skipJudgment {
        subtractedRanges.append(range)
        continue
      }
      
      if let lower = range.bounds?.lower, let anotherUpper = anotherRange.bounds?.upper {
        if anotherUpper._compare(lower, as:.upper) == .orderedAscending {
          // there are no more ranges to be subtracted
          // because `self.ranges` is always sorted
          skipJudgment = true
          subtractedRanges.append(range)
          continue
        }
      }
      
      let sr = range.subtracting(anotherRange)
      subtractedRanges.append(sr.0)
      if let another = sr.1 { subtractedRanges.append(another) }
    }
    
    self.ranges = subtractedRanges
  }
  
  /// Returns an instance with the ranges subtracting `anotherRange` from
  /// each range in the receiver.
  public func subtracting(_ anotherRange:AnyRange<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.subtract(anotherRange)
    return newRanges
  }
  
  /// Subtract the ranges in `other` from each range in the receiver.
  public mutating func subtract(_ other:MultipleRanges<Bound>) {
    for range in other.ranges {
      self.subtract(range)
    }
  }
  
  /// Returns an instance with the ranges subtracting each range in `other` from
  /// each range in the receiver.
  public func subtracting(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.subtract(other)
    return newRanges
  }
}


// UNION
extension MultipleRanges {
  /// Adds the ranges in the given instance.
  /// Ranges will be concatenated if possible.
  public mutating func formUnion(_ other:MultipleRanges<Bound>) {
    self.ranges.append(contentsOf:other.ranges)
  }
  
  /// Returns a new instance with the ranges of both this and the given instance.
  /// Ranges will be concatenated if possible.
  public func union(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formUnion(other)
    return newRanges
  }
}

// INTERSECTION
extension MultipleRanges where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Update the ranges to be the intersection of each ranges
  /// in the receiver and the given instance.
  /// They are handled as countable ranges.
  public mutating func formIntersection(_ other:MultipleRanges<Bound>) {
    var intersections: [AnyRange<Bound>] = []
    for myRange in self.ranges {
      for otherRange in other.ranges {
        intersections.append(myRange.intersection(otherRange))
      }
    }
    self.ranges = intersections
  }
  
  /// Returns a new instance with the ranges that are the intersection of each ranges
  /// in the receiver and the given instance.
  /// They are handled as countable ranges.
  public func intersection(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formIntersection(other)
    return newRanges
  }
}
extension MultipleRanges {
  /// Update the ranges to be the intersection of each ranges
  /// in the receiver and the given instance.
  public mutating func formIntersection(_ other:MultipleRanges<Bound>) {
    var intersections: [AnyRange<Bound>] = []
    for myRange in self.ranges {
      for otherRange in other.ranges {
        intersections.append(myRange.intersection(otherRange))
      }
    }
    self.ranges = intersections
  }
  
  /// Returns a new instance with the ranges that are the intersection of each ranges
  /// in the receiver and the given instance.
  public func intersection(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formIntersection(other)
    return newRanges
  }
}


// SYMMETRIC DIFFERENCE
// symmetric diferrence == union - intersection
extension MultipleRanges where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Same as formUnion but not including intersection.
  public mutating func formSymmetricDifference(_ other:MultipleRanges<Bound>) {
    let intersection = self.intersection(other)
    self.formUnion(other)
    self.subtract(intersection)
  }
  
  /// Same as `self.union(other).subtracting(self.intersection(other))`.
  public func symmetricDifference(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formSymmetricDifference(other)
    return newRanges
  }
}
extension MultipleRanges {
  /// Same as formUnion but not including intersection.
  public mutating func formSymmetricDifference(_ other:MultipleRanges<Bound>) {
    let intersection = self.intersection(other)
    self.formUnion(other)
    self.subtract(intersection)
  }
  
  /// Same as `self.union(other).subtracting(self.intersection(other))`.
  public func symmetricDifference(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.formSymmetricDifference(other)
    return newRanges
  }
}

/***************************************************************************************************
 MultipleRanges+Subtraction.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

/// returns the last index + 1 to be subtracted
private func _endIndex<R, Bound>(_ ranges:[AnyRange<Bound>],
                                 _ subtrahend:R) -> Int
  where R:GeneralizedRange, R.Bound == Bound
{
  for ii in 0..<ranges.count {
    let range = ranges[ii]
    if let lower = range.bounds?.lower, let anotherUpper = subtrahend.bounds?.upper {
      if anotherUpper._compare(lower, as:.upper) == .orderedAscending {
        // there are no more ranges to be subtracted,
        // because `self.ranges` is always sorted.
        return ii
      }
    }
  }
  return ranges.endIndex
}

private func _splitted<R, Bound>(_ ranges:[AnyRange<Bound>],
                                 _ subtrahend:R) -> (needToBeSubtracted:ArraySlice<AnyRange<Bound>>,
                                                   noNeedToBeSubtracted:ArraySlice<AnyRange<Bound>>)
  where R:GeneralizedRange, R.Bound == Bound
{
  let index = _endIndex(ranges, subtrahend)
  return (ranges[0..<index], ranges[index..<ranges.endIndex])
}

/// (countable)
private func _subtracted<R, Bound>(_ ranges:ArraySlice<AnyRange<Bound>>,
                                   _ subtrahend:R) -> [AnyRange<Bound>]
  where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
{
  var result: [AnyRange<Bound>] = []
  for range in ranges {
    let subtracted = range.subtracting(subtrahend)
    result.append(subtracted.0)
    if let another = subtracted.1 { result.append(another) }
  }
  return result
}

/// (uncountable)
private func _subtracted<R, Bound>(_ ranges:ArraySlice<AnyRange<Bound>>,
                                   _ subtrahend:R) -> [AnyRange<Bound>]
  where R:GeneralizedRange, R.Bound == Bound
{
  var result: [AnyRange<Bound>] = []
  for range in ranges {
    let subtracted = range.subtracting(subtrahend)
    result.append(subtracted.0)
    if let another = subtracted.1 { result.append(another) }
  }
  return result
}

private func _concat<Bound>(_ r0:[AnyRange<Bound>],
                            _ r1:ArraySlice<AnyRange<Bound>>) -> [AnyRange<Bound>]
where Bound:Comparable
{
  var result: [AnyRange<Bound>] = []
  result.append(contentsOf:r0)
  result.append(contentsOf:r1)
  return result
}

extension MultipleRanges {
  /// Subtract `range` from each range in the receiver.
  /// They will be treated as countable ranges.
  public mutating func subtract<R>(_ range:R)
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    let splitted = _splitted(self.ranges, range)
    let subtracted = _subtracted(splitted.needToBeSubtracted, range)
    self.ranges = _concat(subtracted, splitted.noNeedToBeSubtracted)
  }
  
  /// Subtract `range` from each range in the receiver.
  public mutating func subtract<R>(_ range:R)
    where R:GeneralizedRange, R.Bound == Bound
  {
    let splitted = _splitted(self.ranges, range)
    let subtracted = _subtracted(splitted.needToBeSubtracted, range)
    self.ranges = _concat(subtracted, splitted.noNeedToBeSubtracted)
  }
  
  /// Returns a new instance with the ranges subtracting `range` from each range in the receiver.
  /// They will be treated as countable ranges.
  public func subtracting<R>(_ range:R) -> MultipleRanges<Bound>
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    var newRanges = self
    newRanges.subtract(range)
    return newRanges
  }
  
  /// Returns a new instance with the ranges subtracting `range` from each range in the receiver.
  public func subtracting<R>(_ range:R) -> MultipleRanges<Bound>
    where R:GeneralizedRange, R.Bound == Bound
  {
    var newRanges = self
    newRanges.subtract(range)
    return newRanges
  }
}


extension MultipleRanges where Bound:Strideable, Bound.Stride:SignedInteger {
  /// Subtract the ranges in `other` from each range in the receiver.
  /// They will be treated as countable ranges.
  public mutating func subtract(_ other:MultipleRanges<Bound>) {
    for range in other.ranges {
      self.subtract(range)
    }
  }
  
  /// Returns a new instance with the ranges subtracting each range in `other` from
  /// each range in the receiver.
  /// They will be handled as countable ranges.
  public func subtracting(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.subtract(other)
    return newRanges
  }
  
  /// Subtract the single value.
  public mutating func subtract(singleValue value:Bound) {
    self.subtract(value...value)
  }
  
  /// Returns a new instance with subtracting the single value.
  public func subtracting(singleValue value:Bound) -> MultipleRanges<Bound> {
    return self.subtracting(value...value)
  }
}

extension MultipleRanges {
  /// Subtract the ranges in `other` from each range in the receiver.
  public mutating func subtract(_ other:MultipleRanges<Bound>) {
    for range in other.ranges {
      self.subtract(range)
    }
  }
  
  /// Returns a new instance with the ranges subtracting each range in `other` from
  /// each range in the receiver.
  public func subtracting(_ other:MultipleRanges<Bound>) -> MultipleRanges<Bound> {
    var newRanges = self
    newRanges.subtract(other)
    return newRanges
  }
  
  /// Subtract the single value.
  public mutating func subtract(singleValue value:Bound) {
    self.subtract(value...value)
  }
  
  /// Returns a new instance with subtracting the single value.
  public func subtracting(singleValue value:Bound) -> MultipleRanges<Bound> {
    return self.subtracting(value...value)
  }
}

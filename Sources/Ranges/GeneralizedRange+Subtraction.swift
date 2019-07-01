/***************************************************************************************************
 GeneralizedRange+Subtraction.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

///
/// it *may* be subtractable...
private func _subtractable<Bound>(_ minuend:Bounds<Bound>,
                                  _ subtrahend:Bounds<Bound>) -> Bool
  where Bound:Comparable
{
  if let mLower = minuend.lower.value, let sUpper = subtrahend.upper.value, mLower > sUpper {
    return false
  }
  if let mUpper = minuend.upper.value, let sLower = subtrahend.lower.value, mUpper < sLower {
    return false
  }
  return true
}

private func _subtracting<Bound>(_ minuend:Bounds<Bound>,
                                 _ subtrahend:Bounds<Bound>) -> [Bounds<Bound>]
  where Bound:Comparable
{
  guard _subtractable(minuend, subtrahend) else {
    return [minuend]
  }
  
  var result: [Bounds<Bound>] = []
  
  if subtrahend.lower != .unbounded {
    result.append((lower:minuend.lower, upper:~subtrahend.lower))
  }
  
  if subtrahend.upper != .unbounded {
    result.append((lower:~subtrahend.upper, upper:minuend.upper))
  }
  
  return result
}

private func _subtracting<T,U,Bound>(_ minuend:T,
                                     _ subtrahend:U) -> [Bounds<Bound>]
  where T:GeneralizedRange, U:GeneralizedRange, T.Bound == Bound, U.Bound == Bound
{
  guard let minuendBounds = minuend.bounds else {
    // if minuend is empty, result is also empty
    return []
  }
  guard let subtrahendBounds = subtrahend.bounds else {
    // if subtrahend is empty, result is equal to minuend
    return [minuendBounds]
  }
  return _subtracting(minuendBounds, subtrahendBounds)
}


/// (countable)
private func _convert<Bound>(_ list:[Bounds<Bound>]) -> [AnyRange<Bound>]
  where Bound:Strideable, Bound.Stride:SignedInteger
{
  return list.map { AnyRange<Bound>(uncheckedBounds:$0) }
}

/// (uncountable)
private func _convert<Bound>(_ list:[Bounds<Bound>]) -> [AnyRange<Bound>] where Bound:Comparable
{
  return list.map { AnyRange<Bound>(uncheckedBounds:$0) }
}


private func _arrange<Bound>(_ list:[AnyRange<Bound>]) -> (AnyRange<Bound>, AnyRange<Bound>?)
  where Bound:Comparable
{
  switch list.count {
  case 0:
    return (.empty, nil)
  case 1:
    return (list[0], nil)
  case 2:
    switch (list[0].isEmpty, list[1].isEmpty) {
    case (true, true): return (.empty, nil)
    case (true, false): return (list[1], nil)
    case (false, true): return (list[0], nil)
    case (false, false): return (list[0], list[1])
    }
  default:
    fatalError("Too many ranges.")
  }
}


extension GeneralizedRange {
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  /// They are handled as countable ranges.
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return _arrange(_convert(_subtracting(self, other)))
  }
  
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound
  {
    return _arrange(_convert(_subtracting(self, other)))
  }
}

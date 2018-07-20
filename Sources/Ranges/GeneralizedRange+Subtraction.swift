/***************************************************************************************************
 GeneralizedRange+Subtraction.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

private func _subtracting<Bound>(_ minuend:Bounds<Bound>,
                                 _ subtrahend:Bounds<Bound>) -> [Bounds<Bound>]
  where Bound:Comparable
{
  var result: [Bounds<Bound>] = []
  
  if let sLower = subtrahend.lower {
    result.append((lower:minuend.lower, upper:~sLower))
  }
  
  if let sUpper = subtrahend.upper {
    result.append((lower:~sUpper, upper:minuend.upper))
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
    assertionFailure("list.count >= 3")
    return (.empty, nil)
  }
}


extension GeneralizedRange {
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  /// They are handled as countable ranges.
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    guard self.overlaps(other) else { return (AnyRange<Bound>(self), nil) }
    return _arrange(_convert(_subtracting(self, other)))
  }
  
  /// Returns subtracted range(s).
  /// Under some conditions, `other` divides the range. That is why a tuple is returned.
  public func subtracting<R>(_ other:R) -> (AnyRange<Bound>, AnyRange<Bound>?)
    where R:GeneralizedRange, R.Bound == Bound
  {
    guard self.overlaps(other) else { return (AnyRange<Bound>(self), nil) }
    return _arrange(_convert(_subtracting(self, other)))
  }
}

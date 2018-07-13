/***************************************************************************************************
 MultipleRanges+OrdinaryRanges.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension MultipleRanges {
  /// Shortcut for `subtract(_:AnyRange<Bound>)`
  public mutating func subtract<R>(_ range:R)
    where R:RangeExpression, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    self.subtract(AnyRange<Bound>(range))
  }
  
  /// Shortcut for `subtract(_:AnyRange<Bound>)`
  public mutating func subtract<R>(_ range:R) where R:RangeExpression, R.Bound == Bound {
    self.subtract(AnyRange<Bound>(range))
  }
  
  /// Shortcut for `subtracting(_:AnyRange<Bound>)`
  public func subtracting<R>(_ range:R) -> MultipleRanges<Bound>
    where R:RangeExpression, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return self.subtracting(AnyRange<Bound>(range))
  }
  
  /// Shortcut for `subtracting(_:AnyRange<Bound>)`
  public func subtract<R>(_ range:R) -> MultipleRanges<Bound>
    where R:RangeExpression, R.Bound == Bound
  {
    return self.subtracting(AnyRange<Bound>(range))
  }
}

extension MultipleRanges {
  /// Shortcut for `formUnion(_:MultipleRanges<Bound>)`
  public mutating func formUnion<R>(_ range:R) where R:RangeExpression, R.Bound == Bound {
    self.formUnion(MultipleRanges<Bound>(range))
  }
  
  /// Shortcut for `union(_:MultipleRanges<Bound>)`
  public mutating func union<R>(_ range:R) -> MultipleRanges<Bound>
    where R:RangeExpression, R.Bound == Bound
  {
    return self.union(MultipleRanges<Bound>(range))
  }
}


extension MultipleRanges {
  /// Shortcut for `formIntersection(_:MultipleRanges<Bound>)`
  public mutating func formIntersection<R>(_ range:R)
    where R:RangeExpression, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    self.formIntersection(MultipleRanges<Bound>(range))
  }
  
  /// Shortcut for `formIntersection(_:MultipleRanges<Bound>)`
  public mutating func formIntersection<R>(_ range:R) where R:RangeExpression, R.Bound == Bound {
    self.formIntersection(MultipleRanges<Bound>(range))
  }
  
  /// Shortcut for `intersection(_:MultipleRanges<Bound>)`
  public func intersection<R>(_ range:R) -> MultipleRanges<Bound>
    where R:RangeExpression, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return self.intersection(MultipleRanges<Bound>(range))
  }
  
  /// Shortcut for `intersection(_:MultipleRanges<Bound>)`
  public func intersection<R>(_ range:R) -> MultipleRanges<Bound>
    where R:RangeExpression, R.Bound == Bound
  {
    return self.intersection(MultipleRanges<Bound>(range))
  }
}

extension MultipleRanges {
  /// Shortcut for `formSymmetricDifference(_:MultipleRanges<Bound>)`
  public mutating func formSymmetricDifference<R>(_ range:R)
    where R:RangeExpression, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    self.formSymmetricDifference(MultipleRanges<Bound>(range))
  }
  
  /// Shortcut for `formSymmetricDifference(_:MultipleRanges<Bound>)`
  public mutating func formSymmetricDifference<R>(_ range:R) where R:RangeExpression, R.Bound == Bound {
    self.formSymmetricDifference(MultipleRanges<Bound>(range))
  }
  
  /// Shortcut for `symmetricDifference(_:MultipleRanges<Bound>)`
  public func symmetricDifference<R>(_ range:R) -> MultipleRanges<Bound>
    where R:RangeExpression, R.Bound == Bound, Bound:Strideable, Bound.Stride:SignedInteger
  {
    return self.symmetricDifference(MultipleRanges<Bound>(range))
  }
  
  /// Shortcut for `symmetricDifference(_:MultipleRanges<Bound>)`
  public func symmetricDifference<R>(_ range:R) -> MultipleRanges<Bound>
    where R:RangeExpression, R.Bound == Bound
  {
    return self.symmetricDifference(MultipleRanges<Bound>(range))
  }
}

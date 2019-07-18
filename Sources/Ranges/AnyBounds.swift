/* *************************************************************************************************
 AnyBounds.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
private func _mustBeOverridden(_ function: StaticString = #function) -> Never {
  fatalError("\(function) must be overridden.")
}

/// A type erasure for bounds.
/// Exists to determine its "countability" at the time of initialization of `AnyRange`.
internal class _AnyBounds {
  internal func bounds<T>(type: T.Type) -> Bounds<T> { _mustBeOverridden() }
  internal func intersection(_ other: _AnyBounds) -> _AnyBounds? { _mustBeOverridden() }
  internal func subtracting(_ other: _AnyBounds) -> (_AnyBounds?, _AnyBounds?) { _mustBeOverridden() }
  internal func concatenating(_ other: _AnyBounds) -> _AnyBounds? { _mustBeOverridden() }
}

private protocol __AnyBounds {}
extension __AnyBounds {
  fileprivate init?<T>(_uncountableBounds: Bounds<T>) where T: Comparable {
    guard let instance = _AnyBounds._UncountableBounds(_uncountableBounds) else { return nil }
    self = instance as! Self
  }
  fileprivate init?<T>(_countableBounds: Bounds<T>) where T: Strideable, T.Stride: SignedInteger {
    guard let instance = _AnyBounds._CountableBounds(_countableBounds) else { return nil }
    self = instance as! Self
  }
}
extension _AnyBounds: __AnyBounds {
  internal convenience init?<T>(uncountableBounds: Bounds<T>) where T: Comparable {
    self.init(_uncountableBounds: uncountableBounds)
  }
  internal convenience init?<T>(countableBounds: Bounds<T>) where T: Strideable, T.Stride: SignedInteger {
    self.init(_countableBounds: countableBounds)
  }
}

extension _AnyBounds {
  fileprivate class _SomeBounds<Bound>: _AnyBounds where Bound: Comparable{
    private var _bounds: Bounds<Bound>
    fileprivate init?(_ bounds: Bounds<Bound>) {
      guard _validateBounds(bounds) else { return nil }
      self._bounds = bounds
      super.init()
    }
    
    fileprivate override func bounds<T>(type: T.Type) -> Bounds<T> {
      guard case let bounds as Bounds<T> = self._bounds else {
        fatalError("Mismatched types (\(#function)): Expected type == \(Bound.self), Actual Type ==  \(T.self)")
      }
      return bounds
    }
    
    /* *** INTERSECTION *** */
    fileprivate func _intersection(_ other: _AnyBounds) -> Bounds<Bound> {
      let otherBounds = other.bounds(type: Bound.self)
      let lower = _max(self._bounds.lower, otherBounds.lower, side: .lower)
      let upper = _min(self._bounds.upper, otherBounds.upper, side: .upper)
      return (lower: lower, upper: upper)
    }
    
    /* *** SUBTRACTION *** */
    fileprivate func _mayBeSubtractable(by subtrahend: _AnyBounds) -> Bool {
      let myBounds = self.bounds(type: Bound.self)
      let subtrahendBounds  = subtrahend.bounds(type: Bound.self)
      
      if let myLower = myBounds.lower.value, let sUpper = subtrahendBounds.upper.value, myLower > sUpper {
        return false
      }
      if let myUpper = myBounds.upper.value, let sLower = subtrahendBounds.lower.value, myUpper < sLower {
        return false
      }
      return true
    }
    
    fileprivate func _subtracting(_ other: _AnyBounds) -> [_AnyBounds] { _mustBeOverridden() }
    
    fileprivate func _subtracted(from other: _AnyBounds) -> [_AnyBounds] { _mustBeOverridden() }
    
    internal override func subtracting(_ other: _AnyBounds) -> (_AnyBounds?, _AnyBounds?) {
      guard self._mayBeSubtractable(by: other) else { return (self, nil) }
      
      let list = self._subtracting(other)
      switch list.count {
      case 0:
        return (nil, nil)
      case 1:
        return (list[0], nil)
      case 2:
        return (list[0], list[1])
      default:
        fatalError("Too many ranges.")
      }
    }
    
    /* *** CONCATENATION *** */
    fileprivate func _isConcatenatable(with other: _SomeBounds<Bound>) -> Bool { _mustBeOverridden() }
    
    fileprivate func _concatenating(_ other: _SomeBounds<Bound>) -> Bounds<Bound>? {
      guard self._isConcatenatable(with: other) else { return nil }
      
      let myBounds = self.bounds(type: Bound.self)
      let otherBounds = other.bounds(type: Bound.self)
      return (lower: _min(myBounds.lower, otherBounds.lower, side: .lower),
              upper: _max(myBounds.upper, otherBounds.upper, side: .upper))
    }
  }
  
  fileprivate final class _UncountableBounds<Bound>: _SomeBounds<Bound> where Bound: Comparable {
    fileprivate override func intersection(_ other: _AnyBounds) -> _AnyBounds? {
      guard case let otherUncountableBounds as _UncountableBounds<Bound> = other else {
        return other.intersection(self)
      }
      let bounds = self._intersection(otherUncountableBounds)
      return _UncountableBounds(bounds)
    }
    
    fileprivate override func _subtracting(_ other: _AnyBounds) -> [_AnyBounds] {
      if type(of: other) != _UncountableBounds<Bound>.self {
        // `other` is _CountableBounds
        return (other as! _SomeBounds<Bound>)._subtracted(from: self)
      }
      
      var result: [_AnyBounds] = []
      let myBounds = self.bounds(type: Bound.self)
      let otherBounds = other.bounds(type: Bound.self)
      
      if otherBounds.lower != .unbounded {
        if let bounds = _UncountableBounds<Bound>((lower:myBounds.lower, upper:~otherBounds.lower)) {
          result.append(bounds)
        }
      }
      if otherBounds.upper != .unbounded {
        if let bounds = _UncountableBounds<Bound>((lower:~otherBounds.upper, upper:myBounds.upper)) {
          result.append(bounds)
        }
      }
      
      return result
    }
    
    fileprivate override func _isConcatenatable(with other: _SomeBounds<Bound>) -> Bool {
      guard type(of: other) == _UncountableBounds<Bound>.self else {
        return other._isConcatenatable(with: self)
      }
      
      let myBounds = self.bounds(type: Bound.self)
      let otherBounds = other.bounds(type: Bound.self)
      
      return myBounds.upper._isConcatenatable(with: otherBounds.lower) &&
             otherBounds.upper._isConcatenatable(with: myBounds.lower)
    }
    
    fileprivate override func concatenating(_ other: _AnyBounds) -> _AnyBounds? {
      guard case let other as _SomeBounds<Bound> = other else { fatalError("Unexpected type.") }
      guard type(of: other) == _UncountableBounds<Bound>.self else {
        return other.concatenating(self)
      }
      
      return self._concatenating(other).flatMap(_UncountableBounds<Bound>.init)
    }
  }
  
  fileprivate final class _CountableBounds<Bound>: _SomeBounds<Bound> where Bound: Strideable, Bound.Stride: SignedInteger {
    fileprivate override init?(_ bounds: Bounds<Bound>) {
      guard _validateBounds(bounds) else { return nil }
      super.init(bounds)
    }
    
    fileprivate override func intersection(_ other: _AnyBounds) -> _AnyBounds? {
      let bounds = self._intersection(other)
      return _CountableBounds(bounds)
    }
    
    fileprivate override func _subtracting(_ other: _AnyBounds) -> [_AnyBounds] {
      var result: [_AnyBounds] = []
      let myBounds = self.bounds(type: Bound.self)
      let otherBounds = other.bounds(type: Bound.self)
      
      if otherBounds.lower != .unbounded {
        if let bounds = _CountableBounds<Bound>((lower:myBounds.lower, upper:~otherBounds.lower)) {
          result.append(bounds)
        }
      }
      if otherBounds.upper != .unbounded {
        if let bounds = _CountableBounds<Bound>((lower:~otherBounds.upper, upper:myBounds.upper)) {
          result.append(bounds)
        }
      }
      
      return result
    }
    
    fileprivate override func _subtracted(from other: _AnyBounds) -> [_AnyBounds] {
      let minuend = _CountableBounds<Bound>(other.bounds(type: Bound.self))!
      return minuend._subtracting(self)
    }
    
    fileprivate override func _isConcatenatable(with other: _SomeBounds<Bound>) -> Bool {
      let myBounds = self.bounds(type: Bound.self)
      let otherBounds = other.bounds(type: Bound.self)
      
      return myBounds.upper._isConcatenatable(with: otherBounds.lower) &&
             otherBounds.upper._isConcatenatable(with: myBounds.lower)
    }
    
    fileprivate override func concatenating(_ other: _AnyBounds) -> _AnyBounds? {
      guard case let other as _SomeBounds<Bound> = other else { fatalError("Unexpected type.") }
      return self._concatenating(other).flatMap(_CountableBounds<Bound>.init)
    }
  }
}

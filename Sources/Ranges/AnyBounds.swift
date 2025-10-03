/* *************************************************************************************************
 AnyBounds.swift
   © 2019,2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
private func _mustBeOverridden(_ function: StaticString = #function,
                               file: StaticString = #file, line: UInt = #line) -> Never {
  fatalError("\(function) must be overridden.", file: file, line: line)
}

private func _typeMismatch<T, U>(expected: T.Type, actual: U.Type,
                                 function: StaticString = #function,
                                 file: StaticString = #file, line: UInt = #line) -> Never {
  fatalError("Mismatched types (\(function)): Expected type == \(expected), Actual Type ==  \(actual)")
}

/// A type erasure for bounds.
/// Exists to determine its "countability" at the time of initialization of `AnyRange`.
internal class _AnyBounds: @unchecked Sendable {
  internal func bounds<T>(type: T.Type) -> Bounds<T> { _mustBeOverridden() }
  internal func contains<T>(_ element: T) -> Bool where T: Comparable { _mustBeOverridden() }
  internal func intersection(_ other: _AnyBounds) -> _AnyBounds? { _mustBeOverridden() }
  internal func subtracting(_ other: _AnyBounds) -> (_AnyBounds?, _AnyBounds?) { _mustBeOverridden() }
  internal func concatenating(_ other: _AnyBounds) -> _AnyBounds? { _mustBeOverridden() }
}

private protocol __AnyBounds {}
extension __AnyBounds {
  init?<T>(_uncountableBounds: Bounds<T>) where T: Comparable {
    guard let instance = _AnyBounds._UncountableBounds(_uncountableBounds) else { return nil }
    self = instance as! Self
  }
  init?<T>(_countableBounds: Bounds<T>) where T: Strideable, T.Stride: SignedInteger {
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
  fileprivate class _SomeBounds<Bound>: _AnyBounds, @unchecked Sendable where Bound: Comparable{
    private let _bounds: Bounds<Bound>
    private let _containsClosure: (Bound) -> Bool
    
    init?(_ bounds: Bounds<Bound>) {
      guard _validateBounds(bounds) else { return nil }
      self._bounds = bounds
      
      switch bounds {
      case (.included(let lower), .included(let upper)) where lower == upper:
        self._containsClosure = { lower == $0 }
      default:
        self._containsClosure = { _contains(bounds: bounds, element: $0) }
      }
      
      super.init()
    }
    
    override func bounds<T>(type: T.Type) -> Bounds<T> {
      guard case let bounds as Bounds<T> = self._bounds else {
        _typeMismatch(expected: Bound.self, actual: T.self)
      }
      return bounds
    }
    
    override func contains<T>(_ element: T) -> Bool where T: Comparable {
      guard case let element as Bound = element else {
        _typeMismatch(expected: Bound.self, actual: T.self)
      }
      return self._containsClosure(element)
    }
    
    /* *** INTERSECTION *** */
    func _intersection(_ other: _AnyBounds) -> Bounds<Bound> {
      let otherBounds = other.bounds(type: Bound.self)
      let lower = _max(self._bounds.lower, otherBounds.lower, side: .lower)
      let upper = _min(self._bounds.upper, otherBounds.upper, side: .upper)
      return (lower: lower, upper: upper)
    }
    
    /* *** SUBTRACTION *** */
    func _mayBeSubtractable(by subtrahend: _AnyBounds) -> Bool {
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
    
    func _subtracting(_ other: _AnyBounds) -> [_AnyBounds] { _mustBeOverridden() }
    
    func _subtracted(from other: _AnyBounds) -> [_AnyBounds] { _mustBeOverridden() }
    
    override func subtracting(_ other: _AnyBounds) -> (_AnyBounds?, _AnyBounds?) {
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
    func _isConcatenatable(with other: _SomeBounds<Bound>) -> Bool { _mustBeOverridden() }
    
    func _concatenating(_ other: _SomeBounds<Bound>) -> Bounds<Bound>? {
      guard self._isConcatenatable(with: other) else { return nil }
      
      let myBounds = self.bounds(type: Bound.self)
      let otherBounds = other.bounds(type: Bound.self)
      return (lower: _min(myBounds.lower, otherBounds.lower, side: .lower),
              upper: _max(myBounds.upper, otherBounds.upper, side: .upper))
    }
  }
  
  fileprivate final class _UncountableBounds<Bound>: _SomeBounds<Bound>, @unchecked Sendable where Bound: Comparable {
    override func intersection(_ other: _AnyBounds) -> _AnyBounds? {
      guard case let otherUncountableBounds as _UncountableBounds<Bound> = other else {
        return other.intersection(self)
      }
      let bounds = self._intersection(otherUncountableBounds)
      return _UncountableBounds(bounds)
    }
    
    override func _subtracting(_ other: _AnyBounds) -> [_AnyBounds] {
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
    
    override func _isConcatenatable(with other: _SomeBounds<Bound>) -> Bool {
      guard type(of: other) == _UncountableBounds<Bound>.self else {
        return other._isConcatenatable(with: self)
      }
      
      let myBounds = self.bounds(type: Bound.self)
      let otherBounds = other.bounds(type: Bound.self)
      
      return myBounds.upper._isConcatenatable(with: otherBounds.lower) &&
             otherBounds.upper._isConcatenatable(with: myBounds.lower)
    }
    
    override func concatenating(_ other: _AnyBounds) -> _AnyBounds? {
      guard case let other as _SomeBounds<Bound> = other else { fatalError("Unexpected type.") }
      guard type(of: other) == _UncountableBounds<Bound>.self else {
        return other.concatenating(self)
      }
      guard let concatenated = self._concatenating(other) else {
        return nil
      }
      return _UncountableBounds<Bound>(concatenated)
    }
  }
  
  fileprivate final class _CountableBounds<Bound>: _SomeBounds<Bound>, @unchecked Sendable where Bound: Strideable, Bound.Stride: SignedInteger {
    override init?(_ bounds: Bounds<Bound>) {
      guard _validateBounds(bounds) else { return nil }
      super.init(bounds)
    }
    
    override func intersection(_ other: _AnyBounds) -> _AnyBounds? {
      let bounds = self._intersection(other)
      return _CountableBounds(bounds)
    }
    
    override func _subtracting(_ other: _AnyBounds) -> [_AnyBounds] {
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
    
    override func _subtracted(from other: _AnyBounds) -> [_AnyBounds] {
      let minuend = _CountableBounds<Bound>(other.bounds(type: Bound.self))!
      return minuend._subtracting(self)
    }
    
    override func _isConcatenatable(with other: _SomeBounds<Bound>) -> Bool {
      let myBounds = self.bounds(type: Bound.self)
      let otherBounds = other.bounds(type: Bound.self)
      
      return myBounds.upper._isConcatenatable(with: otherBounds.lower) &&
             otherBounds.upper._isConcatenatable(with: myBounds.lower)
    }
    
    override func concatenating(_ other: _AnyBounds) -> _AnyBounds? {
      guard case let other as _SomeBounds<Bound> = other else { fatalError("Unexpected type.") }
      guard let concatenated = self._concatenating(other) else {
        return nil
      }
      return _CountableBounds<Bound>(concatenated)
    }
  }
}

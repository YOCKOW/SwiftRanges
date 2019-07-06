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
}

extension _AnyBounds {
  internal final class _UnboundedBounds: _AnyBounds {
    internal override init() {}
    
    internal override func bounds<T>(type: T.Type) -> Bounds<T> {
      return (lower: .unbounded, upper: .unbounded)
    }
    
    internal override func intersection(_ other: _AnyBounds) -> _AnyBounds? {
      return other // Because i am unbounded.
    }
  }
  
  internal class _UncountableBounds<Bound>: _AnyBounds where Bound: Comparable {
    private var _bounds: Bounds<Bound>
    internal init?(_ bounds: Bounds<Bound>) {
      guard _validateBounds(bounds) else { return nil }
      precondition(bounds.lower != .unbounded || bounds.upper != .unbounded,
                   "Must not be an unbounded range.")
      self._bounds = bounds
    }
    
    internal override func bounds<T>(type: T.Type) -> Bounds<T> {
      guard case let bounds as Bounds<T> = self._bounds else {
        fatalError("\(#function): \(Bound.self) != \(T.self)")
      }
      return bounds
    }
    
    fileprivate func _intersection(_ other: _AnyBounds) -> Bounds<Bound> {
      let otherBounds = other.bounds(type: Bound.self)
      let lower = _max(self._bounds.lower, otherBounds.lower, side: .lower)
      let upper = _min(self._bounds.upper, otherBounds.upper, side: .upper)
      return (lower: lower, upper: upper)
    }
    
    internal override func intersection(_ other: _AnyBounds) -> _AnyBounds? {
      guard type(of: other) == _UncountableBounds<Bound>.self else {
        return other.intersection(self)
      }
      let bounds = self._intersection(other)
      return _UncountableBounds(bounds)
    }
  }
  
  internal final class _CountableBounds<Bound>: _UncountableBounds<Bound> where Bound: Strideable, Bound.Stride: SignedInteger {
    internal override init?(_ bounds: Bounds<Bound>) {
      guard _validateBounds(bounds) else { return nil }
      precondition(bounds.lower != .unbounded || bounds.upper != .unbounded,
                   "Must not be an unbounded range.")
      super.init(bounds)
    }
    
    internal override func intersection(_ other: _AnyBounds) -> _AnyBounds? {
      let bounds = self._intersection(other)
      return _CountableBounds(bounds)
    }
  }
}

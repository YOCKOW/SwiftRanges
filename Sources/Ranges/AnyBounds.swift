/* *************************************************************************************************
 AnyBounds.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 

/// A type erasure for bounds.
/// Exists to determine its "countability" at the time of initialization of `AnyRange`.
internal class _AnyBounds {
  internal func bounds<T>(type: T.Type) -> Bounds<T> { fatalError("\(#function) must be overridden.") }
}

extension _AnyBounds {
  internal class _UnboundedBounds: _AnyBounds {
    internal override init() {}
    
    internal override func bounds<T>(type: T.Type) -> Bounds<T> {
      return (lower: .unbounded, upper: .unbounded)
    }
  }
  
  internal class _UncountableBounds<Bound>: _AnyBounds where Bound: Comparable {
    private var _bounds: Bounds<Bound>
    internal init?(_ bounds: Bounds<Bound>) {
      guard _validateBounds(bounds) else { return nil }
      self._bounds = bounds
    }
    
    internal override func bounds<T>(type: T.Type) -> Bounds<T> {
      guard case let bounds as Bounds<T> = self._bounds else {
        fatalError("\(#function): \(Bound.self) != \(T.self)")
      }
      return bounds
    }
  }
  
  internal class _CountableBounds<Bound>: _UncountableBounds<Bound> where Bound: Strideable, Bound.Stride: SignedInteger {
    internal override init?(_ bounds: Bounds<Bound>) {
      guard _validateBounds(bounds) else { return nil }
      super.init(bounds)
    }
    
    internal override func bounds<T>(type: T.Type) -> Bounds<T> {
      return super.bounds(type: T.self)
    }
  }
}

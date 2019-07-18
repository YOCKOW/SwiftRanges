/***************************************************************************************************
 Boundary.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/


/// # Boundary
///
/// `Boundary` represents a bound for a range.
public enum Boundary<Value> where Value: Comparable {
  case unbounded
  case included(Value)
  case excluded(Value)
  
  public var value: Value? {
    switch self {
    case .unbounded:
      return nil
    case .included(let value), .excluded(let value):
      return value
    }
  }
}

/// `Boundary` whose value is countable.
public typealias CountableBoundary<Value> =
  Boundary<Value> where Value: Strideable, Value.Stride: SignedInteger

extension Boundary: Equatable {
  public static func ==(lhs: Boundary<Value>, rhs: Boundary<Value>) -> Bool {
    switch (lhs, rhs) {
    case (.included(let lvalue), .included(let rvalue)) where lvalue == rvalue,
         (.excluded(let lvalue), .excluded(let rvalue)) where lvalue == rvalue:
      return true
    case (.unbounded, .unbounded):
      return true
    default:
      return false
    }
  }
}

extension Boundary: Hashable where Value: Hashable {
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .unbounded:
      hasher.combine(0)
    case .included(let value):
      hasher.combine(value)
    case .excluded(let value):
      hasher.combine(value.hashValue)
    }
  }
}

extension Boundary {
  /// Reverse the bound.
  internal static prefix func ~(_ boundary: Boundary<Value>) -> Boundary<Value> {
    switch boundary {
    case .unbounded:
      fatalError("Cannot reverse unbounded bound.")
    case .included(let value):
      return .excluded(value)
    case .excluded(let value):
      return .included(value)
    }
  }
}

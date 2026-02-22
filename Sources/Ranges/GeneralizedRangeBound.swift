/* *************************************************************************************************
 GeneralizedRangeBound.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */


/// `GeneralizedRangeBound` represents a bound for a range.
public enum GeneralizedRangeBound<Value> where Value: Comparable {
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

@available(*, deprecated, renamed: "GeneralizedRangeBound")
public typealias Boundary<Value> = GeneralizedRangeBound<Value> where Value: Comparable

/// `Boundary` whose value is countable.
public typealias GeneralizedCountableRangeBound<Value> =
  GeneralizedRangeBound<Value> where Value: Strideable, Value.Stride: SignedInteger


@available(*, deprecated, renamed: "GeneralizedCountableRangeBound")
public typealias CountableBoundary<Value> =
  GeneralizedCountableRangeBound<Value> where Value: Strideable, Value.Stride: SignedInteger

extension GeneralizedRangeBound: Equatable {
  public static func ==(
    lhs: GeneralizedRangeBound<Value>,
    rhs: GeneralizedRangeBound<Value>
  ) -> Bool {
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

extension GeneralizedRangeBound: Hashable where Value: Hashable {
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

extension GeneralizedRangeBound {
  /// Reverse the bound.
  internal static prefix func ~(
    _ boundary: GeneralizedRangeBound<Value>
  ) -> GeneralizedRangeBound<Value> {
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

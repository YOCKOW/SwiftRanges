/* *************************************************************************************************
 HashableRange.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */


/// A range that conforms to `Hashable`.
public protocol HashableRange: Hashable, GeneralizedRange where Bound: Hashable {}

extension GeneralizedRange where Self: Equatable {
  /// Default implementation for `GeneralizedRange & Equatable`.
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    switch (lhs.bounds, rhs.bounds) {
    case (nil, nil):
      return true
    case (let lBounds?, let rBounds?):
      return lBounds.lower == rBounds.lower && lBounds.upper == rBounds.upper
    default:
      return false
    }
  }
}

@inlinable
internal func _hashBounds<Bound>(
  _ bounds: Bounds<Bound>?,
  into hasher: inout Hasher
) where Bound: Hashable {
  hasher.combine(0)
  if let bounds = bounds {
    hasher.combine(bounds.lower)
    hasher.combine(bounds.upper)
  }
}

extension GeneralizedRange where Self: Hashable, Self.Bound: Hashable {
  /// Default implementation for `GeneralizedRange & Hashable`.
  public func hash(into hasher:inout Hasher) {
    _hashBounds(self.bounds, into: &hasher)
  }
}

/* *************************************************************************************************
 RangeValuePairs.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */


internal struct _RangeValuePairs<Bound, Value> where Bound: Comparable {
  enum _Storage {
    case pairs([(range: any GeneralizedRange<Bound> & Sendable, value: Value)])
    case separated(ranges: [any GeneralizedRange<Bound> & Sendable], values: [Value])
    case ranges([any GeneralizedRange<Bound> & Sendable])
  }

  private var _storage: _Storage

  init(pairs: [(range: any GeneralizedRange<Bound> & Sendable, value: Value)]) {
    self._storage = .pairs(pairs)
  }

  init(ranges: [any GeneralizedRange<Bound> & Sendable], values: [Value]) {
    self._storage = .separated(ranges: ranges, values: values)
  }

  init(ranges: [any GeneralizedRange<Bound> & Sendable]) {
    self._storage = .ranges(ranges)
  }
}
extension _RangeValuePairs._Storage: Sendable where Value: Sendable {}
extension _RangeValuePairs: Sendable where Value: Sendable {}


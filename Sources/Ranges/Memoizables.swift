/* *************************************************************************************************
 Memoizables.swift
   © 2020,2023 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

/// Immutable range-dictionary.
/// Results can be memoized.
public final class MemoizableRangeDictionary<Bound, Value> where Bound: Comparable & Hashable {
  private let _queue = DispatchQueue(
    label: "jp.YOCKOW.Ranges.MemoizableRangeDictionary.\(UUID().description)",
    attributes: .concurrent
  )

  private var _memoized: [Bound: Value?] = [:]
  private var _recentPairs: ArraySlice<RangeDictionary<Bound, Value>._Pair> = []
  private let _rangeDictionary: RangeDictionary<Bound, Value>
  
  public init(_ rangeDictionary: RangeDictionary<Bound, Value>) {
    self._rangeDictionary = rangeDictionary
  }

  public subscript(_ element: Bound) -> Value? {
    return _queue.sync(flags: .barrier) {
      func __valueWithMemoizing(for bound: Bound) -> Value? {
        func __recentValue(for bound: Bound) -> Value? {
          for pair in self._recentPairs {
            if pair.range.contains(bound) { return pair.value }
          }
          return nil
        }

        if let value = __recentValue(for: bound) {
          self._memoized[element] = value
          return value
        } else if let index = self._rangeDictionary._index(whereRangeContains: bound) {
          let pair = self._rangeDictionary._rangesAndValues[index]
          MEMOIZE: do {
            self._memoized[bound] = pair.value
            self._recentPairs.append(pair)
            self._recentPairs = self._recentPairs.suffix(3)
          }
          return pair.value
        } else {
          self._memoized[bound] = Optional<Value>.none
          return nil
        }
      }

      switch self._memoized[element] {
      case Optional<Value?>.none:
        return __valueWithMemoizing(for: element)
      case Optional<Value?>.some(.none):
        return nil
      case Optional<Value?>.some(.some(let value)):
        return value
      }
    }
  }
}



/// Immutable multiple ranges.
/// Results can be memoized.
public final class MemoizableMultipleRanges<Bound> where Bound: Comparable & Hashable {
  private var _memoized: MemoizableRangeDictionary<Bound, Void>
  
  public init(_ ranges: MultipleRanges<Bound>) {
    self._memoized = .init(ranges._rangeDictionary)
  }
  
  public func contains(_ value: Bound) -> Bool {
    return self._memoized[value] != nil
  }
}



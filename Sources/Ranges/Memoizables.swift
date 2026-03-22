/* *************************************************************************************************
 Memoizables.swift
   © 2020,2023,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

/// Immutable range-dictionary.
/// Results can be memoized.
public final class MemoizableRangeDictionary<Bound, Value>: @unchecked Sendable where Bound: Comparable,
                                                                                      Bound: Hashable,
                                                                                      Bound: Sendable,
                                                                                      Value: Sendable {
  private let _queue = DispatchQueue(
    label: "jp.YOCKOW.Ranges.MemoizableRangeDictionary.\(UUID().description)",
    attributes: .concurrent
  )

  private var _memoized: [Bound: Value?] = [:]
  private var _recentPairs: ArraySlice<(range: any GeneralizedRange<Bound>, value: Value)> = []
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
        } else if let index = self._rangeDictionary._pairs.index(whereRangeContains: element) {
          let pair = self._rangeDictionary._pairs.pair(at: index)
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
public final class MemoizableGeneralizedRangeSet<Bound>: @unchecked Sendable where Bound: Comparable,
                                                                                   Bound: Hashable,
                                                                                   Bound: Sendable {
  private let _queue = DispatchQueue(
    label: "jp.YOCKOW.Ranges.MemoizableGeneralizedRangeSet.\(UUID().description)",
    attributes: .concurrent
  )

  private var _memoized: [Bound: Bool] = [:]
  private var _recentRanges: ArraySlice<any GeneralizedRange<Bound>> = []
  private var _rangeSet: GeneralizedRangeSet<Bound>

  public init(_ ranges: GeneralizedRangeSet<Bound>) {
    self._rangeSet = ranges
  }
  
  public func contains(_ value: Bound) -> Bool {
    return _queue.sync(flags: .barrier) { () -> Bool in
      if let memoized = _memoized[value] {
        return memoized
      }

      if _recentRanges.contains(where: { $0.contains(value) }) {
        _memoized[value] = true
        return true
      }

      if let index = self._rangeSet._ranges.index(whereRangeContains: value) {
        let theRange = self._rangeSet._ranges.range(at: index)
        _memoized[value] = true
        _recentRanges.append(theRange)
        _recentRanges = _recentRanges.suffix(3)
        return true
      } else {
        _memoized[value] = false
        return false
      }
    }
  }
}



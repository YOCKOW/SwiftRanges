/* *************************************************************************************************
 Memoizables.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

/// Immutable range-dictionary.
/// Results can be memoized.
public final class MemoizableRangeDictionary<Bound, Value> where Bound: Comparable & Hashable {
  private var _memoized: [Bound: Value?] = [:]
  private var _recentPairs: ArraySlice<RangeDictionary<Bound, Value>._Pair> = []
  private var _rangeDictionary: RangeDictionary<Bound, Value>
  
  public init(_ rangeDictionary: RangeDictionary<Bound, Value>) {
    self._rangeDictionary = rangeDictionary
  }
  
  private func _memoizedValue(for bound: Bound) -> Value?? {
    return self._memoized[bound]
  }
  
  private func _recentValue(for bound: Bound) -> Value? {
    for pair in self._recentPairs {
      if pair.range.contains(bound) { return pair.value }
    }
    return nil
  }
  
  private func _appendRecentPair(_ pair: RangeDictionary<Bound, Value>._Pair) {
    self._recentPairs.append(pair)
    self._recentPairs = self._recentPairs.suffix(3)
  }
  
  private func _valueWithMemoizing(for bound: Bound) -> Value? {
    if let index = self._rangeDictionary._index(whereRangeContains: bound) {
      let pair = self._rangeDictionary._rangesAndValues[index]
      self._memoized[bound] = pair.value
      self._appendRecentPair(pair)
      return pair.value
    } else {
      self._memoized[bound] = Optional<Value>.none
      return nil
    }
  }
  
  public subscript(_ element: Bound) -> Value? {
    switch self._memoized[element] {
    case Optional<Value?>.none:
      if let value = self._recentValue(for: element) {
        self._memoized[element] = value
        return value
      }
      return _valueWithMemoizing(for: element)
    case Optional<Value?>.some(.none):
      return nil
    case Optional<Value?>.some(.some(let value)):
      return value
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



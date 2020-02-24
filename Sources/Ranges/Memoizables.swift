/* *************************************************************************************************
 Memoizables.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
/// Immutable multiple ranges.
/// Results can be memoized.
public final class MemoizableMultipleRanges<Bound> where Bound: Comparable & Hashable {
  private var _memoized: [Bound: Bool] = [:]
  private var _multipleRanges: MultipleRanges<Bound>
  
  public init(_ ranges: MultipleRanges<Bound>) {
    self._multipleRanges = ranges
  }
  
  public func contains(_ value: Bound) -> Bool {
    func _contains(_ value: Bound) -> Bool {
      let result = self._multipleRanges.contains(value)
      self._memoized[value] = result
      return result
    }
    return self._memoized[value] ?? _contains(value)
  }
}


/// Immutable range-dictionary.
/// Results can be memoized.
public final class MemoizableRangeDictionary<Bound, Value> where Bound: Comparable & Hashable {
  private var _memoized: [Bound: Value?] = [:]
  private var _rangeDictionary: RangeDictionary<Bound, Value>
  
  public init(_ rangeDictionary: RangeDictionary<Bound, Value>) {
    self._rangeDictionary = rangeDictionary
  }
  
  public subscript(_ element: Bound) -> Value? {
    func _value() -> Value? {
      let result = self._rangeDictionary[element]
      self._memoized[element] = result
      return result
    }
    
    switch self._memoized[element] {
    case Optional<Value?>.none:
      return _value()
    case Optional<Value?>.some(.none):
      return nil
    case Optional<Value?>.some(.some(let value)):
      return value
    }
  }
}

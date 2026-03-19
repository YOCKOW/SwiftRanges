/* *************************************************************************************************
 RangeDictionary.swift
   © 2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */


/**

 A collection like `Dictionary`, whose key is a range.
 
 ```
 var dic: RangeDictionary<Int, String> = [
   1....2: "Index",
   3....10: "Chapter 01",
   11....40: "Chapter 02"
 ]
 
 print(dic[1]) // Prints "Index"
 print(dic[5]) // Prints "Chapter 01"
 print(dic[15]) // Prints "Chapter 02"
 print(dic[100]) // Prints "nil"
 
 dic.insert("Prologue", forRange: 2....5)
 print(dic[5]) // Prints "Prologue"
 ```
 
 */
public struct RangeDictionary<Bound, Value> where Bound: Comparable {
  internal private(set) var _pairs: _SortedRangeValuePairs<Bound, Value>

  public var isEmpty: Bool {
    return self._pairs.isEmpty
  }

  private init(_pairs pairs: _SortedRangeValuePairs<Bound, Value>) {
    self._pairs = pairs
  }

  /// Creates an empty dictionary.
  public init() {
    self.init(_pairs: .init(carefullySortedPairs: []))
  }
  
  /// Creates a dictionary with `rangesAndValues`.
  ///
  /// - Warning: `rangesAndValues` must be sorted in advance,
  ///            and all ranges must not be overlapped each other.
  ///            Furthermore, no ranges must be empty.
  ///            You may not use this initializer usually.
  public init(carefullySortedRangesAndValues rangesAndValues: [(any GeneralizedRange<Bound>, Value)]) {
    self.init(_pairs: .init(carefullySortedPairs: rangesAndValues))
  }
  
  /// Creates a dictionary with `rangesAndValues`.
  public init(_ rangesAndValues: [(any GeneralizedRange<Bound>, Value)]) {
    var pairs = _SortedRangeValuePairs<Bound, Value>(carefullySortedPairs: [])
    for (range, value) in rangesAndValues {
      pairs.insertValue(value, forRange: range._wellknownRange)
    }
    self.init(_pairs: pairs)
  }

  /// Returns the associated value for the element that is included in a range.
  public subscript(_ element: Bound) -> Value? {
    return self._pairs[element]
  }

  /// Let the dictionary return `nil` for `range`.
  public mutating func removeValues(in range: any GeneralizedRange<Bound>) {
    self._pairs.removeValues(in: range._wellknownRange)
  }

  /// Let the dictionary return `nil` for `range`.
  @available(*, deprecated, renamed: "removeValues(in:)")
  public mutating func remove(range: AnyRange<Bound>) {
    self.removeValues(in: range)
  }

  /// Inserts the given value for the range.
  public mutating func insert(_ value: Value, forRange range: any GeneralizedRange<Bound>) {
    self._pairs.insertValue(value, forRange: range._wellknownRange)
  }
  
  /// Returns a new dictionary whose ranges are limited within `range`.
  public func limited(within range: any GeneralizedRange<Bound>) -> RangeDictionary<Bound, Value> {
    return .init(_pairs: self._pairs.limited(within: range._wellknownRange))
  }
}

extension RangeDictionary: Sendable where Bound: Sendable, Value: Sendable {}

extension RangeDictionary where Bound: Sendable {
  /// Creates a `Sendable` dictionary with `rangesAndValues`.
  ///
  /// - Warning: `rangesAndValues` must be sorted in advance,
  ///            and all ranges must not be overlapped each other.
  ///            Furthermore, no ranges must be empty.
  ///            You may not use this initializer usually.
  public init(carefullySortedRangesAndValues rangesAndValues: [(any GeneralizedRange<Bound> & Sendable, Value)]) {
    self.init(_pairs: .init(carefullySortedPairs: rangesAndValues))
  }
}

public typealias CountableRangeDictionary<Bound, Value> =
  RangeDictionary<Bound, Value> where Bound: Strideable, Bound.Stride: SignedInteger

extension RangeDictionary: ExpressibleByDictionaryLiteral {
  public typealias Key = any GeneralizedRange<Bound>
  public init(dictionaryLiteral elements: (any GeneralizedRange<Bound>, Value)...) {
    self.init(elements)
  }
}

extension RangeDictionary: Equatable where Value: Equatable {
  public static func == (lhs: RangeDictionary, rhs: RangeDictionary) -> Bool {
    return lhs._pairs == rhs._pairs
  }
}

extension RangeDictionary: Hashable where Bound: Hashable, Value: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self._pairs)
  }
}

extension RangeDictionary where Value: Equatable {
  /// Inserts the given value for `range`.
  public mutating func insert(
    _ value: Value,
    forRange range: any GeneralizedRange<Bound>,
    normalize: Bool
  ) {
    self._pairs.insertValue(value, forRange: range._wellknownRange)
    if normalize {
      self._pairs = self._pairs.normalized()
    }
  }

  /// Inserts the given value for `range`.
  /// Ranges are concatenated if possible.
  public mutating func insert(_ value: Value, forRange range: any GeneralizedRange<Bound>) {
    self.insert(value, forRange: range, normalize: true)
  }
  
  /// Creates a dictionary with `rangesAndValues`.
  public init(_ rangesAndValues: [(any GeneralizedRange<Bound>, Value)]) {
    self.init()
    if rangesAndValues.isEmpty {
      return
    }
    for (range, value) in rangesAndValues.dropLast() {
      self.insert(value, forRange: range, normalize: false)
    }
    let lastPair = rangesAndValues.last!
    self.insert(lastPair.1, forRange: lastPair.0, normalize: true)
  }
}

@available(*, deprecated, message: "`Value` being `Void` is deprecated.")
extension RangeDictionary where Value == Void {
  /// Inserts the given value for the range.
  /// Ranges are concatenated if possible.
  public mutating func insert(range: AnyRange<Bound>) {
    self.insert((), forRange: range)
  }
}

extension RangeDictionary: Sequence, Collection, BidirectionalCollection, RandomAccessCollection {
  public typealias Element = (any GeneralizedRange<Bound>, Value)

  public struct Index: Comparable {
    fileprivate let _value: Int
    fileprivate init(_ index: Int) {
      self._value = index
    }
    
    public static func == (lhs: Index, rhs: Index) -> Bool {
      return lhs._value == rhs._value
    }
    
    public static func < (lhs: Index, rhs: Index) -> Bool {
      return lhs._value < rhs._value
    }
  }
  
  public struct Iterator: IteratorProtocol {
    public typealias Element = RangeDictionary<Bound, Value>.Element
    
    private var _index: RangeDictionary<Bound, Value>.Index = .init(0)
    fileprivate var _dictionary: RangeDictionary<Bound, Value>
    fileprivate init(_ dictionary: RangeDictionary<Bound, Value>) {
      self._dictionary = dictionary
    }
    
    public mutating func next() -> (any GeneralizedRange<Bound>, Value)? {
      let currentIndex = self._index._value
      guard currentIndex < self._dictionary._pairs.count else {
        return nil
      }

      let pair = self._dictionary._pairs.pair(at: currentIndex)
      self._index = .init(currentIndex + 1)
      return pair
    }
  }
  
  public subscript(_ index: Index) -> (any GeneralizedRange<Bound>, Value) {
    return self._pairs.pair(at: index._value)
  }
  
  public subscript(_ index: Index) -> Value {
    guard let value = self._pairs.value(at: index._value) else {
      fatalError("No value available.")
    }
    return value
  }
  
  public var count: Int {
    return self._pairs.count
  }
  
  public func makeIterator() -> Iterator {
    return .init(self)
  }
  
  public var startIndex: Index {
    return .init(0)
  }
  
  public var endIndex: Index {
    return .init(self.count)
  }
  
  public func index(after ii: Index) -> Index {
    return .init(ii._value + 1)
  }
  
  public func index(before ii: Index) -> Index {
    return .init(ii._value - 1)
  }
}

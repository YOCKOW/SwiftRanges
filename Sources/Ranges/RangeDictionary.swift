/* *************************************************************************************************
 RangeDictionary.swift
   © 2019 YOCKOW.
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
  internal typealias _Pair = (range: AnyRange<Bound>, value: Value)
  
  /// Must be always sorted with the ranges.
  internal private(set) var _rangesAndValues: [_Pair]
  private func _twoRanges(from index: Int) -> (AnyRange<Bound>, AnyRange<Bound>) {
    let (pair0, pair1) = self._rangesAndValues._twoElements(from: index)
    return (pair0.range, pair1.range)
  }
  private func _validateRanges() -> Bool {
    let nn = self._rangesAndValues.count
    switch nn {
    case 0:
      return true
    case 1:
      return !self._rangesAndValues[0].range.isEmpty
    default:
      for ii in 0..<(nn - 1) {
        let (range0, range1) = self._twoRanges(from: ii)
        guard !range0.isEmpty && !range1.isEmpty && range0 << range1 else { return false }
      }
      return true
    }
  }
  private var _rangesDescription: String {
    return "[" + self._rangesAndValues.map({ "\($0.range)" }).joined(separator: ", ") + "]"
  }
  
  public var isEmpty: Bool {
    return self._rangesAndValues.isEmpty
  }
  
  /// Creates an empty dictionary.
  public init() {
    self._rangesAndValues = []
  }
  
  /// Creates a dictionary with `rangesAndValues`.
  /// `rangesAndValues` must be sorted in advance, and all ranges must not be overlapped each other.
  /// Furthermore, no ranges must be empty.
  /// You may not use this initializer usually.
  public init(carefullySortedRangesAndValues rangesAndValues: [(AnyRange<Bound>, Value)]) {
    self._rangesAndValues = rangesAndValues
    assert(_validateRanges(), "Invalid range-value pair(s).")
  }
  
  /// Creates a dictionary with `rangesAndValues`.
  public init(_ rangesAndValues: [(AnyRange<Bound>, Value)]) {
    self.init()
    for pair: _Pair in rangesAndValues {
      if pair.range.isEmpty { continue }
      self.insert(pair.value, forRange: pair.range)
    }
  }
  
  internal func _index(whereRangeContains element: Bound) -> Int? {
    func _binarySearch<C>(_ collection: C, _ element: Bound) -> Int?
      where C: Collection, C.Index == Int, C.Element == _Pair
    {
      if collection.isEmpty { return nil }
      let middleIndex = collection.startIndex + ((collection.endIndex - collection.startIndex) / 2)
      let pair = self._rangesAndValues[middleIndex]
      if pair.range.contains(element) { return middleIndex }
      if pair.range.bounds!.lower._compare(element, side: .lower) == .orderedDescending {
        return _binarySearch(collection[collection.startIndex..<middleIndex], element)
      } else {
        return _binarySearch(collection[middleIndex<..<collection.endIndex], element)
      }
    }
    return _binarySearch(self._rangesAndValues, element)
  }
  
  /// Returns the associated value for the element that is included in a range.
  public subscript(_ element: Bound) -> Value? {
    get {
      guard let index = self._index(whereRangeContains: element) else { return nil }
      return self._rangesAndValues[index].value
    }
  }
  
  private enum _IndicesForReplacement {
    case overlap(first: Int, last: Int)
    case insertable(Int)
  }
  private func _indices(for range: AnyRange<Bound>) -> _IndicesForReplacement {
    assert(!range.isEmpty, "\(#function): `range` must not be empty.")
    
    let numberOfPairs = self._rangesAndValues.count
    
    var overlap_first: Int? = nil
    determineFirstIndexOfOverlap: do {
      if self._rangesAndValues.isEmpty {
        return .insertable(0)
      }
      if range << self._rangesAndValues.first!.range {
        return .insertable(0)
      }
      if range.overlaps(self._rangesAndValues.first!.range) {
        overlap_first = 0
        break determineFirstIndexOfOverlap
      }
      if self._rangesAndValues.last!.range << range {
        return .insertable(numberOfPairs)
      }
      assert(numberOfPairs > 1, "Must be already handled if the number of pairs is less than 2.")
      
      for ii in 0..<(numberOfPairs - 1) {
        let (range0, range1) = self._twoRanges(from: ii)
        if range.overlaps(range1) {
          overlap_first = ii + 1
          break determineFirstIndexOfOverlap
        }
        if range0 << range && range << range1 {
          return .insertable(ii + 1)
        }
      }
    }
    
    assert(overlap_first != nil, "First index of overlap must be found.")
    var overlap_last: Int? = nil
    for ii in (overlap_first!..<numberOfPairs).reversed() {
      if self._rangesAndValues[ii].range.overlaps(range) {
        overlap_last = ii
        break
      }
    }
    
    // `overlap_last` might be equal to `overlap_first`
    return .overlap(first: overlap_first!, last: overlap_last!)
  }
  
  private func _splitted(by range: AnyRange<Bound>) -> (ArraySlice<_Pair>, ArraySlice<_Pair>) {
    assert(!range.isEmpty, "\(#function): `range` must not be empty.")
    let nn = self._rangesAndValues.count
    
    switch self._indices(for: range) {
    case .insertable(let index):
      return (self._rangesAndValues[0..<index],
              self._rangesAndValues[index..<nn])
      
    case .overlap(first: let first, last: let last):
      var former = self._rangesAndValues[0..<first]
      var latter = self._rangesAndValues[last<..<nn]
      
      if first == last {
        let target: _Pair = self._rangesAndValues[first]
        let subtracted = target.range.subtracting(range)
        if let subtracted1 = subtracted.1 {
          former.append((range: subtracted.0, value: target.value))
          latter.insert((range: subtracted1, value: target.value), at: latter.startIndex)
        } else {
          if subtracted.0 < range {
            former.append((range: subtracted.0, value: target.value))
          } else {
            latter.insert((range: subtracted.0, value: target.value), at: latter.startIndex)
          }
        }
      } else {
        // first != last
        let formerTarget: _Pair = self._rangesAndValues[first]
        let latterTarget: _Pair = self._rangesAndValues[last]
        
        let formerSubtracted = formerTarget.range.subtracting(range).0
        // second one is always nil because first != last
        if !formerSubtracted.isEmpty {
          former.append((range: formerSubtracted, value: formerTarget.value))
        }
        
        let latterSubtracted = latterTarget.range.subtracting(range).0
        if !latterSubtracted.isEmpty {
          latter.insert((range: latterSubtracted, value: latterTarget.value), at: latter.startIndex)
        }
      }
      
      return (former, latter)
    }
    
  }
  
  /// Let the dictionary return `nil` for `range`.
  public mutating func remove(range: AnyRange<Bound>) {
    if range.isEmpty { return }
    
    let splitted = self._splitted(by: range)
    self._rangesAndValues = Array<_Pair>(splitted.0 + splitted.1)
    assert(_validateRanges(), "Invalid range(s): " + self._rangesDescription)
  }
  
  /// Inserts the given value for the range.
  public mutating func insert(_ value: Value, forRange range: AnyRange<Bound>) {
    if range.isEmpty { return }
    
    let splitted = self._splitted(by: range)
    self._rangesAndValues = Array<_Pair>(splitted.0)
    self._rangesAndValues.append((range: range, value: value))
    self._rangesAndValues.append(contentsOf: splitted.1)
    assert(_validateRanges())
  }
  
  /// Returns a new dictionary whose ranges are limited within `range`.
  public func limited(within range: AnyRange<Bound>) -> RangeDictionary<Bound, Value> {
    guard
      !range.isEmpty,
      case .overlap(first: let first, last: let last) = self._indices(for: range)
    else {
      return .init()
    }
    
    var pairs = self._rangesAndValues[first...last]
    if pairs.isEmpty { return .init() }
    
    let firstPair = pairs.first!
    pairs[pairs.startIndex] = (range: firstPair.range.intersection(range), value: firstPair.value)
    
    if pairs.count > 1 {
      let lastPair = pairs.last!
      pairs[pairs.endIndex - 1] = (range: lastPair.range.intersection(range), value: lastPair.value)
    }
    
    return .init(carefullySortedRangesAndValues: Array<_Pair>(pairs))
  }
}


extension RangeDictionary: ExpressibleByDictionaryLiteral {
  public typealias Key = AnyRange<Bound>
  public init(dictionaryLiteral elements: (AnyRange<Bound>, Value)...) {
    self.init(elements)
  }
}

extension RangeDictionary: Equatable where Value: Equatable {
  public static func == (lhs: RangeDictionary, rhs: RangeDictionary) -> Bool {
    guard lhs._rangesAndValues.count == rhs._rangesAndValues.count else { return false }
    for ii in 0..<lhs._rangesAndValues.count {
      let lPair = lhs._rangesAndValues[ii]
      let rPair = rhs._rangesAndValues[ii]
      guard lPair.range == rPair.range && lPair.value == rPair.value else { return false }
    }
    return true
  }
}

extension RangeDictionary: Hashable where Bound: Hashable, Value: Hashable {
  public func hash(into hasher: inout Hasher) {
    for pair in self._rangesAndValues {
      hasher.combine(pair.range)
      hasher.combine(pair.value)
    }
  }
}

extension RangeDictionary where Value == Void {
  public static func == (lhs: RangeDictionary, rhs: RangeDictionary) -> Bool {
    guard lhs._rangesAndValues.count == rhs._rangesAndValues.count else { return false }
    for ii in 0..<lhs._rangesAndValues.count {
      let lPair = lhs._rangesAndValues[ii]
      let rPair = rhs._rangesAndValues[ii]
      guard lPair.range == rPair.range else { return false }
    }
    return true
  }
}

extension RangeDictionary where Value: Equatable {
  /// Inserts the given value for the range.
  /// Ranges are concatenated if possible.
  public mutating func insert(_ value: Value, forRange range: AnyRange<Bound>) {
    let splitted = self._splitted(by: range)
    var pairs = Array<_Pair>(splitted.0)
    
    if pairs.last?.value == value, let concatenated = pairs.last?.range.concatenating(range) {
      pairs[pairs.count - 1].range = concatenated
    } else {
      pairs.append((range: range, value: value))
    }
    
    if splitted.1.first?.value == pairs.last!.value,
       let concatenated = splitted.1.first?.range.concatenating(pairs.last!.range)
    {
      pairs[pairs.count - 1].range = concatenated
      pairs.append(contentsOf: splitted.1[(splitted.1.startIndex + 1)..<splitted.1.endIndex])
    } else {
      pairs.append(contentsOf: splitted.1)
    }
    
    self._rangesAndValues = pairs
  }
  
  /// Creates a dictionary with `rangesAndValues`.
  public init(_ rangesAndValues: [(AnyRange<Bound>, Value)]) {
    self.init()
    for pair: _Pair in rangesAndValues {
      if pair.range.isEmpty { continue }
      self.insert(pair.value, forRange: pair.range)
    }
  }
}

extension RangeDictionary where Value == Void {
  /// Inserts the given value for the range.
  /// Ranges are concatenated if possible.
  public mutating func insert(range: AnyRange<Bound>) {
    let splitted = self._splitted(by: range)
    var pairs = Array<_Pair>(splitted.0)
    
    if let concatenated = pairs.last?.range.concatenating(range) {
      pairs[pairs.count - 1].range = concatenated
    } else {
      pairs.append((range: range, value: ()))
    }
    
    if let concatenated = splitted.1.first?.range.concatenating(pairs.last!.range) {
      pairs[pairs.count - 1].range = concatenated
      pairs.append(contentsOf: splitted.1[(splitted.1.startIndex + 1)..<splitted.1.endIndex])
    } else {
      pairs.append(contentsOf: splitted.1)
    }
    
    self._rangesAndValues = pairs
  }
}

extension RangeDictionary: Sequence, Collection, BidirectionalCollection, RandomAccessCollection {
  public typealias Element = (AnyRange<Bound>, Value)
  
  public struct Index: Comparable {
    fileprivate let _index: Int
    fileprivate init(_ index: Int) {
      self._index = index
    }
    
    public static func == (lhs: Index, rhs: Index) -> Bool {
      return lhs._index == rhs._index
    }
    
    public static func < (lhs: Index, rhs: Index) -> Bool {
      return lhs._index < rhs._index
    }
  }
  
  public struct Iterator: IteratorProtocol {
    public typealias Element = RangeDictionary<Bound, Value>.Element
    
    private var _index: RangeDictionary<Bound, Value>.Index = .init(0)
    fileprivate var _dictionary: RangeDictionary<Bound, Value>
    fileprivate init(_ dictionary: RangeDictionary<Bound, Value>) {
      self._dictionary = dictionary
    }
    
    public mutating func next() -> (AnyRange<Bound>, Value)? {
      if self._index >= self._dictionary.endIndex { return nil }
      defer { self._index = self._dictionary.index(after: self._index) }
      return self._dictionary[self._index]
    }
  }
  
  public subscript(_ index: Index) -> (AnyRange<Bound>, Value) {
    return self._rangesAndValues[index._index]
  }
  
  public subscript(_ index: Index) -> Value {
    get {
      return self._rangesAndValues[index._index].value
    }
    set {
      self._rangesAndValues[index._index].value = newValue
    }
  }
  
  public var count: Int {
    return self._rangesAndValues.count
  }
  
  public func makeIterator() -> Iterator {
    return .init(self)
  }
  
  public var startIndex: Index {
    return .init(self._rangesAndValues.startIndex)
  }
  
  public var endIndex: Index {
    return .init(self._rangesAndValues.endIndex)
  }
  
  public func index(after ii: Index) -> Index {
    return .init(ii._index + 1)
  }
  
  public func index(before ii: Index) -> Index {
    return .init(ii._index - 1)
  }
}

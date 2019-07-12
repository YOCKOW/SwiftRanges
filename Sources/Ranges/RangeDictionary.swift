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
   .init(1...2): "Index",
   .init(3...10): "Chapter 01",
   .init(11...40): "Chapter 02"
 ]
 
 print(dic[1]) // Prints "Index"
 print(dic[5]) // Prints "Chapter 01"
 print(dic[15]) // Prints "Chapter 02"
 print(dic[100]) // Prints "nil"
 
 dic.insert("Prologue", forRange: .init(2...5))
 print(dic[5]) // Prints "Prologue"
 ```
 
 */
public struct RangeDictionary<Bound, Value> where Bound: Comparable {
  private typealias _Pair = (range: AnyRange<Bound>, value: Value)
  
  /// Must be always sorted with the ranges.
  private var _rangesAndValues: [_Pair]
  private func _validateRanges() -> Bool {
    if self._rangesAndValues.count < 2 { return true }
    for ii in 0..<(self._rangesAndValues.count - 2) {
      let range0 = self._rangesAndValues[ii].range
      let range1 = self._rangesAndValues[ii + 1].range
      if range0.isEmpty || range1.isEmpty { return false }
      guard range0 < range1 && !range0.overlaps(range1) else { return false }
    }
    return true
  }
  
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
    assert(_validateRanges())
  }
  
  private func _index(whereRangeContains element: Bound) -> Int? {
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
  
  public subscript(_ index: Index) -> Value {
    get {
      return self._rangesAndValues[index._index].value
    }
    set {
      self._rangesAndValues[index._index].value = newValue
    }
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
    if self._rangesAndValues.isEmpty { return .insertable(0) }
    
    let numberOfPairs = self._rangesAndValues.count
    
    var overlap_first: Int? = nil
    
    for ii in 0..<numberOfPairs {
      let targetRange = self._rangesAndValues[ii].range
      if targetRange.overlaps(range) {
        overlap_first = ii
        break
      }
      
      let bounds = range.bounds!
      if targetRange.bounds!.upper._compare(bounds.lower, side: .upper) == .orderedAscending {
        func _next() -> _Pair? {
          if ii == numberOfPairs - 1 { return nil }
          return self._rangesAndValues[ii + 1]
        }
        let next = _next()
        if next == nil || next!.range.bounds!.lower._compare(bounds.upper, side: .lower) == .orderedDescending {
          return .insertable(ii + 1)
        }
      }
    }
    
    assert(overlap_first != nil)
    
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
    let splitted = self._splitted(by: range)
    self._rangesAndValues = Array<_Pair>(splitted.0 + splitted.1)
    assert(_validateRanges())
  }
  
  /// Inserts the given value for the range.
  public mutating func insert(_ value: Value, forRange range: AnyRange<Bound>) {
    let splitted = self._splitted(by: range)
    self._rangesAndValues = Array<_Pair>(splitted.0)
    self._rangesAndValues.append((range: range, value: value))
    self._rangesAndValues.append(contentsOf: splitted.1)
    assert(_validateRanges())
  }
}


extension RangeDictionary: ExpressibleByDictionaryLiteral {
  public typealias Key = AnyRange<Bound>
  public init(dictionaryLiteral elements: (AnyRange<Bound>, Value)...) {
    self.init()
    for pair in elements {
      self.insert(pair.1, forRange: pair.0)
    }
  }
}

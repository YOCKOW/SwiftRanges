/***************************************************************************************************
 AnyRange+Hashable.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension PartialRangeFrom: Hashable where Bound: Hashable {
  public var hashValue: Int { return self.lowerBound.hashValue }
}

extension PartialRangeThrough: Hashable where Bound: Hashable {
  public var hashValue: Int { return self.upperBound.hashValue }
}

extension PartialRangeUpTo: Hashable where Bound: Hashable {
  public var hashValue: Int { return self.upperBound.hashValue }
}

extension AnyRange: Hashable where Bound: Hashable {
  public var hashValue:Int {
    switch self._range {
    case .empty: return 0
    case .unboundedRange: return Int.max
    case .closedRange(let range): return range.hashValue
    case .leftOpenRange(let range): return range.hashValue
    case .openRange(let range): return range.hashValue
    case .range(let range): return range.hashValue
    case .partialRangeFrom(let range): return range.hashValue
    case .partialRangeGreaterThan(let range): return range.hashValue
    case .partialRangeThrough(let range): return range.hashValue
    case .partialRangeUpTo(let range): return range.hashValue
    }
  }
}

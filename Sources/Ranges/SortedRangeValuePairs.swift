/* *************************************************************************************************
 SortedRangeValuePairs.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */


internal struct _SortedRangeValuePairs<Bound, Value> where Bound: Comparable {
  enum _Storage {
    case pairs([(range: any GeneralizedRange<Bound> & Sendable, value: Value)])
    case ranges([any GeneralizedRange<Bound> & Sendable])
  }

  private var _storage: _Storage

  init(carefullySortedPairs pairs: [(range: any GeneralizedRange<Bound> & Sendable, value: Value)]) {
    self._storage = .pairs(pairs)
    assert(self._storage.validateRanges())
  }
}

typealias _SortedRanges<Bound> = _SortedRangeValuePairs<Bound, Never> where Bound: Comparable

extension _SortedRangeValuePairs where Value == Never {
  init(carefullySortedRanges ranges: [any GeneralizedRange<Bound> & Sendable]) {
    self._storage = .ranges(ranges)
    assert(self._storage.validateRanges())
  }
}

extension _SortedRangeValuePairs._Storage: Sendable where Value: Sendable {}
extension _SortedRangeValuePairs: Sendable where Value: Sendable {}

extension _SortedRangeValuePairs._Storage {
  @inlinable
  var count: Int {
    switch self {
    case .pairs(let pairs):
      return pairs.count
    case .ranges(let ranges):
      return ranges.count
    }
  }

  @inlinable
  func range(at index: Int) -> any GeneralizedRange<Bound> & Sendable {
    switch self {
    case .pairs(let pairs):
      return pairs[index].range
    case .ranges(let ranges):
      return ranges[index]
    }
  }

  @inlinable
  func value(at index: Int) -> Value? {
    switch self {
    case .pairs(let pairs):
      return pairs[index].value
    case .ranges:
      return nil
    }
  }

  func validateRanges() -> Bool {
    let count = self.count
    switch count {
    case 0:
      return true
    case 1:
      return !self.range(at: 0).isEmpty
    default:
      break
    }

    assert(count > 1)
    for ii in 0..<(count - 1) {
      let range0 = range(at: ii)
      let range1 = range(at: ii + 1)
      guard (
        !range0.isEmpty &&
        !range1.isEmpty &&
        range0.compare(range1) == .orderedAscending &&
        !range0.overlaps(range1)
      ) else {
        return false
      }
    }
    return true
  }
}

extension _SortedRangeValuePairs {
  @inlinable
  var count: Int { _storage.count }

  @inlinable
  func range(at index: Int) -> any GeneralizedRange<Bound> & Sendable { _storage.range(at: index) }

  @inlinable
  func value(at index: Int) -> Value? { _storage.value(at: index) }
}

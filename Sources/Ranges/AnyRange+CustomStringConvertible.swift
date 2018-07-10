/***************************************************************************************************
 AnyRange+CustomStringConvertible.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension PartialRangeFrom: CustomStringConvertible {
  public var description: String {
    return "\(self.lowerBound)..."
  }
}

extension PartialRangeThrough: CustomStringConvertible {
  public var description: String {
    return "...\(self.upperBound)"
  }
}

extension PartialRangeUpTo: CustomStringConvertible {
  public var description: String {
    return "..<\(self.upperBound)"
  }
}

extension AnyRange: CustomStringConvertible {
  public var description: String {
    switch self._range {
    case .empty:
      return "(empty range)"
    case .unboundedRange:
      return "..."
      
    case .closedRange(let range):
      return range.description
    case .leftOpenRange(let range):
      return range.description
    case .openRange(let range):
      return range.description
    case .range(let range):
      return range.description
      
    case .partialRangeFrom(let range):
      return range.description
    case .partialRangeGreaterThan(let range):
      return range.description
    case .partialRangeThrough(let range):
      return range.description
    case .partialRangeUpTo(let range):
      return range.description
      
    }
  }
  
}

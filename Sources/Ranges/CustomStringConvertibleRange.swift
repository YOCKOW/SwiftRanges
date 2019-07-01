/***************************************************************************************************
 CustomStringConvertibleRange.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
public protocol CustomStringConvertibleRange: CustomStringConvertible, GeneralizedRange
  where Bound: CustomStringConvertible {}

extension CustomStringConvertibleRange {
  public var description: String {
    guard let bounds = self.bounds else {
      return "()"
    }
    
    var desc = ""
    
    switch bounds.lower {
    case .unbounded:
      desc += ".."
    case .included(let lower):
      desc += "\(lower.description).."
    case .excluded(let lower):
      desc += "\(lower.description)<."
    }
    
    switch bounds.upper {
    case .unbounded:
      desc += ".."
    case .included(let upper):
      desc += ".\(upper.description)"
    case .excluded(let upper):
      if case .excluded = bounds.lower {
        desc += ".<\(upper.description)"
      } else {
        desc += "<\(upper.description)"
      }
    }
    
    return desc
  }
}

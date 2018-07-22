/***************************************************************************************************
 CustomStringConvertibleRange.swift
   © 2018 YOCKOW.
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
    
    if let lower = bounds.lower {
      desc += lower.bound.description
      desc += lower.isIncluded ? ".." : "<."
    } else {
      desc += ".."
    }
    
    if let upper = bounds.upper {
      desc += upper.isIncluded ? "." : "<"
      desc += upper.bound.description
    } else {
      desc += "."
    }
    
    return desc
  }
}

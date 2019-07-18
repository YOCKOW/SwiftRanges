/***************************************************************************************************
 HashableRange.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
public protocol HashableRange: Hashable, GeneralizedRange where Bound:Hashable {}

// default implementation
extension HashableRange  {
  public static func ==(lhs:Self, rhs:Self) -> Bool {
    return lhs.compare(rhs) == .orderedSame
  }
  
  public func hash(into hasher:inout Hasher) {
    hasher.combine(0)
    if let bounds = self.bounds {
      hasher.combine(bounds.lower)
      hasher.combine(bounds.upper)
    }
  }
}

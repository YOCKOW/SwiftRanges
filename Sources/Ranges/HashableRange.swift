/***************************************************************************************************
 HashableRange.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
public protocol HashableRange: Hashable, GeneralizedRange where Bound:Hashable {}

// default implementation
extension HashableRange  {
  public static func ==(lhs:Self, rhs:Self) -> Bool {
    return lhs.compare(rhs) == .orderedSame
  }
  
  #if swift(>=4.2)
  public func hash(into hasher:inout Hasher) {
    hasher.combine(0)
    if let bounds = self.bounds {
      hasher.combine(bounds.lower)
      hasher.combine(bounds.upper)
    }
  }
  #else
  public var hashValue: Int {
    var hh: Int = 0
    if let bounds = self.bounds {
      hh ^= bounds.lower?.hashValue ?? Int.min
      hh ^= bounds.upper?.hashValue ?? Int.max
    }
    return hh
  }
  #endif
}

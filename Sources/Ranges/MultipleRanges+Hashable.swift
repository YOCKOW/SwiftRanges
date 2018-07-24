/***************************************************************************************************
 MultipleRanges+Hashable.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
extension MultipleRanges: Hashable where Bound:Hashable {
  #if swift(>=4.2)
  public func hash(into hasher:inout Hasher) {
    for range in self.ranges {
      hasher.combine(range)
    }
  }
  #else
  public var hashValue: Int {
    var hh = 0
    for range in self.ranges {
      hh ^= range.hashValue
    }
    return hh
  }
  #endif
}

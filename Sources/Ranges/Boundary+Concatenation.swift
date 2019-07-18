/* *************************************************************************************************
 Boundary+Concatenation.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
extension Boundary {
  /// Returns whether the two points are concatenatable or not.
  /// **`self` must be upper bound.**
  /// - parameter otherLowerBound: The lower bound of another range.
  internal func __isConcatenatable(with otherLowerBound: Boundary<Value>) -> Bool {
    // always concatenatable when self or the lower bound is .unbounded
    guard let myValue = self.value, let otherLowerValue = otherLowerBound.value else { return true }
    
    
    // Check if
    // ------/
    //    /-------
    if myValue < otherLowerValue { return false }
    if myValue > otherLowerValue { return true }
    
    // if myValue == otherLowerValue
    if case (.excluded, .excluded) = (self, otherLowerBound) { return false }
    return true
  }
  
  /// Returns whether the two points are concatenatable or not.
  internal func _isConcatenatable(with otherLowerBound: Boundary<Value>) -> Bool {
    return self.__isConcatenatable(with: otherLowerBound)
  }
}

extension Boundary where Value: Strideable, Value.Stride: SignedInteger {
  /// Returns whether the two points are concatenatable or not.
  /// They are considered as **countable**.
  internal func _isConcatenatable(with otherLowerBound: Boundary<Value>) -> Bool {
    switch (self, otherLowerBound) {
    case (.included(let myValue), .included(let otherValue)):
      if myValue.distance(to: otherValue) <= 1 { return true }
      return false
    default:
      return self.__isConcatenatable(with: otherLowerBound)
    }
  }
}


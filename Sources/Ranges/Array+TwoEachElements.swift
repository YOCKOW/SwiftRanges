/* *************************************************************************************************
 Array+TwoEachElements.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
 
extension Array {
  /// Don't let the index be out of bounds.
  internal func _twoElements(from index: Int) -> (Element, Element) {
    return (self[index], self[index + 1])
  }
}


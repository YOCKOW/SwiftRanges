/* *************************************************************************************************
 WellknownRange.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

/// A range type that is defined in Standard Library or this module.
///
/// - Note: This type is expected to be `Sendable` if `Bound` is `Sendable`.
private protocol _WellknownRange<Bound>: GeneralizedRange {}

extension ClosedRange: _WellknownRange {}
extension EmptyRange: _WellknownRange {}
extension LeftOpenRange: _WellknownRange {}
extension OpenRange: _WellknownRange {}
extension Range: _WellknownRange {}
extension PartialRangeFrom: _WellknownRange {}
extension PartialRangeGreaterThan: _WellknownRange {}
extension PartialRangeThrough: _WellknownRange {}
extension PartialRangeUpTo: _WellknownRange {}
extension TangibleUnboundedRange: _WellknownRange {}

extension GeneralizedRange {
  internal var _wellknownRange: any GeneralizedRange<Bound> {
    if self is any _WellknownRange {
      return self
    }

    guard let bounds = self.bounds else {
      return EmptyRange<Bound>()
    }
    let range = _makeRange(uncheckedBounds: bounds)
    assert(range is any _WellknownRange)
    return range
  }
}

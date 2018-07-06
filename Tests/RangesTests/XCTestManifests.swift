import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(AnyRangeTests.allTests),
    testCase(ExcludedLowerBoundTests.allTests),
    testCase(ExistingRanges_OverlapTests.allTests),
    testCase(LeftOpenRangeTests.allTests),
    testCase(OpenRangeTests.allTests),
    testCase(OverlapTests.allTests),
    testCase(PartialRangeGreaterThanTests.allTests),
  ]
}
#endif


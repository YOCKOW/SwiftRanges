import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(BoundaryTests.allTests),
    testCase(ExcludedLowerBoundTests.allTests),
    
    testCase(LeftOpenRangeTests.allTests),
    testCase(OpenRangeTests.allTests),
    testCase(PartialRangeGreaterThanTests.allTests),
  ]
}
#endif


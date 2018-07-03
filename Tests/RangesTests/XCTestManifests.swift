import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(ExcludedLowerBoundTests.allTests),
    testCase(LeftOpenRangeTests.allTests),
  ]
}
#endif


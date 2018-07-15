import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(BoundaryTests.allTests),
    testCase(ExcludedLowerBoundTests.allTests),
  ]
}
#endif


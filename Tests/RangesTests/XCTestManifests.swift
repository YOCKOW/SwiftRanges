#if !canImport(ObjectiveC)
import XCTest

extension AnyRangeTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AnyRangeTests = [
        ("test_asRangeExpression", test_asRangeExpression),
        ("test_intersection", test_intersection),
        ("test_subtraction", test_subtraction),
    ]
}

extension BoundaryTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__BoundaryTests = [
        ("test_comparison", test_comparison),
        ("test_initialization", test_initialization),
    ]
}

extension ExcludedLowerBoundTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ExcludedLowerBoundTests = [
        ("test_functions", test_functions),
    ]
}

extension GeneralizedRangeTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__GeneralizedRangeTests = [
        ("test_comparison", test_comparison),
        ("test_concatenation", test_concatenation),
        ("test_intersection", test_intersection),
        ("test_overlaps", test_overlaps),
        ("test_subtraction", test_subtraction),
    ]
}

extension LeftOpenRangeTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LeftOpenRangeTests = [
        ("test_asGeneralizedRange", test_asGeneralizedRange),
        ("test_asRangeExpression", test_asRangeExpression),
    ]
}

extension MultipleRangesTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MultipleRangesTests = [
        ("test_countableIntersection", test_countableIntersection),
        ("test_intersection", test_intersection),
        ("test_normalization", test_normalization),
        ("test_subtraction", test_subtraction),
    ]
}

extension OpenRangeTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__OpenRangeTests = [
        ("test_asGeneralizedRange", test_asGeneralizedRange),
        ("test_asRangeExpression", test_asRangeExpression),
        ("test_emptiness", test_emptiness),
    ]
}

extension PartialRangeGreaterThanTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PartialRangeGreaterThanTests = [
        ("test_asGeneralizedRange", test_asGeneralizedRange),
        ("test_asRangeExpression", test_asRangeExpression),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AnyRangeTests.__allTests__AnyRangeTests),
        testCase(BoundaryTests.__allTests__BoundaryTests),
        testCase(ExcludedLowerBoundTests.__allTests__ExcludedLowerBoundTests),
        testCase(GeneralizedRangeTests.__allTests__GeneralizedRangeTests),
        testCase(LeftOpenRangeTests.__allTests__LeftOpenRangeTests),
        testCase(MultipleRangesTests.__allTests__MultipleRangesTests),
        testCase(OpenRangeTests.__allTests__OpenRangeTests),
        testCase(PartialRangeGreaterThanTests.__allTests__PartialRangeGreaterThanTests),
    ]
}
#endif

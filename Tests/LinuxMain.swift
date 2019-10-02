import XCTest

import DiffTests

var tests = [XCTestCaseEntry]()
tests += DiffTests.__allTests()

XCTMain(tests)

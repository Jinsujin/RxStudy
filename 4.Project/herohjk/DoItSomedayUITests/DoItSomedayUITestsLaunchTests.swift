//
//  DoItSomedayUITestsLaunchTests.swift
//  DoItSomedayUITests
//
//  Created by 김호종 on 2022/01/10.
//

import XCTest
// swiftlint:disable overridden_super_call
class DoItSomedayUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
// swiftlint:enable overridden_super_call

/**
    EnvTests.swift
    EnvTests
 
    Created by Tibor Bödecs on 2019.01.01.
    Copyright Binary Birds. All rights reserved.
 */

import XCTest
@testable import EnvKit

final class EnvTests: XCTestCase {

    static var allTests = [
        ("testEnv", testEnv),
        ("testLoad", testLoad),
        ("testSave", testSave),
        ("testSubscript", testSubscript),
    ]
    
    // MARK: - helpers
    
    private func assert<T: Equatable>(type: String, result: T, expected: T) {
        XCTAssertEqual(result, expected, "Invalid \(type) `\(result)`, expected `\(expected)`.")
    }

    // MARK: - setUp & tearDown NOTE: don't run parallel tests
    
    var env: Env!
    
    override func setUp() {
        super.setUp()

        do {
            self.env = try Env(["env-key": "env-value"])
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }

    override func tearDown() {
        super.tearDown()

        do {
            try self.env.destroy()

            guard
                self.env["env-key"] == nil,
                ProcessInfo.processInfo.environment["env-key"] == nil,
                !FileManager.default.fileExists(atPath: self.env.fileUrl.path)
            else {
                return XCTFail("Environment is not destroyed.")
            }
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }

    // MARK: - tests

    func testEnv() {
        guard let value = ProcessInfo.processInfo.environment["env-key"] else {
            return XCTFail("Environment variable `env-key` should alreayd be present.")
        }
        self.assert(type: "value", result: value, expected: "env-value")
    }
    
    func testLoad() throws {
        let env = try Env()
        try env.load()

        self.assert(type: "variables", result: env.variables, expected: self.env.variables)
    }
    
    func testSave() throws {
        let env1 = try Env()
        env1["env-save-key"] = "env-save-value"
        try env1.save()

        let env2 = try Env()

        self.assert(type: "variables", result: env2.variables, expected: env1.variables)
    }
    
    func testSubscript() throws {
        let env1 = try Env()
        env1["env-sub-key"] = "env-sub-value"
        guard let value = ProcessInfo.processInfo.environment["env-sub-key"] else {
            return XCTFail("Environment variable `env-sub-key` should alreayd be present.")
        }
        self.assert(type: "value", result: value, expected: "env-sub-value")
        self.assert(type: "value", result: env1["env-sub-key"], expected: "env-sub-value")
        
        env1["env-sub-key"] = nil
        
        guard env1["env-sub-key"] == nil, ProcessInfo.processInfo.environment["env-sub-key"] == nil else {
            return XCTFail("Environment variable `env-sub-key` should be `nil`.")
        }
    }
}

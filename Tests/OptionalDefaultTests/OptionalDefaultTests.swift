//
//  OptionalDefaultTests.swift
//  OptionalDefault
//
//  Created by Alexey Demin on 2025-11-15.
//  Copyright © 2025 DnV1eX. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(OptionalDefaultMacros)
import OptionalDefaultMacros

let testMacros: [String: Macro.Type] = [
    "OptionalDefault": OptionalDefaultMacro.self,
]
#endif

final class OptionalDefaultTests: XCTestCase {
    func testMacroWithBool() throws {
        #if canImport(OptionalDefaultMacros)
        assertMacroExpansion(
            """
            @OptionalDefault var b: Bool = false
            """,
            expandedSource: """
            var b: Bool {
                get {
                    _b ?? false
                }
                set {
                    _b = (newValue == false) ? nil : newValue
                }
            }

            private var _b: Bool?
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithString() throws {
        #if canImport(OptionalDefaultMacros)
        assertMacroExpansion(
            """
            @OptionalDefault var s: String = ""
            """,
            expandedSource: """
            var s: String {
                get {
                    _s ?? ""
                }
                set {
                    _s = (newValue == "") ? nil : newValue
                }
            }

            private var _s: String?
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

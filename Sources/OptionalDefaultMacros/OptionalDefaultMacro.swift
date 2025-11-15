//
//  OptionalDefaultMacro.swift
//  OptionalDefault
//
//  Created by Alexey Demin on 2025-11-15.
//  Copyright © 2025 DnV1eX. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `OptionalDefault` macro.
public struct OptionalDefaultMacro: AccessorMacro, PeerMacro {

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        guard let property = declaration.as(VariableDeclSyntax.self),
              let binding = property.bindings.first,
              let propertyName = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              let defaultValue = binding.initializer?.value else {
            throw MacroError.missingInitialValue
        }
        return [
            "get { _\(raw: propertyName) ?? \(defaultValue) }",
            "set { _\(raw: propertyName) = (newValue == \(defaultValue)) ? nil : newValue }"
        ]
    }

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let property = declaration.as(VariableDeclSyntax.self),
              let binding = property.bindings.first,
              let propertyName = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              let propertyType = binding.typeAnnotation?.type.trimmedDescription else {
            throw MacroError.missingTypeAnnotation
        }
        return [
            "private var _\(raw: propertyName): \(raw: propertyType)?"
        ]
    }
}

enum MacroError: Error, CustomStringConvertible {
    case missingTypeAnnotation
    case missingInitialValue

    var description: String {
        switch self {
        case .missingTypeAnnotation:
            "Properties using this macro must have an explicit type annotation."
        case .missingInitialValue:
            "Properties using this macro must have an initial value assigned."
        }
    }
}

@main
struct OptionalDefaultPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        OptionalDefaultMacro.self,
    ]
}

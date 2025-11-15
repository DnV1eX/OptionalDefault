//
//  OptionalDefault.swift
//  OptionalDefault
//
//  Created by Alexey Demin on 2025-11-15.
//  Copyright © 2025 DnV1eX. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//

/// A macro that allows a non-optional property with a default value to be encoded
/// and decoded as an *optional*, so that its default value is omitted from the
/// encoded payload.
///
/// This is useful when you want a property to behave like a normal, non-optional
/// value in Swift, but still avoid encoding it unless it was explicitly set.
///
/// ## Example
///
///     @OptionalDefault var flag: Bool = false
///
/// The macro generates a private optional backing storage:
///
///     private var _flag: Bool?
///
/// To use this backing storage for `Codable`, map the coding key to the
/// synthesized storage property:
///
///     enum CodingKeys: String, CodingKey {
///         case _flag = "flag"
///     }
///
/// The public property (`flag`) remains non-optional and uses the provided
/// default when the optional storage is `nil`.
@attached(accessor)
@attached(peer, names: prefixed(_))
public macro OptionalDefault() = #externalMacro(module: "OptionalDefaultMacros", type: "OptionalDefaultMacro")

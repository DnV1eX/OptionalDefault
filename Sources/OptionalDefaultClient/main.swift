//
//  main.swift
//  OptionalDefault
//
//  Created by Alexey Demin on 2025-11-15.
//  Copyright © 2025 DnV1eX. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//

import OptionalDefault

enum E: Codable {
    case a, b
}
struct S: Codable {
    @OptionalDefault var e: E = .a
}

let s = S()
print(s.e)

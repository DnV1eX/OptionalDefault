# `OptionalDefault` Macro

A Swift macro that lets you declare a **non-optional property with a default value**, while storing its actual value as an **optional**.
This allows the property to behave normally in Swift while **omitting it during encoding/decoding** when its value matches the default.

```swift
@OptionalDefault var flag: Bool = false
```

Expands to:

```swift
private var _flag: Bool?

var flag: Bool {
    get { _flag ?? false }
    set { _flag = (newValue == false) ? nil : newValue }
}
```

For `Codable`, map the coding key to the synthesized storage variable:

```swift
enum CodingKeys: String, CodingKey {
    case _flag = "flag"
}
```

---

## Example: Encoding and Decoding Behavior

Consider:

```swift
struct Settings: Codable {
    @OptionalDefault var shouldShowHints: Bool = true
    @OptionalDefault var retries: Int = 0
    var username: String

    enum CodingKeys: String, CodingKey {
        case _shouldShowHints = "shouldShowHints"
        case _retries = "retries"
        case username
    }
}
```

### Encoding example

```swift
let settings = Settings(username: "bob")
let json = try JSONEncoder().encode(settings)
```

Resulting JSON (omits properties matching their defaults):

```json
{
  "username": "bob"
}
```

If a value differs from the default:

```swift
var settings = Settings(username: "bob")
settings.retries = 3
```

Resulting JSON:

```json
{
  "username": "bob",
  "retries": 3
}
```

### Decoding example

Given JSON that omits default-valued keys:

```json
{
  "username": "alice"
}
```

Decoding:

```swift
let data = /* JSON above */
let settings = try JSONDecoder().decode(Settings.self, from: data)
```

Result:

```swift
settings.username        // "alice"
settings.shouldShowHints // true (default)
settings.retries         // 0 (default)
```

---

## Installation

To add the package to your Xcode project, open `File -> Add Package Dependencies...` and search for the URL:
```
https://github.com/DnV1eX/OptionalDefault.git
```
Then, simply **import OptionalDefault** and add the **@OptionalDefault** attribute before the target var.

> [!WARNING]
> Xcode may ask to `Trust & Enable` the macro on first use or after an update.

---

## Limitations

Current constraints to keep in mind:

* Only **stored `var` properties** with an initializer are supported (computed properties and `let` are not)
* Prefer **literals**, **enum cases**, and **static constants/variables** as default values for the most predictable behavior
* The property type must be **Equatable**, since the setter compares the value to the default
* Multi-binding declarations are not supported
* The generated storage property currently uses **private** visibility

---

## Roadmap

* Better validation of default values
* Optional automatic coding key generation
* Improved diagnostics for unsupported property patterns
* Configurable access control for generated storage

---

## References

Try my other Swift macros:

- [`@EnumOptionSet`](https://github.com/DnV1eX/EnumOptionSet) - declare option sets using an enumeration notation.
- [`@EnumRawValues`](https://github.com/DnV1eX/EnumRawValues) - enables full-fledged raw values for enumerations.

> [!IMPORTANT]
> I hope you enjoy the project and find it useful. Please bookmark it with ⭐️ and feel free to share your feedback. Thank you!

---

## License
Copyright © 2025 DnV1eX. All rights reserved. Licensed under the Apache License, Version 2.0.

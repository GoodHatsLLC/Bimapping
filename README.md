# Bimapping

`Bimapping` is a Swift DSL (result builder) for defining bidirectional model transformations.

`Bimapping` is a core component of the [Projection](https://github.com/GoodHatsLLC/Projection)
bidirectional mapping library.  
`Projection` is a more flexible version of SwiftUI's `Binding`. It allows expressing more complex model relationships.

## Example

`Bimapping` can be used independent of the `Projection` library to make `Bimapper` transformers.

```swift
import Bimapping

struct SV_siffror: Equatable {
    var noll = "0"
    var ett = "1"
    var två = "2"
    var tre = "3"
}

struct EN_numbers: Equatable {
    var zero = "0"
    var one = "1"
    var two = "2"
    var three = "3"
}

var sv = SV_siffror()
var en = EN_numbers()

let map = Bimapper<SV_siffror, EN_numbers> { from, to in
    from.noll <-> to.zero
    from.ett <-> to.one
    from.två <-> to.two
    from.tre <-> to.three
}

// Set the upstream values
sv.noll = "000"
sv.ett = "001"
sv.två = "010"
sv.tre = "011"

// Trigger mapping into the downstream
map.update(b: &en, from: sv)

XCTAssertEqual(en.zero, "000")
XCTAssertEqual(en.one, "001")
XCTAssertEqual(en.two, "010")
XCTAssertEqual(en.three, "011")

// Changes to the downstream can similarly be mapped upstream
// map.update(a: &sv, from: en)
```

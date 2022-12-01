import XCTest
import Bimapping

@MainActor
class BimappingTests: XCTestCase {
    struct SV_siffror: Equatable {
        var noll = "0"
        var ett = "1"
        var två = "2"
        var tre = "3"
        var fyra = "4"
    }

    struct EN_numbers: Equatable {
        var zero = "0"
        var one = "1"
        var two = "2"
        var three = "3"
        var four = "4"
    }

    struct Letters: Equatable {
        var a = "0"
        var b = "1"
        var c = "2"
        var d = "3"
        var e = "4"

    }

    func test_builder_bijection() throws {
        var sv = SV_siffror()
        var en = EN_numbers()

        let map = Bimapper<SV_siffror, EN_numbers> { from, to in
            from.noll <-> to.zero
            from.ett <-> to.one
            from.två <-> to.two
            from.tre <-> to.three
            from.fyra <-> to.four
        }

        // Modify forwards to binary
        sv.noll = "000"
        sv.ett = "001"
        sv.två = "010"
        sv.tre = "011"
        sv.fyra = "100"

        map.update(b: &en, from: sv)

        XCTAssertEqual(en.zero, "000")
        XCTAssertEqual(en.one, "001")
        XCTAssertEqual(en.two, "010")
        XCTAssertEqual(en.three, "011")
        XCTAssertEqual(en.four, "100")

        // Backwards to squares
        en.zero = "0"
        en.one = "1"
        en.two = "4"
        en.three = "9"
        en.four = "16"

        map.update(a: &sv, from: en)

        XCTAssertEqual(sv.noll, "0")
        XCTAssertEqual(sv.ett, "1")
        XCTAssertEqual(sv.två, "4")
        XCTAssertEqual(sv.tre, "9")
        XCTAssertEqual(sv.fyra, "16")
    }

    func test_builder_compoundBijection() throws {
        var sv = SV_siffror()
        var en = EN_numbers()
        var letters = Letters()

        let map = Bimapper<SV_siffror, EN_numbers> { from, to in
            from.noll <-> to.zero
            from.ett <-> to.one
            from.två <-> to.two
            from.tre <-> to.three
            from.fyra <-> to.four
        }
        .extend(
            with: Bimapper<EN_numbers, Letters> { from, to in
                from.zero <-> to.a
                from.one <-> to.b
                from.two <-> to.c
                from.three <-> to.d
                from.four <-> to.e
            },
            intermediate: (getter: { en }, setter: { en = $0 })
        )

        // Modify forwards to binary
        sv.noll = "000"
        sv.ett = "001"
        sv.två = "010"
        sv.tre = "011"
        sv.fyra = "100"

        map.update(b: &letters, from: sv)

        XCTAssertEqual(letters.a, "000")
        XCTAssertEqual(letters.b, "001")
        XCTAssertEqual(letters.c, "010")
        XCTAssertEqual(letters.d, "011")
        XCTAssertEqual(letters.e, "100")

        // Backwards to squares
        letters.a = "0"
        letters.b = "1"
        letters.c = "4"
        letters.d = "9"
        letters.e = "16"

        map.update(a: &sv, from: letters)

        XCTAssertEqual(sv.noll, "0")
        XCTAssertEqual(sv.ett, "1")
        XCTAssertEqual(sv.två, "4")
        XCTAssertEqual(sv.tre, "9")
        XCTAssertEqual(sv.fyra, "16")
    }

    func test_builder_mixedBiMap() throws {
        var sv = SV_siffror()
        var en = EN_numbers()

        let map = Bimapper<SV_siffror, EN_numbers> { from, to in
            from.noll <-- to.zero
            from.ett <-> to.one
            from.två --> to.two
        }

        // Modify forwards
        sv.noll = "from_SV"
        sv.ett = "from_SV"
        sv.två = "from_SV"
        sv.tre = "from_SV"
        sv.fyra = "from_SV"

        map.update(b: &en, from: sv)

        // mapped values are unchanged, but for --> and <->
        XCTAssertEqual(en.zero, "0")
        // -->
        XCTAssertEqual(en.one, "from_SV")
        // <->
        XCTAssertEqual(en.two, "from_SV")
        XCTAssertEqual(en.three, "3")
        XCTAssertEqual(en.four, "4")

        // modify backwards
        en.zero = "from_EN"
        en.one = "from_EN"
        en.two = "from_EN"
        en.three = "from_EN"
        en.four = "from_EN"

        map.update(a: &sv, from: en)

        // mapped values are unchanged, but for <-- and <->
        // <--
        XCTAssertEqual(sv.noll, "from_EN")
        // <->
        XCTAssertEqual(sv.ett, "from_EN")
        XCTAssertEqual(sv.två, "from_SV")
        XCTAssertEqual(sv.tre, "from_SV")
        XCTAssertEqual(sv.fyra, "from_SV")
    }

    func test_funcMap() throws {
        var sv = SV_siffror()
        var en = EN_numbers()
        let map = Bimapper<SV_siffror, EN_numbers> { from, to in
            from.ett.map { $0.uppercased() } --> to.one
            from.två <-- to.two.map { $0.lowercased() }
        }

        map.update(b: &en, from: sv)

        XCTAssertEqual(en.one, "1")

        sv.ett = "yolo"
        en.two = "WHATEVER"

        map.update(b: &en, from: sv)
        map.update(a: &sv, from: en)

        XCTAssertEqual(en.one, "YOLO")
        XCTAssertEqual(sv.två, "whatever")
    }

    func test_funcJoin() throws {
        var sv = SV_siffror()
        var en = EN_numbers()

        let map = Bimapper<SV_siffror, EN_numbers> { from, to in

            let joinOne = from.noll.join(from.ett) { "\($0) \($1)" }
            let joinTwo = joinOne.join(from.två) { "\($0) \($1)" }

            joinTwo --> to.zero
        }

        map.update(b: &en, from: sv)

        XCTAssertEqual(en.zero, "0 1 2")

        sv.noll = "hello"
        sv.ett = "world!"
        sv.två = "🌍"

        map.update(b: &en, from: sv)

        XCTAssertEqual(en.zero, "hello world! 🌍")
    }

    func test_cyclicalMap_finishes() throws {
        var sv = SV_siffror()
        var en = EN_numbers()

        let map = Bimapper<SV_siffror, EN_numbers> { from, to in

            // The links just run in order, so no cycle is possible

            from.ett --> to.one
            from.ett <-- to.one

            from.två --> to.two
            from.tre <-- to.two
            from.tre --> to.three
            from.två <-- to.three
        }

        sv.ett = "11"
        sv.två = "22"

        map.update(b: &en, from: sv)

        en.two = "222"

        map.update(a: &sv, from: en)

        // Output is deterministic, even if input is badly formed
        XCTAssertEqual(SV_siffror(noll: "0", ett: "11", två: "3", tre: "222", fyra: "4"), sv)
        XCTAssertEqual(EN_numbers(zero: "0", one: "11", two: "222", three: "3", four: "4"), en)
    }

}

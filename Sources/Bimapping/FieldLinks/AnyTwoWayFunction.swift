public struct AnyTwoWayFunction<A, B>: TwoWayFunction {
    public init<F: TwoWayFunction<A, B>>(_ link: F) {
        bFromA = link.update(b:from:)
        aFromB = link.update(a:from:)
    }

    public func update(b: inout B, from a: A) {
        bFromA(&b, a)
    }

    public func update(a: inout A, from b: B) {
        aFromB(&a, b)
    }

    public func erase() -> AnyTwoWayFunction<A, B> {
        self
    }

    private let bFromA: (inout B, A) -> Void
    private let aFromB: (inout A, B) -> Void
}

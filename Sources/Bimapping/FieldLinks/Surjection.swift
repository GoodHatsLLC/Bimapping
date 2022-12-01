public struct Surjection<A, B>: TwoWayFunction {

    public init(aFromB: @escaping (inout A, B) -> Void) {
        self.aFromB = aFromB
    }

    public init<X>(
        _ aX: WritableKeyPath<A, X>,
        _ bX: KeyPath<B, X>
    ) {
        aFromB = { a, b in
            a[keyPath: aX] = b[keyPath: bX]
        }
    }

    public func update(b _: inout B, from _: A) {}

    public func update(a: inout A, from b: B) {
        aFromB(&a, b)
    }

    private let aFromB: (inout A, B) -> Void

}

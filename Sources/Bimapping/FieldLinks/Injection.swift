public struct Injection<A, B>: TwoWayFunction {

    public init(bFromA: @escaping (inout B, A) -> Void) {
        self.bFromA = bFromA
    }

    public init<X>(
        _ aX: KeyPath<A, X>,
        _ bX: WritableKeyPath<B, X>
    ) {
        bFromA = { b, a in
            b[keyPath: bX] = a[keyPath: aX]
        }
    }

    public func update(b: inout B, from a: A) {
        bFromA(&b, a)
    }

    public func update(a _: inout A, from _: B) {}

    private let bFromA: (inout B, A) -> Void

}

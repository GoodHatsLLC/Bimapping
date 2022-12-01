public struct Bijection<A, B>: TwoWayFunction {

    public init<X>(
        _ aX: WritableKeyPath<A, X>,
        _ bX: WritableKeyPath<B, X>
    ) {
        bFromA = { b, a in
            b[keyPath: bX] = a[keyPath: aX]
        }
        aFromB = { a, b in
            a[keyPath: aX] = b[keyPath: bX]
        }
    }

    public init(
        bFromA: @escaping (_ b: inout B, _ a: A) -> Void,
        aFromB: @escaping (_ a: inout A, _ b: B) -> Void
    ) {
        self.bFromA = bFromA
        self.aFromB = aFromB
    }

    public func update(b: inout B, from a: A) {
        bFromA(&b, a)
    }

    public func update(a: inout A, from b: B) {
        aFromB(&a, b)
    }

    private let bFromA: (inout B, A) -> Void
    private let aFromB: (inout A, B) -> Void

}

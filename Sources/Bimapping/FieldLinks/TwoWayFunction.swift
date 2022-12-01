// MARK: - TwoWayFunction

public protocol TwoWayFunction<A, B> {
    associatedtype A
    associatedtype B
    func update(b: inout B, from a: A)
    func update(a: inout A, from b: B)
}

extension TwoWayFunction {
    public func erase() -> AnyTwoWayFunction<A, B> {
        .init(self)
    }
}

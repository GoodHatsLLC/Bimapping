// MARK: - Bimapping

@resultBuilder
public enum Bimapping<A, B> {

    public static func buildExpression() -> [AnyTwoWayFunction<A, B>] {
        []
    }

    public static func buildExpression(_: ()) -> [AnyTwoWayFunction<A, B>] {
        []
    }

    public static func buildExpression<Function: TwoWayFunction<A, B>>(_ expression: Function)
        -> [AnyTwoWayFunction<A, B>]
    {
        [expression.erase()]
    }

    public static func buildBlock() -> [AnyTwoWayFunction<A, B>] {
        []
    }

    public static func buildPartialBlock(first: [AnyTwoWayFunction<A, B>]) -> [AnyTwoWayFunction<A, B>] {
        first
    }

    public static func buildPartialBlock(
        accumulated: [AnyTwoWayFunction<A, B>],
        next: [AnyTwoWayFunction<A, B>]
    ) -> [AnyTwoWayFunction<A, B>] {
        accumulated + next
    }

    public static func buildArray<Function: TwoWayFunction<A, B>>(_ components: [Function])
        -> [AnyTwoWayFunction<A, B>]
    {
        components.map { $0.erase() }
    }

    public static func buildFinalResult(_ links: [AnyTwoWayFunction<A, B>]) -> Bimapper<A, B> {
        Bimapper(paths: links)
    }

}

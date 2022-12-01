// MARK: - Bimapping

@resultBuilder
public enum Bimapping<A, B> {

  public static func buildExpression() -> some TwoWayFunction<A, B> {
    NoOp()
  }

  public static func buildExpression(_: ()) -> some TwoWayFunction<A, B> {
    NoOp()
  }

  public static func buildExpression(_ expression: some TwoWayFunction<A, B>)
    -> some TwoWayFunction<A, B>
  {
    expression
  }

  public static func buildBlock() -> some TwoWayFunction<A, B> {
    NoOp()
  }

  public static func buildPartialBlock(
    first: some TwoWayFunction<A, B>
  ) -> some TwoWayFunction<A, B> {
    first
  }

  public static func buildPartialBlock(
    accumulated: some TwoWayFunction<A, B>,
    next: some TwoWayFunction<A, B>
  ) -> some TwoWayFunction<A, B> {
    CompoundTwoWayFunction(head: next, tail: accumulated)
  }

  public static func buildFinalResult(
    _ twoFunc: some TwoWayFunction<A, B>
  ) -> Bimapper<A, B> {
    Bimapper(twoFunc)
  }

}

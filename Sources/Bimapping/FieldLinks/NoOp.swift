public struct NoOp<A, B>: TwoWayFunction {

  public init() {}

  public init(
    bFromA: @escaping (_ b: inout B, _ a: A) -> Void,
    aFromB: @escaping (_ a: inout A, _ b: B) -> Void
  ) {}

  public func update(b: inout B, from a: A) {}

  public func update(a: inout A, from b: B) {}

}

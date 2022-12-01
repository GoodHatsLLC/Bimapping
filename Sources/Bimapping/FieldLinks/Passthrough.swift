public struct Passthrough<A>: TwoWayFunction {

  public typealias B = A

  public init() {}

  public func update(b: inout B, from a: A) {
    b = a
  }

  public func update(a: inout A, from b: B) {
    a = b
  }

}

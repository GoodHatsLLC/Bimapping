// MARK: - BidirectionalTransform

public protocol BidirectionalTransform {
  associatedtype A
  associatedtype B
  func update(b: inout B, from a: A)
  func update(a: inout A, from b: B)
}

// MARK: - Bimapper

public struct Bimapper<A, B>: BidirectionalTransform {

  public init(
    @Bimapping<A, B> builder: (_ from: Path<A, A>, _ to: Path<B, B>) -> Bimapper<A, B>
  ) {
    self = builder(Path(), Path())
  }

  public init(_ twoFunc: some TwoWayFunction<A, B>) {
    self.bFromA = { twoFunc.update(b: &$0, from: $1) }
    self.aFromB = { twoFunc.update(a: &$0, from: $1) }
  }

  public init(
    bFromA: @escaping (inout B, A) -> Void,
    aFromB: @escaping (inout A, B) -> Void
  ) {
    self.bFromA = bFromA
    self.aFromB = aFromB
  }

  public func extend<C>(
    with extending: Bimapper<B, C>,
    intermediate: (getter: () -> B, setter: (B) -> Void)
  ) -> Bimapper<A, C> {
    Bimapper<A, C>(
      bFromA: { varC, a in
        var varB = intermediate.getter()
        bFromA(&varB, a)
        intermediate.setter(varB)
        extending.update(b: &varC, from: varB)
      },
      aFromB: { varA, c in
        var varB = intermediate.getter()
        extending.update(a: &varB, from: c)
        intermediate.setter(varB)
        aFromB(&varA, varB)
      }
    )
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

extension Bimapper {
  public static func passthrough<T>() -> Bimapper<T, T> {
    .init(Passthrough())
  }

  public static func none<A, B>() -> Bimapper<A, B> {
    .init(NoOp())
  }
}

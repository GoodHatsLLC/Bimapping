public struct CompoundTwoWayFunction<A, B, Head: TwoWayFunction, Tail: TwoWayFunction>:
  TwoWayFunction
where Head.A == A, Head.B == B, Tail.A == A, Tail.B == B {
  public func update(b: inout B, from a: A) {
    tail.update(b: &b, from: a)
    head.update(b: &b, from: a)
  }

  public func update(a: inout A, from b: B) {
    tail.update(a: &a, from: b)
    head.update(a: &a, from: b)
  }

  init(head: Head, tail: Tail) {
    self.head = head
    self.tail = tail
  }
  let head: Head
  let tail: Tail
}

// MARK: - FuncType

/// A one way function
public protocol FuncType<Root,Value> {
  associatedtype Root
  associatedtype Value
  var _map: (Root) -> Value { get }
}

extension FuncType {
  /// Join (two way) ``Path``s or (one way) ``Func``s into a derived one way ``Func``.
  public func join<OtherValue, OtherFunc: FuncType<Root, OtherValue>, NewValue>(
    _ other: OtherFunc,
    with transform: @escaping (Value, OtherValue) -> NewValue
  ) -> Func<Root, NewValue> {
    .init { root in
      transform(_map(root), other._map(root))
    }
  }

  /// Map a two-way ``Path``s into a derived one way ``Func``.
  public func map<NewValue>(
    _ transform: @escaping (Value) -> NewValue
  ) -> Func<Root, NewValue> {
    .init { root in
      transform(_map(root))
    }
  }

  /// flatMap a two-way ``Path``s into a derived one way ``Func``.
  public func flatMap<T: Identifiable, E>(
    _ transform: @escaping (E) -> [T]
  ) -> Func<Root, [T]> where Value: Sequence, E == Value.Element {
    .init { root in
      let value = _map(root)
      return value.flatMap { element in
        transform(element)
      }
    }
  }
}

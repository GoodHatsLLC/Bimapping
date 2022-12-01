@dynamicMemberLookup
public struct Func<Root, Value>: FuncType {

    init(_ transform: @escaping (Root) -> Value) {
        self._map = transform
    }

    public let _map: (Root) -> Value

    public subscript<NewValue>(
        dynamicMember dynamicMember: WritableKeyPath<Value, NewValue>
    ) -> Func<Root, NewValue> {
        .init { _map($0)[keyPath: dynamicMember] }
    }

    func asInjection() -> Injection<Root, Value> {
        Injection { b, a in
            b = _map(a)
        }
    }

}

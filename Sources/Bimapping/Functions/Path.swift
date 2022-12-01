/// A two way function
@dynamicMemberLookup
public struct Path<Root, Value>: FuncType {

    public init(_ keyPath: WritableKeyPath<Root, Root>) where Root == Value {
        self.keyPath = keyPath
    }

    private init(_ keyPath: WritableKeyPath<Root, Value>) {
        self.keyPath = keyPath
    }

    public var _map: (Root) -> Value {
        { $0[keyPath: keyPath] }
    }

    public subscript<NewValue>(
        dynamicMember dynamicMember: WritableKeyPath<Value, NewValue>
    ) -> Path<Root, NewValue> {
        .init(keyPath.appending(path: dynamicMember))
    }

    let keyPath: WritableKeyPath<Root, Value>

}

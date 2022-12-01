infix operator <-> : BitwiseShiftPrecedence
infix operator --> : BitwiseShiftPrecedence
infix operator <-- : BitwiseShiftPrecedence

public func --><Root, PairedRoot, Value>(
    lhs: some FuncType<Root, Value>,
    rhs: Path<PairedRoot, Value>
) -> Injection<Root, PairedRoot> {
    Injection { paired, root in
        paired[keyPath: rhs.keyPath] = lhs._map(root)
    }
}

public func <-><Root, PairedRoot, Value>(
    lhs: Path<Root, Value>,
    rhs: Path<PairedRoot, Value>
) -> Bijection<Root, PairedRoot> {
    Bijection(lhs.keyPath, rhs.keyPath)
}

public func <--<Root, PairedRoot, Value>(
    lhs: Path<Root, Value>,
    rhs: some FuncType<PairedRoot, Value>
) -> Surjection<Root, PairedRoot> {
    Surjection { root, paired in
        root[keyPath: lhs.keyPath] = rhs._map(paired)
    }
}

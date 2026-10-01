public struct Obligation: Equatable {
    public let id: UInt64
    public let amountDue: UInt64
    public let priority: UInt64

    public init(id: UInt64, amountDue: UInt64, priority: UInt64) {
        self.id = id
        self.amountDue = amountDue
        self.priority = priority
    }
}

public struct Line: Equatable {
    public let id: UInt64
    public let applied: UInt64

    public init(id: UInt64, applied: UInt64) {
        self.id = id
        self.applied = applied
    }
}

public struct Settlement: Equatable {
    public let lines: [Line]
    public let unapplied: UInt64

    public init(lines: [Line], unapplied: UInt64) {
        self.lines = lines
        self.unapplied = unapplied
    }
}

public enum SettleError: Error, Equatable {
    case duplicateId
    case notImplemented
}

public func settle(_ payment: UInt64, _ obligations: [Obligation]) throws -> Settlement {
    throw SettleError.notImplemented
}

extension Metrics.Request.Event {
    /// Adapter-neutral importance assigned by the request policy.
    public enum Severity: Equatable, Sendable {
        case trace
        case info
        case warning
        case error
    }
}

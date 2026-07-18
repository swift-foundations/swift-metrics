extension Metrics.Request {
    /// The canonical event emitted for a completed request.
    public struct Event: Equatable, Sendable {
        public let name: String
        public let method: String
        public let path: String
        public let statusCode: Int
        public let duration: Duration
        public let requestID: String?
        public let isStaticFile: Bool
        public let severity: Severity

        internal init(request: Metrics.Request, severity: Severity, isStaticFile: Bool) {
            self.name = "http.request"
            self.method = request.method
            self.path = request.path
            self.statusCode = request.statusCode
            self.duration = request.duration
            self.requestID = request.requestID
            self.isStaticFile = isStaticFile
            self.severity = severity
        }
    }
}

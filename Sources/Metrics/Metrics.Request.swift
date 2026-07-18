extension Metrics {
    /// The adapter-neutral facts available when a request has completed.
    public struct Request: Equatable, Sendable {
        public let method: String
        public let path: String
        public let statusCode: Int
        public let duration: Duration
        public let requestID: String?
        public let contentType: String?

        public init(
            method: String,
            path: String,
            statusCode: Int,
            duration: Duration,
            requestID: String? = nil,
            contentType: String? = nil
        ) {
            self.method = method
            self.path = path
            self.statusCode = statusCode
            self.duration = duration
            self.requestID = requestID
            self.contentType = contentType
        }
    }
}

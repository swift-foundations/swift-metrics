extension Metrics.Request {
    /// Pure policy for turning completed request facts into one metrics event.
    public struct Policy: Sendable {
        public let detectStaticFiles: Bool

        public init(detectStaticFiles: Bool = true) {
            self.detectStaticFiles = detectStaticFiles
        }

        public func event(for request: Metrics.Request) -> Event {
            let isStaticFile = detectStaticFiles && Self.isStaticFile(request)
            return Event(
                request: request,
                severity: Self.severity(for: request.statusCode, isStaticFile: isStaticFile),
                isStaticFile: isStaticFile
            )
        }

        private static func severity(
            for statusCode: Int,
            isStaticFile: Bool
        ) -> Event.Severity {
            if isStaticFile || statusCode == 304 {
                return .trace
            }
            switch statusCode {
            case 500...:
                return .error

            case 400..<500:
                return .warning

            default:
                return .info
            }
        }

        private static func isStaticFile(_ request: Metrics.Request) -> Bool {
            guard request.method == "GET" || request.method == "HEAD" else { return false }
            guard request.statusCode == 200 || request.statusCode == 304 else { return false }

            if let contentType = request.contentType {
                let staticContentTypes = [
                    "image/", "text/css", "application/javascript", "font/", "video/", "audio/",
                ]
                if staticContentTypes.contains(where: contentType.hasPrefix) {
                    return true
                }
            }

            let staticExtensions = [
                ".css", ".js", ".jpg", ".jpeg", ".png", ".gif", ".svg", ".ico",
                ".woff", ".woff2", ".ttf",
            ]
            return staticExtensions.contains(where: request.path.hasSuffix)
        }
    }
}

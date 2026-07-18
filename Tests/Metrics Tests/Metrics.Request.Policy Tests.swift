import Testing

@testable import Metrics

@Suite("Request metrics policy")
struct RequestPolicyTests {
    @Test("emits the canonical request event")
    func event() {
        let request = Metrics.Request(
            method: "GET",
            path: "/assets/app.js",
            statusCode: 200,
            duration: .milliseconds(42),
            requestID: "abc",
            contentType: "application/javascript"
        )

        let event = Metrics.Request.Policy().event(for: request)

        #expect(event.name == "http.request")
        #expect(event.method == "GET")
        #expect(event.path == "/assets/app.js")
        #expect(event.statusCode == 200)
        #expect(event.duration == .milliseconds(42))
        #expect(event.requestID == "abc")
        #expect(event.isStaticFile)
        #expect(event.severity == .trace)
    }

    @Test("classifies response status without an engine")
    func severity() {
        let policy = Metrics.Request.Policy(detectStaticFiles: false)

        #expect(policy.event(for: request(statusCode: 304)).severity == .trace)
        #expect(policy.event(for: request(statusCode: 404)).severity == .warning)
        #expect(policy.event(for: request(statusCode: 503)).severity == .error)
        #expect(policy.event(for: request(statusCode: 201)).severity == .info)
    }

    @Test("uses the extension fallback for static files")
    func staticFileExtensionFallback() {
        let request = Metrics.Request(
            method: "HEAD",
            path: "/assets/site.css",
            statusCode: 304,
            duration: .zero
        )

        let event = Metrics.Request.Policy().event(for: request)

        #expect(event.isStaticFile)
        #expect(event.severity == .trace)
    }

    @Test("does not classify non-GET requests as static files")
    func staticFileMethodGuard() {
        let request = Metrics.Request(
            method: "POST",
            path: "/assets/site.css",
            statusCode: 200,
            duration: .zero,
            contentType: "text/css"
        )

        #expect(!Metrics.Request.Policy().event(for: request).isStaticFile)
    }

    private func request(statusCode: Int) -> Metrics.Request {
        Metrics.Request(method: "GET", path: "/", statusCode: statusCode, duration: .milliseconds(1))
    }
}

import Flutter
import Testing

@testable import meili_flutter_car_ios

struct MeiliFlutterPluginTests {
    private final class ResultBox: @unchecked Sendable {
        var delivered: Any?
    }

    private func open(with arguments: [String: Any]) -> Any? {
        let box = ResultBox()
        MeiliFlutterPlugin().handle(
            FlutterMethodCall(methodName: "openMeiliViewController", arguments: arguments),
            result: { box.delivered = $0 }
        )
        return box.delivered
    }

    @Test(arguments: ["pre_prod", "production", "PROD", "", "staging"])
    func unknownEnvFailsOpenWithInvalidArgument(env: String) throws {
        var arguments = try ChannelContractFixture.params()
        arguments["env"] = env

        let error = try #require(open(with: arguments) as? FlutterError)

        #expect(error.code == "INVALID_ARGUMENT")
    }

    @Test
    func missingEnvFailsOpenWithInvalidArgument() throws {
        var arguments = try ChannelContractFixture.params()
        arguments["env"] = nil

        let error = try #require(open(with: arguments) as? FlutterError)

        #expect(error.code == "INVALID_ARGUMENT")
    }
}

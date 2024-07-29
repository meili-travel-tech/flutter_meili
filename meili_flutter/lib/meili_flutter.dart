import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

MeiliFlutterPlatform get _platform => MeiliFlutterPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}

import 'package:meili_flutter_platform_interface/src/method_channel_meili_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of meili_flutter must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `MeiliFlutter`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [MeiliFlutterPlatform] methods.
abstract class MeiliFlutterPlatform extends PlatformInterface {
  /// Constructs a MeiliFlutterPlatform.
  MeiliFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MeiliFlutterPlatform _instance = MethodChannelMeiliFlutter();

  /// The default instance of [MeiliFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelMeiliFlutter].
  static MeiliFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MeiliFlutterPlatform] when they register themselves.
  static set instance(MeiliFlutterPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}

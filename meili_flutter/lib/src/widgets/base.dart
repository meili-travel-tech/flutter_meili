import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meili_flutter/src/model/avail_params.dart';
import 'package:meili_flutter/src/model/flow_enum.dart';

/// A stateful widget that represents a Meili view.
///
/// This widget is responsible for creating the platform-specific view
/// using the specified flow type and other parameters.
class MeiliView extends StatefulWidget {
  /// Creates a new instance of [MeiliView].
  ///
  /// The [ptid], [currentFlow], [env], [availParams], [onBookingInfoUpdated],
  /// and [height] can be optionally provided.
  const MeiliView({
    Key? key,
    this.ptid,
    this.currentFlow,
    this.env,
    this.availParams,
    this.onBookingInfoUpdated,
    this.height,
  }) : super(key: key);

  /// The ptid (possibly partner ID) for the Meili view.
  final String? ptid;

  /// The current flow type for the Meili view.
  final FlowType? currentFlow;

  /// The environment for the Meili view (e.g., dev, prod).
  final String? env;

  /// The availability parameters for the Meili view.
  final AvailParams? availParams;

  /// Callback to handle booking information updates.
  final ValueChanged<Map<String, dynamic>>? onBookingInfoUpdated;

  /// The height of the Meili view.
  final double? height;

  @override
  _MeiliViewState createState() => _MeiliViewState();
}

class _MeiliViewState extends State<MeiliView> {
  @override
  Widget build(BuildContext context) {
    final creationParams = <String, dynamic>{
      'ptid': widget.ptid,
      'currentFlow': widget.currentFlow.toString().split('.').last,
      'env': widget.env,
      'availParams': widget.availParams?.toMap(),
    };

    final Widget platform;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      platform = UiKitView(
        viewType: 'flutter_meili/meili_view',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          final _channel = MethodChannel('flutter_meili/meili_view/$id');
          _channel.setMethodCallHandler((call) async {
            if (call.method == 'onBookingInfoUpdated' &&
                widget.onBookingInfoUpdated != null) {
              final arguments =
                  Map<String, dynamic>.from(call.arguments as Map);
              widget.onBookingInfoUpdated!(arguments);
            }
          });
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Placeholder for Android until the native implementation is available
      platform = const Center(
        child: Text(
          'Android platform view is not yet supported',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    } else {
      platform = const Center(
        child: Text(
          'Unsupported platform',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return widget.height != null
        ? SizedBox(
            height: widget.height,
            child: platform,
          )
        : platform;
  }
}

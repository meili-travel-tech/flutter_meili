import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

/// Default height for an embedded [MeiliView] when none is supplied.
const kViewDefaultHeight = 400.0;

/// Embeds the Meili experience inline as a platform view.
///
/// Runtime events (analytics, dismiss, end-of-flow) are delivered through the
/// shared `Meili.events` stream. For convenience, [onEvent] is invoked for
/// each event while this widget is mounted.
class MeiliView extends StatefulWidget {
  /// Creates an embedded Meili view.
  const MeiliView({
    super.key,
    this.ptid,
    this.flow,
    this.env,
    this.availParams,
    this.additionalParams,
    this.height,
    this.onEvent,
  });

  /// The ptid (partner/touchpoint id) for the Meili view.
  final String? ptid;

  /// The flow type to launch.
  final FlowType? flow;

  /// The environment (e.g. `dev`, `prod`).
  final String? env;

  /// Availability parameters.
  final AvailParams? availParams;

  /// Additional booking parameters.
  final AdditionalParams? additionalParams;

  /// Fixed height for the embedded view. Defaults to [kViewDefaultHeight].
  final double? height;

  /// Optional convenience callback invoked for each [MeiliEvent] while this
  /// widget is mounted. Equivalent to listening to `Meili.events`.
  final ValueChanged<MeiliEvent>? onEvent;

  @override
  State<MeiliView> createState() => _MeiliViewState();
}

class _MeiliViewState extends State<MeiliView> {
  static const String _viewType = 'flutter_meili/meili_view';
  StreamSubscription<MeiliEvent>? _eventSub;

  @override
  void initState() {
    super.initState();
    if (widget.onEvent != null) {
      _eventSub = MeiliFlutterPlatform.instance.events.listen(widget.onEvent);
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flowName = (widget.flow ?? FlowType.direct).name;
    // Send both key spellings so both native sides resolve them unchanged:
    // iOS reads `flow`/`additionalParams`; Android reads `currentFlow`/`bookingParams`.
    final availParamsMap = widget.availParams?.toMap();
    final additionalParamsMap = widget.additionalParams?.toMap();
    final creationParams = <String, dynamic>{
      'ptid': widget.ptid,
      'flow': flowName,
      'currentFlow': flowName,
      'env': widget.env,
      'availParams': availParamsMap,
      'additionalParams': additionalParamsMap,
      'bookingParams': additionalParamsMap,
    };

    final Widget platform;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      platform = UiKitView(
        viewType: _viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      platform = AndroidView(
        viewType: _viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      throw UnsupportedError(
        'MeiliView is not supported on $defaultTargetPlatform',
      );
    }

    return SizedBox(
      height: widget.height ?? kViewDefaultHeight,
      child: platform,
    );
  }
}

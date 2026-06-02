import 'package:flutter/material.dart';
import 'package:meili_flutter/src/widgets/meili_view.dart';
import 'package:meili_flutter_platform_interface/meili_flutter_platform_interface.dart';

/// Convenience wrapper that embeds the Meili **connect** flow.
class MeiliConnectWidget extends StatelessWidget {
  /// Creates a connect-flow [MeiliView].
  const MeiliConnectWidget({
    super.key,
    this.ptid,
    this.env,
    this.availParams,
    this.onEvent,
  });

  /// The ptid (partner/touchpoint id).
  final String? ptid;

  /// The environment (e.g. `dev`, `prod`).
  final String? env;

  /// Availability parameters.
  final AvailParams? availParams;

  /// Optional convenience callback for [MeiliEvent]s while mounted.
  final ValueChanged<MeiliEvent>? onEvent;

  @override
  Widget build(BuildContext context) {
    return MeiliView(
      ptid: ptid,
      flow: FlowType.connect,
      env: env,
      availParams: availParams,
      onEvent: onEvent,
      height: 430, // Specific height for connect flow
    );
  }
}

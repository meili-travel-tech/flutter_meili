// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:meili_flutter/src/model/avail_params.dart';
import 'package:meili_flutter/src/model/flow_enum.dart';
import 'package:meili_flutter/src/widgets/base.dart';

class MeiliConnectWidget extends StatelessWidget {
  const MeiliConnectWidget({
    super.key,
    this.ptid,
    this.env,
    this.availParams,
    this.onBookingInfoUpdated,
  });
  final String? ptid;
  final String? env;
  final AvailParams? availParams;
  final ValueChanged<Map<String, dynamic>>? onBookingInfoUpdated;

  @override
  Widget build(BuildContext context) {
    return MeiliView(
      ptid: ptid,
      flow: FlowType.connect,
      env: env,
      availParams: availParams,
      onBookingInfoUpdated: onBookingInfoUpdated,
      height: 430, // Specific height for connect flow
    );
  }
}

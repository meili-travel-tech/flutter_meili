import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meili_flutter/src/model/avail_params.dart';
import 'package:meili_flutter/src/model/flow_enum.dart';

class MeiliView extends StatefulWidget {
  MeiliView({
    Key? key,
    this.ptid,
    this.currentFlow,
    this.env,
    this.bookingParams,
    this.availParams,
    this.onBookingInfoUpdated,
    double? width,
    double? height,
    BoxConstraints? constraints,
  })  : constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);

  final BoxConstraints? constraints;
  final String? ptid;
  final FlowType? currentFlow;
  final String? env;
  final Map<String, dynamic>? bookingParams;
  final AvailParams? availParams;
  final ValueChanged<Map<String, dynamic>>? onBookingInfoUpdated;

  @override
  // ignore: library_private_types_in_public_api
  _MeiliViewState createState() => _MeiliViewState();
}

class _MeiliViewState extends State<MeiliView> {
  @override
  Widget build(BuildContext context) {
    final platformCardHeight =
        widget.constraints?.maxHeight ?? kViewDefaultHeight + 30;
    const platformMargin = EdgeInsets.fromLTRB(12, 10, 10, 12);
    final cardHeight = platformCardHeight - platformMargin.vertical;

    final platformWidget = CustomSingleChildLayout(
      delegate: const _NegativeMarginLayout(margin: platformMargin),
      child: _MethodChannelMeiliView(
        availParams: widget.availParams,
        bookingParams: widget.bookingParams,
        currentFlow: widget.currentFlow,
        onBookingInfoUpdated: widget.onBookingInfoUpdated,
        ptid: widget.ptid,
        env: widget.env,
        height: platformCardHeight,
      ),
    );

    return SizedBox(
      height: cardHeight,
      child: platformWidget,
    );
  }
}

class _MethodChannelMeiliView extends StatefulWidget {
  _MethodChannelMeiliView({
    this.ptid = '100.10',
    this.currentFlow = FlowType.direct,
    this.env = 'dev',
    this.bookingParams,
    this.availParams,
    this.onBookingInfoUpdated,
    double? width,
    double? height,
    BoxConstraints? constraints,
  }) : constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints;

  @override
  _MethodChannelMeiliViewState createState() => _MethodChannelMeiliViewState();

  final BoxConstraints? constraints;
  final String? ptid;
  final FlowType? currentFlow;
  final String? env;
  final Map<String, dynamic>? bookingParams;
  final AvailParams? availParams;
  final ValueChanged<Map<String, dynamic>>? onBookingInfoUpdated;
}

class _MethodChannelMeiliViewState extends State<_MethodChannelMeiliView> {
  static const String _viewType = 'flutter_meili/meili_view';
  late MethodChannel _channel;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    final creationParams = <String, dynamic>{
      'ptid': widget.ptid,
      'currentFlow': widget.currentFlow.toString().split('.').last,
      'env': widget.env,
      'bookingParams': widget.bookingParams,
      'availParams': widget.availParams?.toMap(),
    };

    final Widget platform = defaultTargetPlatform == TargetPlatform.iOS
        ? UiKitView(
            viewType: _viewType,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          )
        : throw UnsupportedError('Unsupported platform view');

    final constraints = widget.constraints ??
        const BoxConstraints.expand(height: kViewDefaultHeight);
    return ConstrainedBox(
      constraints: constraints,
      child: platform,
    );
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('$_viewType/$id');
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onBookingInfoUpdated' &&
          widget.onBookingInfoUpdated != null) {
        final arguments = Map<String, dynamic>.from(call.arguments as Map);
        widget.onBookingInfoUpdated!(arguments);
      } else if (call.method == 'updateHeight') {
        setState(() {
          height = call.arguments as double;
        });
      }
    });
  }
}

class _NegativeMarginLayout extends SingleChildLayoutDelegate {
  const _NegativeMarginLayout({required this.margin});

  final EdgeInsets margin;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final biggest = super.getConstraintsForChild(constraints).biggest;
    return BoxConstraints.expand(
      width: biggest.width + margin.horizontal,
      height: biggest.height + margin.vertical,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return super.getPositionForChild(size, childSize) - margin.topLeft;
  }

  @override
  bool shouldRelayout(covariant _NegativeMarginLayout oldDelegate) {
    return margin != oldDelegate.margin;
  }
}

const kViewDefaultHeight = 400.0;

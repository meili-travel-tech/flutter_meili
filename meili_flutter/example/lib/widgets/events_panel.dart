import 'package:flutter/cupertino.dart';
import 'package:meili_flutter/meili_flutter.dart';
import 'package:meili_flutter_example/events_view_model.dart';

/// A dumb view that renders the live Meili event log from an [EventsViewModel].
class EventsPanel extends StatelessWidget {
  /// Creates an events panel bound to [viewModel].
  const EventsPanel({required this.viewModel, super.key});

  /// The view model providing the event stream state.
  final EventsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final records = viewModel.records;
        if (records.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No Meili events yet. Open a flow to see events arrive here.',
            ),
          );
        }
        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return _EventTile(
              key: ValueKey<int>(record.id),
              event: record.event,
            );
          },
        );
      },
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event, super.key});

  final MeiliEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (_subtitle != null)
            Text(_subtitle!, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  String get _title => switch (event) {
        MeiliFlowDismissed() => 'Flow dismissed',
        MeiliBookingFlowEnded() => 'Booking flow ended',
        MeiliAnalyticsEvent(:final name) => 'Analytics · $name',
        MeiliUnknownEvent(:final type) => 'Unknown · $type',
      };

  String? get _subtitle => switch (event) {
        MeiliAnalyticsEvent(:final properties) =>
          properties.isEmpty ? null : properties.toString(),
        _ => null,
      };
}

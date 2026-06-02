import 'package:flutter/cupertino.dart';
import 'package:meili_flutter/meili_flutter.dart';

import 'package:meili_flutter_example/events_view_model.dart';
import 'package:meili_flutter_example/widgets/events_panel.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(home: TabHomePage());
  }
}

class TabHomePage extends StatefulWidget {
  const TabHomePage({super.key});

  @override
  State<TabHomePage> createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> {
  late final EventsViewModel _eventsViewModel;

  @override
  void initState() {
    super.initState();
    _eventsViewModel = EventsViewModel();
  }

  @override
  void dispose() {
    _eventsViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Direct',
            icon: Icon(CupertinoIcons.arrow_right),
          ),
          BottomNavigationBarItem(
            label: 'Booking Manager',
            icon: Icon(CupertinoIcons.person),
          ),
          BottomNavigationBarItem(
            label: 'Events',
            icon: Icon(CupertinoIcons.list_bullet),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const MeiliDirectFlowButton();
          case 1:
            return const MeiliBookingManagerFlowButton();
          case 2:
            return EventsTab(viewModel: _eventsViewModel);
          default:
            return Container();
        }
      },
    );
  }
}

/// Tab that shows the live Meili event log, sourced from [Meili.events].
class EventsTab extends StatelessWidget {
  /// Creates the events tab bound to [viewModel].
  const EventsTab({required this.viewModel, super.key});

  /// The shared events view model.
  final EventsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Meili Events'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: viewModel.clear,
          child: const Text('Clear'),
        ),
      ),
      child: SafeArea(child: EventsPanel(viewModel: viewModel)),
    );
  }
}

class MeiliDirectFlowButton extends StatelessWidget {
  const MeiliDirectFlowButton({super.key});

  Future<void> _openMeiliView() async {
    final params = MeiliParams(
      ptid: '100.9',
      flow: FlowType.direct,
      env: 'dev',
    );

    try {
      await Meili.openMeiliView(params);
    } catch (e) {
      print('Failed to open MeiliView: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: _openMeiliView,
      child: const Text('Open Meili Direct'),
    );
  }
}

class MeiliBookingManagerFlowButton extends StatelessWidget {
  const MeiliBookingManagerFlowButton({super.key});

  Future<void> _openMeiliView() async {
    final params = MeiliParams(
      ptid: '100.9',
      flow: FlowType.bookingManager,
      env: 'dev',
    );

    try {
      await Meili.openMeiliView(params);
    } catch (e) {
      print('Failed to open MeiliView: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: _openMeiliView,
      child: const Text('Open Meili Booking Manager'),
    );
  }
}

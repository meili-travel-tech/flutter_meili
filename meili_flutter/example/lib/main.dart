import 'package:flutter/cupertino.dart';
import 'package:meili_flutter/meili_flutter.dart';

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
            label: 'Connect',
            icon: Icon(CupertinoIcons.link),
          ),
          BottomNavigationBarItem(
            label: 'Booking Manager',
            icon: Icon(CupertinoIcons.person),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const MeiliDirectFlowButton();
          case 1:
            return const HomePage();
          case 2:
            return const MeiliBookingManagerFlowButton();
          default:
            return Container();
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('IN PATH BOOKING'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Higher dummy content above the MeiliView
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Welcome to the Flutter Example App',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'This is some dummy content above the MeiliView widget.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'More dummy content above the MeiliView widget.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Even more dummy content above the MeiliView widget.',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              // MeiliConnectWidget
              MeiliConnectWidget(
                ptid: '125.10',
                env: 'prod',
                availParams: AvailParams(
                  pickupLocation: 'MUC',
                  dropoffLocation: 'MUC',
                  pickupDate: '2025-01-01',
                  pickupTime: '12:00',
                  dropoffDate: '2025-01-07',
                  dropoffTime: '12:00',
                  driverAge: 25,
                  currencyCode: 'EUR',
                  residency: 'IE',
                ),
              ),

              // Dummy content below the MeiliView
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'This is some dummy content below the MeiliView widget.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Enjoy exploring the app!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Even more dummy content below the MeiliView widget.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'More dummy content below the MeiliView widget.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
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

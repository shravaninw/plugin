import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const plat = MethodChannel('samples.flutter.dev/device');

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            Text(_batteryLevel),
            ElevatedButton(
              child: Text('Get Device Info'),
              onPressed: _getDeviceInfo,
            ),
            Text(_deviceInfo),
          ],
        ),
      ),
    );
  }

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';
  String _deviceInfo = "Unknown Device Info";

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getDeviceInfo() async {
    String deviceInfo;
    try {
      final String result = await plat.invokeMethod('getDeviceInfo');
      deviceInfo = 'Device Id is $result.';
    } on PlatformException catch (e) {
      deviceInfo = "Failed to get device id: '${e.message}'.";
    }

    setState(() {
      _deviceInfo = deviceInfo;
    });
  }
}

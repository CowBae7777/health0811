// import 'package:flutter/material.dart';
// import "StatusPage.dart";
// import "PlansPage.dart";
// import "BadThingsPage.dart";
// import "ProfilePage.dart";
// import 'package:health/health.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class _StatusPageState extends State<StatusPage> {
//   HealthFactory health = HealthFactory();
//
//   Future<void> fetchData() async {
//     List<HealthDataType> types = [
//       HealthDataType.STEPS,
//       HealthDataType.HEART_RATE,
//     ];
//
//     bool requested = await health.requestAuthorization(types);
//
//     if (requested) {
//       print("HealthKit授权成功");
//       // 获取数据的代码...
//     } else {
//       print("HealthKit授权失败或用户未授权");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Health Tracker App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainPage(),
//     );
//   }
// }
//
// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;
//
//   static List<Widget> _widgetOptions = <Widget>[
//     StatusPage(),
//     PlansPage(),
//     BadThingsPage(),
//     ProfilePage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Health Tracker'),
//       ),
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Status',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Plans',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.warning),
//             label: 'Bad Things',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         unselectedItemColor: Colors.grey[600],
//         onTap: _onItemTapped,
//
//       ),
//     );
//   }
// }


//v2
// import 'package:flutter/material.dart';
// import "StatusPage.dart";
// import "PlansPage.dart";
// import "BadThingsPage.dart";
// import "ProfilePage.dart";
// import 'package:health/health.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MainPage(),
//     );
//   }
// }
//
// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;
//
//   static List<Widget> _widgetOptions = <Widget>[
//     StatusPage(),
//     PlansPage(),
//     BadThingsPage(),
//     ProfilePage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('健康是唯一的財富'),
//       ),
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: '個人狀態',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: '計畫',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.warning),
//             label: '壞習慣',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: '個人資料',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue[800],
//         unselectedItemColor: Colors.grey[600],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

//v3

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'GoogleFitDemo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Fit Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleFitDemo(),
    );
  }
}

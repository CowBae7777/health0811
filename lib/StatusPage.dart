// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
//
// class StatusPage extends StatefulWidget {
//   @override
//   _StatusPageState createState() => _StatusPageState();
// }
//
// class _StatusPageState extends State<StatusPage> {
//   List<HealthDataPoint> _stepsDataList = [];
//   List<HealthDataPoint> _heartRateDataList = [];
//   bool _isAuthorized = false;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     HealthFactory health = HealthFactory();
//     List<HealthDataType> types = [
//       HealthDataType.STEPS,
//       HealthDataType.HEART_RATE,
//     ];
//
//     bool requested = await health.requestAuthorization(types);
//
//     if (requested) {
//       setState(() {
//         _isAuthorized = true;
//       });
//
//       DateTime endDate = DateTime.now();
//       DateTime startDate = endDate.subtract(Duration(days: 30));
//
//       List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
//
//       setState(() {
//         _stepsDataList = healthData.where((data) => data.type == HealthDataType.STEPS).toList();
//         _heartRateDataList = healthData.where((data) => data.type == HealthDataType.HEART_RATE).toList();
//         _isLoading = false;
//       });
//     } else {
//       setState(() {
//         _isAuthorized = false;
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("健康狀態"),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _isAuthorized
//           ? ListView(
//         padding: EdgeInsets.all(16.0),
//         children: [
//           Text("步數數據", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           ..._stepsDataList.map((data) => ListTile(
//             title: Text("${data.value} 步"),
//             subtitle: Text("${data.dateFrom} - ${data.dateTo}"),
//           )),
//           SizedBox(height: 24.0),
//           Text("心律數據", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           ..._heartRateDataList.map((data) => ListTile(
//             title: Text("${data.value} bpm"),
//             subtitle: Text("${data.dateFrom} - ${data.dateTo}"),
//           )),
//           SizedBox(height: 24.0),
//           ElevatedButton(
//             onPressed: fetchData,
//             child: Text("重新加載數據"),
//           ),
//         ],
//       )
//           : Center(
//         child: Text("未授權讀取健康數據"),
//       ),
//     );
//   }
// }

//v2
//
// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class StatusPage extends StatefulWidget {
//   @override
//   _StatusPageState createState() => _StatusPageState();
// }
//
// class _StatusPageState extends State<StatusPage> {
//   HealthFactory health = HealthFactory();
//   List<HealthDataPoint> _stepsDataList = [];
//   List<HealthDataPoint> _heartRateDataList = [];
//   bool _isAuthorized = false;
//   bool _isLoading = false;
//   File? _image; // 用于存储用户选择的头像
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     List<HealthDataType> types = [
//       HealthDataType.STEPS,
//       HealthDataType.HEART_RATE,
//     ];
//
//     bool requested = await health.requestAuthorization(types);
//
//     if (requested) {
//       print("HealthKit授权成功");
//
//       DateTime endDate = DateTime.now();
//       DateTime startDate = endDate.subtract(Duration(days: 30));
//
//       List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
//
//       setState(() {
//         _stepsDataList = healthData.where((data) => data.type == HealthDataType.STEPS).toList();
//         _heartRateDataList = healthData.where((data) => data.type == HealthDataType.HEART_RATE).toList();
//         _isLoading = false;
//         _isAuthorized = true;
//       });
//     } else {
//       print("HealthKit授权失败或用户未授权");
//       setState(() {
//         _isLoading = false;
//         _isAuthorized = false;
//       });
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("健康狀態"),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 // 左上角：头像
//                 GestureDetector(
//                   onTap: _pickImage, // 点击头像更换图片
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _image != null
//                         ? FileImage(_image!)
//                         : AssetImage('assets/avatar.jpg') as ImageProvider,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // 右上角：个人资料
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '日期: 今天的日期', // 你可以用代码动态获取日期
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '名字: John Doe', // 从个人资料中获取
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '身高: 170 cm', // 从个人资料中获取
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '体重: 70 kg', // 从个人资料中获取
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '健康状态: ', // 从健康数据中获取
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           Row(
//                             children: List.generate(5, (index) {
//                               return Icon(
//                                 Icons.favorite,
//                                 color: index < 4 ? Colors.red : Colors.grey, // 动态设置健康状态
//                                 size: 16,
//                               );
//                             }),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 显示健康计划和坏习惯
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 左下角：健康计划
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '计划',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '目标体重: 85 kg', // 动态获取用户的健康计划
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '目标日期: 2024年12月31日', // 动态获取用户的健康计划
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // 右下角：坏习惯
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '坏习惯',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '每日吸烟: 0 根', // 动态获取用户想戒除的坏习惯
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '换烟草: 5 根', // 动态获取用户想戒除的坏习惯
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 显示步数和心律数据的简要信息，点击可进入详细页面
//             Row(
//               children: [
//                 Expanded(
//                   child: ListTile(
//                     title: Text("步數數據"),
//                     subtitle: Text("点此查看步数详细数据"),
//                     onTap: () {
//                       // 导航到步数详细数据页面
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => StepsDataPage(dataList: _stepsDataList),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: ListTile(
//                     title: Text("心律數據"),
//                     subtitle: Text("点此查看心律详细数据"),
//                     onTap: () {
//                       // 导航到心律详细数据页面
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HeartRateDataPage(dataList: _heartRateDataList),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: fetchData,
//               child: Text("重新加载数据"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class StepsDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   StepsDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("步數數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} 步"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class HeartRateDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   HeartRateDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("心律數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} bpm"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }


//v3
// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';  // 导入SharedPreferences
// import 'dart:io';
// import "package:intl/intl.dart";
//
// class StatusPage extends StatefulWidget {
//   @override
//   _StatusPageState createState() => _StatusPageState();
// }
//
// class _StatusPageState extends State<StatusPage> {
//   HealthFactory health = HealthFactory();
//   List<HealthDataPoint> _stepsDataList = [];
//   List<HealthDataPoint> _heartRateDataList = [];
//   bool _isAuthorized = false;
//   bool _isLoading = false;
//   File? _image; // 用于存储用户选择的头像
//
//   String _name = '';
//   String _height = '';
//   String _weight = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//     fetchData();
//   }
//
//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _name = prefs.getString('name') ?? 'N/A';
//       _height = prefs.getString('height') ?? 'N/A';
//       _weight = prefs.getString('weight') ?? 'N/A';
//     });
//   }
//
//   Future<void> fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     List<HealthDataType> types = [
//       HealthDataType.STEPS,
//       HealthDataType.HEART_RATE,
//     ];
//
//     bool requested = await health.requestAuthorization(types);
//
//     if (requested) {
//       print("HealthKit授权成功");
//
//       DateTime endDate = DateTime.now();
//       DateTime startDate = endDate.subtract(Duration(days: 30));
//
//       List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
//
//       setState(() {
//         _stepsDataList = healthData.where((data) => data.type == HealthDataType.STEPS).toList();
//         _heartRateDataList = healthData.where((data) => data.type == HealthDataType.HEART_RATE).toList();
//         _isLoading = false;
//         _isAuthorized = true;
//       });
//     } else {
//       print("HealthKit授权失败或用户未授权");
//       setState(() {
//         _isLoading = false;
//         _isAuthorized = false;
//       });
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("健康狀態"),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 // 左上角：头像
//                 GestureDetector(
//                   onTap: _pickImage, // 点击头像更换图片
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _image != null
//                         ? FileImage(_image!)
//                         : AssetImage('assets/avatar.jpg') as ImageProvider,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // 右上角：个人资料
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '名字: $_name',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '身高: $_height cm',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '体重: $_weight kg',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '健康状态: ', // 从健康数据中获取
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           Row(
//                             children: List.generate(5, (index) {
//                               return Icon(
//                                 Icons.favorite,
//                                 color: index < 4 ? Colors.red : Colors.grey, // 动态设置健康状态
//                                 size: 16,
//                               );
//                             }),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 显示健康计划和坏习惯
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 左下角：健康计划
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '计划',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '目标体重: 85 kg', // 动态获取用户的健康计划
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '目标日期: 2024年12月31日', // 动态获取用户的健康计划
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // 右下角：坏习惯
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '坏习惯',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '每日吸烟: 0 根', // 动态获取用户想戒除的坏习惯
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '换烟草: 5 根', // 动态获取用户想戒除的坏习惯
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 显示步数和心律数据的简要信息，点击可进入详细页面
//             Row(
//               children: [
//                 Expanded(
//                   child: ListTile(
//                     title: Text("步數數據"),
//                     subtitle: Text("点此查看步数详细数据"),
//                     onTap: () {
//                       // 导航到步数详细数据页面
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => StepsDataPage(dataList: _stepsDataList),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: ListTile(
//                     title: Text("心律數據"),
//                     subtitle: Text("点此查看心律详细数据"),
//                     onTap: () {
//                       // 导航到心律详细数据页面
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HeartRateDataPage(dataList: _heartRateDataList),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: fetchData,
//               child: Text("重新加载数据"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class StepsDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   StepsDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("步數數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} 步"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class HeartRateDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   HeartRateDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("心律數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} bpm"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }

//v4

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // 导入intl包用于格式化日期
// import 'package:health/health.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class StatusPage extends StatefulWidget {
//   @override
//   _StatusPageState createState() => _StatusPageState();
// }
//
// class _StatusPageState extends State<StatusPage> {
//   String _currentDate = ''; // 存储当前日期
//   HealthFactory health = HealthFactory();
//   List<HealthDataPoint> _stepsDataList = [];
//   List<HealthDataPoint> _heartRateDataList = [];
//   bool _isAuthorized = false;
//   bool _isLoading = false;
//   File? _image; // 用于存储用户选择的头像
//
//   String _name = '';
//   String _height = '';
//   String _weight = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _setCurrentDate(); // 设置当前日期
//     _loadProfileData(); // 加载用户数据
//     fetchData(); // 获取健康数据
//   }
//
//   void _setCurrentDate() {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('yyyy-MM-dd'); // 设置日期格式
//     final String formatted = formatter.format(now);
//     setState(() {
//       _currentDate = formatted; // 设置当前日期的状态
//     });
//   }
//
//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _name = prefs.getString('name') ?? 'N/A';
//       _height = prefs.getString('height') ?? 'N/A';
//       _weight = prefs.getString('weight') ?? 'N/A';
//     });
//   }
//
//   Future<void> fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     List<HealthDataType> types = [
//       HealthDataType.STEPS,
//       HealthDataType.HEART_RATE,
//     ];
//
//     bool requested = await health.requestAuthorization(types);
//
//     if (requested) {
//       print("HealthKit授权成功");
//
//       DateTime endDate = DateTime.now();
//       DateTime startDate = endDate.subtract(Duration(days: 30));
//
//       List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
//
//       setState(() {
//         _stepsDataList = healthData.where((data) => data.type == HealthDataType.STEPS).toList();
//         _heartRateDataList = healthData.where((data) => data.type == HealthDataType.HEART_RATE).toList();
//         _isLoading = false;
//         _isAuthorized = true;
//       });
//     } else {
//       print("HealthKit授权失败或用户未授权");
//       setState(() {
//         _isLoading = false;
//         _isAuthorized = false;
//       });
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("健康狀態"),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 // 显示系统日期
//                 Expanded(
//                   child: Text(
//                     '日期: $_currentDate',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 // 其他内容...
//               ],
//             ),
//             Row(
//               children: [
//                 // 左上角：头像
//                 GestureDetector(
//                   onTap: _pickImage, // 点击头像更换图片
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _image != null
//                         ? FileImage(_image!)
//                         : AssetImage('assets/avatar.jpg') as ImageProvider,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // 右上角：个人资料
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '名字: $_name',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '身高: $_height cm',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '体重: $_weight kg',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '健康状态: ',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           Row(
//                             children: List.generate(5, (index) {
//                               return Icon(
//                                 Icons.favorite,
//                                 color: index < 4 ? Colors.red : Colors.grey, // 动态设置健康状态
//                                 size: 16,
//                               );
//                             }),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 显示健康计划和坏习惯
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 左下角：健康计划
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '计划',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '目标体重: 85 kg',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '目标日期: 2024年12月31日',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // 右下角：坏习惯
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '坏习惯',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '每日吸烟: 0 根',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '换烟草: 5 根',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 显示步数和心律数据的简要信息，点击可进入详细页面
//             Row(
//               children: [
//                 Expanded(
//                   child: ListTile(
//                     title: Text("步數數據"),
//                     subtitle: Text("点此查看步数详细数据"),
//                     onTap: () {
//                       // 导航到步数详细数据页面
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => StepsDataPage(dataList: _stepsDataList),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: ListTile(
//                     title: Text("心律數據"),
//                     subtitle: Text("点此查看心律详细数据"),
//                     onTap: () {
//                       // 导航到心律详细数据页面
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HeartRateDataPage(dataList: _heartRateDataList),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: fetchData,
//               child: Text("重新加载数据"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class StepsDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   StepsDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("步數數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} 步"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class HeartRateDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   HeartRateDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("心律數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} bpm"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }


//v5
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // 导入intl包用于格式化日期
// import 'package:health/health.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class StatusPage extends StatefulWidget {
//   @override
//   _StatusPageState createState() => _StatusPageState();
// }
//
// class _StatusPageState extends State<StatusPage> {
//   String _currentDate = ''; // 存储当前日期
//   HealthFactory health = HealthFactory();
//   List<HealthDataPoint> _stepsDataList = [];
//   List<HealthDataPoint> _heartRateDataList = [];
//   bool _isAuthorized = false;
//   bool _isLoading = false;
//   File? _image; // 用于存储用户选择的头像
//
//   String _name = '';
//   String _height = '';
//   String _weight = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _setCurrentDate(); // 设置当前日期
//     _loadProfileData(); // 加载用户数据
//     fetchData(); // 获取健康数据
//   }
//
//   void _setCurrentDate() {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('yyyy-MM-dd'); // 设置日期格式
//     final String formatted = formatter.format(now);
//     setState(() {
//       _currentDate = formatted; // 设置当前日期的状态
//     });
//   }
//
//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _name = prefs.getString('name') ?? 'N/A';
//       _height = prefs.getString('height') ?? 'N/A';
//       _weight = prefs.getString('weight') ?? 'N/A';
//     });
//   }
//
//   Future<void> fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     List<HealthDataType> types = [
//       HealthDataType.STEPS,
//       HealthDataType.HEART_RATE,
//     ];
//
//     bool requested = await health.requestAuthorization(types);
//
//     if (requested) {
//       print("HealthKit授权成功");
//
//       DateTime endDate = DateTime.now();
//       DateTime startDate = endDate.subtract(Duration(days: 30));
//
//       List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
//
//       setState(() {
//         _stepsDataList = healthData.where((data) => data.type == HealthDataType.STEPS).toList();
//         _heartRateDataList = healthData.where((data) => data.type == HealthDataType.HEART_RATE).toList();
//         _isLoading = false;
//         _isAuthorized = true;
//       });
//     } else {
//       print("HealthKit授权失败或用户未授权");
//       setState(() {
//         _isLoading = false;
//         _isAuthorized = false;
//       });
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("健康狀態"),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 显示系统日期并将其置于右上角
//             Align(
//               alignment: Alignment.topRight, // 将日期对齐到右上角
//               child: Text(
//                 '日期: $_currentDate',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             SizedBox(height: 20), // 给日期和其他内容之间一些空间
//             Row(
//               children: [
//                 // 左上角：头像
//                 GestureDetector(
//                   onTap: _pickImage, // 点击头像更换图片
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _image != null
//                         ? FileImage(_image!)
//                         : AssetImage('assets/avatar.jpg') as ImageProvider,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // 右上角：个人资料
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '名字: $_name',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '身高: $_height cm',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '体重: $_weight kg',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 显示健康计划和坏习惯
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 左下角：健康计划
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '计划',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '目标体重: 85 kg',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '目标日期: 2024年12月31日',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // 右下角：坏习惯
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '坏习惯',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '每日吸烟: 0 根',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '换烟草: 5 根',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 显示步数和心律数据的简要信息，点击可进入详细页面
//             Row(
//               children: [
//                 Expanded(
//                   child: ListTile(
//                     title: Text("步數數據"),
//                     subtitle: Text("点此查看步数详细数据"),
//                     onTap: () {
//                       // 导航到步数详细数据页面
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => StepsDataPage(dataList: _stepsDataList),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: ListTile(
//                     title: Text("心律數據"),
//                     subtitle: Text("点此查看心律详细数据"),
//                     onTap: () {
//                       // 导航到心律详细数据页面
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HeartRateDataPage(dataList: _heartRateDataList),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: fetchData,
//               child: Text("重新加载数据"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class StepsDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   StepsDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("步數數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} 步"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class HeartRateDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   HeartRateDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("心律數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} bpm"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }


//v6

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // 用於格式化日期
// import 'package:health/health.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class StatusPage extends StatefulWidget {
//   @override
//   _StatusPageState createState() => _StatusPageState();
// }
//
// class _StatusPageState extends State<StatusPage> {
//   String _currentDate = ''; // 存儲當前日期
//   HealthFactory health = HealthFactory();
//   List<HealthDataPoint> _stepsDataList = [];
//   List<HealthDataPoint> _heartRateDataList = [];
//   bool _isAuthorized = false;
//   bool _isLoading = false;
//   File? _image; // 用於存儲使用者選擇的頭像
//
//   String _name = '';
//   String _height = '';
//   String _weight = '';
//
//   // 新增的字段用於顯示計劃和壞習慣
//   String _targetWeight = '85 kg';
//   String _targetDate = '2024年12月31日';
//   String _badHabit1 = '每日吸煙: 0 根';
//   String _badHabit2 = '換煙草: 5 根';
//
//   @override
//   void initState() {
//     super.initState();
//     _setCurrentDate(); // 設置當前日期
//     _loadProfileData(); // 加載使用者資料
//     fetchData(); // 獲取健康數據
//   }
//
//   // 設定並顯示當前系統日期
//   void _setCurrentDate() {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('yyyy-MM-dd'); // 設定日期格式
//     final String formatted = formatter.format(now);
//     setState(() {
//       _currentDate = formatted; // 更新當前日期
//     });
//   }
//
//   // 從 SharedPreferences 加載使用者的個人資料
//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _name = prefs.getString('name') ?? 'N/A';
//       _height = prefs.getString('height') ?? 'N/A';
//       _weight = prefs.getString('weight') ?? 'N/A';
//     });
//   }
//
//   // 從 HealthKit 獲取步數和心率數據
//   Future<void> fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     List<HealthDataType> types = [
//       HealthDataType.STEPS,
//       HealthDataType.HEART_RATE,
//     ];
//
//     // 請求健康數據的授權
//     bool requested = await health.requestAuthorization(types);
//
//     if (requested) {
//       print("HealthKit 授權成功");
//
//       DateTime endDate = DateTime.now();
//       DateTime startDate = endDate.subtract(Duration(days: 30));
//
//       // 獲取步數和心率數據
//       List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
//
//       setState(() {
//         // 將獲取到的數據分別存入步數和心率的列表中
//         _stepsDataList = healthData.where((data) => data.type == HealthDataType.STEPS).toList();
//         _heartRateDataList = healthData.where((data) => data.type == HealthDataType.HEART_RATE).toList();
//         _isLoading = false;
//         _isAuthorized = true;
//       });
//     } else {
//       print("HealthKit 授權失敗或使用者未授權");
//       setState(() {
//         _isLoading = false;
//         _isAuthorized = false;
//       });
//     }
//   }
//
//   // 選擇使用者頭像
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path); // 將選擇的圖片更新為頭像
//       } else {
//         print('未選擇圖片');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // 顯示系統日期（右上角）
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Text(
//                     '日期: $_currentDate',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 // 使用者頭像和個人信息，居中顯示
//                 Center(
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: _pickImage, // 點擊頭像可以更換圖片
//                         child: CircleAvatar(
//                           radius: 50,
//                           backgroundImage: _image != null
//                               ? FileImage(_image!)
//                               : AssetImage('assets/avatar.jpg') as ImageProvider,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         '名字: $_name',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         '身高: $_height cm',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '體重: $_weight kg',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 40),
//                 // 顯示計劃和壞習慣
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // 左側：健康計劃
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '計劃',
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             '目標體重: $_targetWeight',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           Text(
//                             '目標日期: $_targetDate',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     // 右側：壞習慣
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '壞習慣',
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             _badHabit1,
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           Text(
//                             _badHabit2,
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 40),
//                 // 心跳和步數數據
//                 _isAuthorized
//                     ? Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ListTile(
//                             title: Text("步數數據"),
//                             subtitle: Text("點此查看步數詳細數據"),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       StepsDataPage(dataList: _stepsDataList),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         Expanded(
//                           child: ListTile(
//                             title: Text("心律數據"),
//                             subtitle: Text("點此查看心律詳細數據"),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       HeartRateDataPage(dataList: _heartRateDataList),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//                     : Center(
//                   child: Text(
//                     "未授權健康數據訪問",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // 右下角的重新加載按鈕
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: FloatingActionButton(
//               onPressed: fetchData,
//               child: Icon(Icons.refresh),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // 步數數據頁面
// class StepsDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   StepsDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("步數數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} 步"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // 心律數據頁面
// class HeartRateDataPage extends StatelessWidget {
//   final List<HealthDataPoint> dataList;
//
//   HeartRateDataPage({required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("心律數據"),
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           HealthDataPoint data = dataList[index];
//           return ListTile(
//             title: Text("${data.value} bpm"),
//             subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
//           );
//         },
//       ),
//     );
//   }
// }


//v7
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 用于格式化日期
import 'package:health/health.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String _currentDate = ''; // 存儲當前日期
  HealthFactory health = HealthFactory();
  List<HealthDataPoint> _stepsDataList = [];
  List<HealthDataPoint> _heartRateDataList = [];
  bool _isAuthorized = false;
  bool _isLoading = false;
  File? _image; // 用於存儲使用者選擇的頭像

  String _name = '';
  String _height = '';
  String _weight = '';

  // 新增的字段用于显示计划和坏习惯
  String _targetWeight = '85 kg';
  String _targetDate = '2024年12月31日';
  String _badHabit1 = '每日吸煙: 0 根';
  String _badHabit2 = '換煙草: 5 根';

  // 通知文字内容
  String _notifyMessage = '';

  @override
  void initState() {
    super.initState();
    _setCurrentDate(); // 設置當前日期
    _loadProfileData(); // 加載使用者資料
    fetchData(); // 獲取健康數據
  }

  // 設定並顯示當前系統日期
  void _setCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd'); // 設定日期格式
    final String formatted = formatter.format(now);
    setState(() {
      _currentDate = formatted; // 更新當前日期
    });
  }

  // 从 SharedPreferences 加载使用者的个人资料
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'N/A';
      _height = prefs.getString('height') ?? 'N/A';
      _weight = prefs.getString('weight') ?? 'N/A';
    });
  }

  // 从 HealthKit 获取步数和心率数据
  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      _notifyMessage = "正在重新加载数据..."; // 开始加载时显示通知
    });

    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
    ];

    // 请求健康数据的授权
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      print("HealthKit 授权成功");

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 30));

      // 获取步数和心率数据
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);

      setState(() {
        // 将获取到的数据分别存入步数和心率的列表中
        _stepsDataList = healthData.where((data) => data.type == HealthDataType.STEPS).toList();
        _heartRateDataList = healthData.where((data) => data.type == HealthDataType.HEART_RATE).toList();
        _isLoading = false;
        _notifyMessage = "数据加载成功"; // 加载成功后显示通知
        _isAuthorized = true;
      });
    } else {
      print("HealthKit 授权失败或用户未授权");
      setState(() {
        _isLoading = false;
        _notifyMessage = "授权失败或用户未授权"; // 授权失败后显示通知
        _isAuthorized = false;
      });
    }
  }

  // 选择用户头像
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // 将选择的图片更新为头像
      } else {
        print('未选择图片');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 显示系统日期（右上角）
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '日期: $_currentDate',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                // 用户头像和个人信息，居中显示
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage, // 点击头像可以更换图片
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : AssetImage('assets/avatar.jpg') as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '名字: $_name',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '身高: $_height cm',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '體重: $_weight kg',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // 显示计划和坏习惯
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 左侧：健康计划
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '计划',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '目标体重: $_targetWeight',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '目标日期: $_targetDate',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    // 右侧：坏习惯
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '坏习惯',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _badHabit1,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            _badHabit2,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // 心跳和步数数据
                _isAuthorized
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text("步数数据"),
                            subtitle: Text("点此查看步数详细数据"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StepsDataPage(dataList: _stepsDataList),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text("心律数据"),
                            subtitle: Text("点此查看心律详细数据"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HeartRateDataPage(dataList: _heartRateDataList),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    : Center(
                  child: Text(
                    "未授权健康数据访问",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 20),
                // 显示通知消息
                Text(
                  _notifyMessage,
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ],
            ),
          ),
          // 右下角的重新加载按钮
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: fetchData,
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}

// 步数数据页面
class StepsDataPage extends StatelessWidget {
  final List<HealthDataPoint> dataList;

  StepsDataPage({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("步數數據"),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          HealthDataPoint data = dataList[index];
          return ListTile(
            title: Text("${data.value} 步"),
            subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
          );
        },
      ),
    );
  }
}

// 心律数据页面
class HeartRateDataPage extends StatelessWidget {
  final List<HealthDataPoint> dataList;

  HeartRateDataPage({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("心律數據"),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          HealthDataPoint data = dataList[index];
          return ListTile(
            title: Text("${data.value} bpm"),
            subtitle: Text("日期: ${data.dateFrom} - ${data.dateTo}"),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }
//
//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _nameController.text = prefs.getString('name') ?? '';
//       _heightController.text = prefs.getString('height') ?? '';
//       _weightController.text = prefs.getString('weight') ?? '';
//     });
//   }
//
//   Future<void> _saveProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('name', _nameController.text);
//     await prefs.setString('height', _heightController.text);
//     await prefs.setString('weight', _weightController.text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _heightController,
//               decoration: InputDecoration(labelText: 'Height (cm)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _weightController,
//               decoration: InputDecoration(labelText: 'Weight (kg)'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _saveProfileData();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Profile Saved')),
//                 );
//               },
//               child: Text("Save"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _heightController.dispose();
//     _weightController.dispose();
//     super.dispose();
//   }
// }


//v2

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }
//
//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _nameController.text = prefs.getString('name') ?? '';
//       _heightController.text = prefs.getString('height') ?? '';
//       _weightController.text = prefs.getString('weight') ?? '';
//     });
//   }
//
//   Future<void> _saveProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('name', _nameController.text);
//     await prefs.setString('height', _heightController.text);
//     await prefs.setString('weight', _weightController.text);
//
//     // 保存后给出反馈，并返回上一页
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Profile Saved')),
//     );
//     Navigator.of(context).pop();  // 返回上一页
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _heightController,
//               decoration: InputDecoration(labelText: 'Height (cm)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _weightController,
//               decoration: InputDecoration(labelText: 'Weight (kg)'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveProfileData,  // 调用保存函数
//               child: Text("Save"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _heightController.dispose();
//     _weightController.dispose();
//     super.dispose();
//   }
// }


//v3
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }
//
//   Future<void> _loadProfileData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _nameController.text = prefs.getString('name') ?? '';
//       _heightController.text = prefs.getString('height') ?? '';
//       _weightController.text = prefs.getString('weight') ?? '';
//     });
//   }
//
//   Future<void> _saveProfileData() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('name', _nameController.text);
//       await prefs.setString('height', _heightController.text);
//       await prefs.setString('weight', _weightController.text);
//
//       // 显示保存成功的信息
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Profile Saved')),
//       );
//       Navigator.of(context).pop();  // 返回上一页
//     } catch (e) {
//       // 捕获异常并显示错误消息
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save profile data: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _heightController,
//               decoration: InputDecoration(labelText: 'Height (cm)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _weightController,
//               decoration: InputDecoration(labelText: 'Weight (kg)'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveProfileData,  // 保存数据
//               child: Text("Save"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _heightController.dispose();
//     _weightController.dispose();
//     super.dispose();
//   }
// }

//v4
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _heightController.text = prefs.getString('height') ?? '';
      _weightController.text = prefs.getString('weight') ?? '';
    });
  }

  Future<void> _saveProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('height', _heightController.text);
      await prefs.setString('weight', _weightController.text);

      // 显示保存成功的信息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile Saved')),
      );

      // 延迟后返回上一页，防止UI刷新问题
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      // 捕获异常并显示错误消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileData,  // 保存数据
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}

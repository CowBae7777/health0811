import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleFitDemo extends StatefulWidget {
  @override
  _GoogleFitDemoState createState() => _GoogleFitDemoState();
}

class _GoogleFitDemoState extends State<GoogleFitDemo> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/fitness.activity.read',
      'https://www.googleapis.com/auth/fitness.body.read',
    ],
  );

  bool _isAuthorized = false;
  String _stepsData = "未讀取";

  @override
  void initState() {
    super.initState();
    requestAuthorization();
  }

  // 請求Google Fit授權
  Future<void> requestAuthorization() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        setState(() {
          _isAuthorized = true;
        });
        print("授權成功");
        fetchStepsData(); // 授權成功後讀取步數數據
      } else {
        print("授權失敗");
      }
    } catch (error) {
      print("授權過程中出現錯誤: $error");
    }
  }

  // 從Google Fit API讀取步數數據
  Future<void> fetchStepsData() async {
    try {
      final GoogleSignInAccount? account = _googleSignIn.currentUser;
      if (account != null) {
        final headers = await account.authHeaders;
        final response = await http.get(
          Uri.parse(
              'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _stepsData = data.toString(); // 你可以根據需要格式化數據
          });
          print("步數數據讀取成功: $_stepsData");
        } else {
          print("讀取數據失敗: ${response.statusCode}");
        }
      }
    } catch (error) {
      print("讀取Google Fit數據出現錯誤: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Fit Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isAuthorized
                  ? '已授權讀取Google Fit數據'
                  : '未授權，請求Google Fit授權',
            ),
            SizedBox(height: 20),
            Text('步數數據: $_stepsData'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAuthorized ? fetchStepsData : requestAuthorization,
              child: Text(_isAuthorized ? '重新加載步數數據' : '請求授權'),
            ),
          ],
        ),
      ),
    );
  }
}

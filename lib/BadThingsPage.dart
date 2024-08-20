import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'dart:async';

class BadThingsPage extends StatefulWidget {
  @override
  _BadThingsPageState createState() => _BadThingsPageState();
}

class _BadThingsPageState extends State<BadThingsPage> {
  HealthFactory health = HealthFactory();
  List<HealthDataPoint> _heartRateDataList = [];
  List<HealthDataPoint> _stepsDataList = [];
  bool _isSmoking = false; // 推測使用者是否在抽菸

  @override
  void initState() {
    super.initState();
    fetchHealthData();
  }

  // 獲取心率和步數數據
  Future<void> fetchHealthData() async {
    List<HealthDataType> types = [HealthDataType.HEART_RATE, HealthDataType.STEPS];

    bool requested = await health.requestAuthorization(types);

    if (requested) {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));

      // 獲取健康數據
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);

      setState(() {
        // 分別提取步數和心率數據
        _heartRateDataList = healthData.where((data) => data.type == HealthDataType.HEART_RATE).toList();
        _stepsDataList = healthData.where((data) => data.type == HealthDataType.STEPS).toList();
        analyzeData(); // 分析數據並推測行為
      });
    }
  }

  // 分析心率和步數數據並推測使用者行為
  void analyzeData() {
    if (_heartRateDataList.isNotEmpty && _stepsDataList.isNotEmpty) {
      double averageHeartRate = _heartRateDataList
          .map((data) => data.value as double)
          .reduce((a, b) => a + b) / _heartRateDataList.length;

      // 步數是否增加
      int totalSteps = _stepsDataList
          .map((data) => data.value as int)
          .reduce((a, b) => a + b);

      // 假設：步數增加 + 心率上升的結合，推測使用者可能在抽菸
      if (averageHeartRate > 100 && totalSteps > 50) { // 例如步數增加50步，心率 > 100
        _isSmoking = true;
        showSmokingAlert(); // 提示使用者是否在抽菸
      }
    }
  }

  // 顯示推測結果的彈窗
  void showSmokingAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("您現在是否在抽菸？"),
          content: Text("根據您的心率和步數數據，我們推測您現在可能正在抽菸。"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isSmoking = true;
                });
                Navigator.of(context).pop();
              },
              child: Text("是"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSmoking = false;
                });
                Navigator.of(context).pop();
              },
              child: Text("否"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("不良行為檢測"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSmoking ? "我們推測您最近在抽菸。" : "目前無法確定您是否有不良行為。",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "心率數據:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _heartRateDataList.length,
                itemBuilder: (context, index) {
                  HealthDataPoint data = _heartRateDataList[index];
                  return ListTile(
                    title: Text("心率: ${data.value} bpm"),
                    subtitle: Text("時間: ${data.dateFrom}"),
                  );
                },
              ),
            ),
            Text(
              "步數數據:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _stepsDataList.length,
                itemBuilder: (context, index) {
                  HealthDataPoint data = _stepsDataList[index];
                  return ListTile(
                    title: Text("步數: ${data.value} 步"),
                    subtitle: Text("時間: ${data.dateFrom}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

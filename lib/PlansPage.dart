import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class PlansPage extends StatefulWidget {
  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  // 計畫類型選項
  String _selectedPlanType = '短期計畫';
  final List<String> _planTypes = ['長期計畫', '中期計畫', '短期計畫'];

  // 使用者輸入的目標
  final TextEditingController _goalController = TextEditingController();

  // 通知時間
  TimeOfDay _selectedTime = TimeOfDay.now();

  // 當前通知
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  List<Map<String, String>> _plans = []; // 儲存所有計畫

  @override
  void initState() {
    super.initState();
    _loadPlans();
    _initializeNotifications();
    tz.initializeTimeZones(); // 初始化時區數據
  }

  // 初始化通知
  void _initializeNotifications() {
    final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 顯示時間選擇器
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // 設定每日通知
  Future<void> _scheduleNotification(String planTitle, String planType, TimeOfDay time) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_reminder',
      'Daily Reminder',
      importance: Importance.max,
      priority: Priority.high,
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // 計算下一次通知時間
    final now = TimeOfDay.now();
    final scheduleTime = tz.TZDateTime.now(tz.local).add(Duration(
      hours: time.hour - now.hour,
      minutes: time.minute - now.minute,
    ));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      planType,  // 通知的標題
      planTitle,  // 通知的內容
      scheduleTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,  // 每天同一時間觸發
    );
  }

  // 保存並顯示計畫
  Future<void> _savePlan() async {
    String goal = _goalController.text;
    String planType = _selectedPlanType;

    if (goal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('請輸入目標')),
      );
      return;
    }

    // 保存計畫並設定通知
    setState(() {
      _plans.add({
        'type': planType,
        'goal': goal,
        'time': _selectedTime.format(context),
      });
    });

    // 設定每日通知
    await _scheduleNotification(goal, planType, _selectedTime);

    // 清空輸入框
    _goalController.clear();

    // 保存計畫到 SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('plans', _plans.map((plan) => plan['type']! + ':' + plan['goal']! + ':' + plan['time']!).toList());
  }

  // 載入已保存的計畫
  Future<void> _loadPlans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedPlans = prefs.getStringList('plans');

    if (savedPlans != null) {
      setState(() {
        _plans = savedPlans
            .map((plan) {
          List<String> planData = plan.split(':');
          return {
            'type': planData[0],
            'goal': planData[1],
            'time': planData[2],
          };
        })
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("健康計畫"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 選擇計畫類型
            DropdownButtonFormField<String>(
              value: _selectedPlanType,
              decoration: InputDecoration(labelText: '選擇計畫類型'),
              items: _planTypes.map((String planType) {
                return DropdownMenuItem<String>(
                  value: planType,
                  child: Text(planType),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPlanType = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            // 目標輸入框
            TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: '輸入您的目標'),
            ),
            SizedBox(height: 20),
            // 選擇時間
            Row(
              children: [
                Text("通知時間: ${_selectedTime.format(context)}"),
                Spacer(),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text("選擇時間"),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 新增計畫按鈕
            ElevatedButton(
              onPressed: _savePlan,
              child: Text("新增計畫"),
            ),
            SizedBox(height: 20),
            // 顯示所有計畫
            Expanded(
              child: ListView.builder(
                itemCount: _plans.length,
                itemBuilder: (context, index) {
                  final plan = _plans[index];
                  return ListTile(
                    title: Text(plan['goal']!),
                    subtitle: Text("${plan['type']} - 通知時間: ${plan['time']}"),
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


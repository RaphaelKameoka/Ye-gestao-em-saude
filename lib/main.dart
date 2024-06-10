import 'package:flutter/material.dart';
import 'package:ye_project/ye.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'Services/alarms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  AlarmService.initialize();
  runApp(Ye());
}

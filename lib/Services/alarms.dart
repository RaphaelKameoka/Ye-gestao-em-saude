import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';
import 'notification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart';

class AlarmService {
  static late AudioPlayer _audioPlayer;
  static final Uuid _uuid = Uuid();
  final ApiClient apiClient = ApiClient();

  static void initialize() {
    _audioPlayer = AudioPlayer();
    _initializeAlarmManager();
  }

  static Future<void> _initializeAlarmManager() async {
    await AndroidAlarmManager.initialize();
    print('Alarm manager initialized!');
  }

  static Future<void> setAlarm({
    required String medicationName,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay timeOfDay,
    required int intervalInHours,
    required String user_name,
    required String type,
  }) async {
    final now = DateTime.now();
    print('Current time: $now');
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    print('$medicationName');
    print('$startDate');
    print('$endDate');
    print("$timeOfDay");
    print("$intervalInHours");
    print('Selected date time: $selectedDateTime');

    final difference = selectedDateTime.difference(now);
    final seconds = difference.inSeconds;

    print('$seconds');

    if (seconds <= 0) {
      print('Selected time is in the past, cannot set alarm.');
      return;
    }

    final String alarmId = _uuid.v4();
    print('Alarm ID: $alarmId');
    print(alarmId.hashCode);
    await _sendAlarmToServer(
      medicationName: medicationName,
      startDate: startDate,
      endDate: endDate,
      timeOfDay: timeOfDay,
      intervalInHours: intervalInHours,
      user_name: user_name,
      type: type,
      alarmId: alarmId.hashCode,
    );

    await AndroidAlarmManager.periodic(
      Duration(hours: intervalInHours),
      alarmId.hashCode,
      _triggerAlarm,
      startAt: now.add(Duration(seconds: seconds)),
      exact: true,
      wakeup: true,
    );

    print('Alarm set for $selectedDateTime with ID: $alarmId and medication: $medicationName');
  }

  static Future<void> _sendAlarmToServer({
    required String medicationName,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay timeOfDay,
    required int intervalInHours,
    required String user_name,
    required String type,
    required int alarmId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'description': medicationName,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'timeOfDay': '${timeOfDay.hour}:${timeOfDay.minute}',
        'intervalInHours': intervalInHours,
        'user_name': user_name,
        'type': type,
        'alarmId': alarmId,
      };

      final http.Response response = await ApiClient().post('/alarms', data);

      if (response.statusCode == 200) {
        print('Alarm data sent to server successfully.');
      } else {
        print('Failed to send alarm data to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending alarm data to server: $e');
    }
  }

  static Future<void> _triggerAlarm(int alarmIdHash) async {
    print('Triggering alarm for ID hash: $alarmIdHash');
    final now = DateTime.now();
    print('Current time: $now');

    final data = await getMedicationInfo(alarmIdHash);
    if (data == null) {
      print('Medication info not found for alarm ID hash: $alarmIdHash');
      return;
    }

    final medicationName = data.containsKey('description') ? data['description'] as String : 'Unknown';
    final startDateString = data['startDate'] as String;
    final startDate = DateTime.parse(startDateString);
    final endDateString = data['endDate'] as String;
    final endDate = DateTime.parse(endDateString);

    print('Medication Name: $medicationName');
    print('Start Date: $startDate');
    print('End Date: $endDate');

    if (now.isAfter(startDate) && now.isBefore(endDate)) {
      print('Inside valid date range.');
      NotificationService().showNotification(
        title: 'Yee Saúde informa:',
        body: "Hora de tomar $medicationName",
      );
      print('Alarm triggered for $medicationName!');
      _playSound();
    } else {
      print('Alarm not triggered: Out of date range.');
    }
  }

  static void _playSound() async {
    print('Playing sound...');
    String assetPath = 'alarms/darkaria.mp3';
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setSource(AssetSource(assetPath));
    await audioPlayer.resume();
    print('Sound played.');
  }

  static Future<Map<String, dynamic>?> getMedicationInfo(int alarmIdHash) async {
    try {
      print(alarmIdHash);
      final http.Response response = await ApiClient().post('/get_alarms', {
        'alarm_id': alarmIdHash,
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
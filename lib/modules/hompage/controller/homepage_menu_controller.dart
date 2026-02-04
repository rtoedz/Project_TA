import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:project_ta/modules/hompage/model/history_model.dart';
import 'dart:math';

class HomepageMenuController extends GetxController {
  final _secureStorage = const FlutterSecureStorage();
  RxList<LearningHistory> learningHistory = <LearningHistory>[].obs;

  Future<String> loadAvatar() async {
    String? avatarPath = await _secureStorage.read(key: 'avatar');
    return avatarPath ?? '';
  }

  Future<String> loadName() async {
    String? name = await _secureStorage.read(key: 'name');
    return name ?? 'Krisna Prasetya';
  }

  Future<void> loadLearningHistory() async {
    try {
      developer.log('Loading learning history...');
      String? historyJson = await _secureStorage.read(key: 'learning_history');

      if (historyJson == null || historyJson.isEmpty) {
        developer
            .log('No learning history found in storage - loading defaults');
        _loadDefaultHistory();
        return;
      }

      List<dynamic> historyData = json.decode(historyJson);
      List<LearningHistory> history =
          historyData.map((item) => LearningHistory.fromJson(item)).toList();

      if (history.isEmpty) {
        _loadDefaultHistory();
      } else {
        learningHistory.assignAll(history);
      }

      update();
    } catch (e) {
      developer.log('ERROR loading learning history: $e');
      _loadDefaultHistory();
      update();
    }
  }

  void _loadDefaultHistory() {
    // Default data matching the design
    learningHistory.assignAll([
      LearningHistory(
        materialId: 1,
        title: "Visualisasi Spasial",
        progress: 50,
        lastAccessed: DateTime.now(),
      ),
      LearningHistory(
        materialId: 2,
        title: "Penjumlahan & Pengurangan",
        progress: 75,
        lastAccessed: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LearningHistory(
        materialId: 3,
        title: "Geometri Dasar",
        progress: 30,
        lastAccessed: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LearningHistory(
        materialId: 4,
        title: "Pola Bilangan",
        progress: 90,
        lastAccessed: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]);
  }

  @override
  void onInit() {
    super.onInit();
    loadAvatar();
    loadName();
    loadLearningHistory();
  }

  void onResume() {
    loadLearningHistory();
  }

  @override
  void onReady() {
    super.onReady();
    loadLearningHistory();

    Get.rootController.addListener(() {
      if (Get.currentRoute == '/home') {
        loadLearningHistory();
      }
    });
  }

  String formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }
}

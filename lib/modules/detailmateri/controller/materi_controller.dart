import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class MateriPageController extends GetxController {
  final RxBool canStartAnimation = false.obs;
  final RxList<MaterialProgress> materials = <MaterialProgress>[].obs;
  final RxDouble totalProgress = 0.0.obs;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    // Initialize materials list based on design
    materials.value = [
      MaterialProgress(
        id: 1,
        title: "Kubus dan Balok",
        description: "Pelajari cara mengidentifikasi dan...",
        progress: 75,
        iconData: Icons.grid_view,
        iconColor: Colors.amber,
        bgColor: const Color(0xFFFFF8E1),
      ),
      MaterialProgress(
        id: 2,
        title: "Bentuk 2D & 3D",
        description: "Pahami perbedaan antara bentuk...",
        progress: 50,
        iconData: Icons.category,
        iconColor: Colors.blue,
        bgColor: const Color(0xFFE3F2FD),
      ),
      MaterialProgress(
        id: 3,
        title: "Data dan Grafik",
        description: "Belajar membaca dan menafsirkan...",
        progress: 20,
        iconData: Icons.bar_chart,
        iconColor: Colors.pink,
        bgColor: const Color(0xFFFCE4EC),
      ),
      MaterialProgress(
        id: 4,
        title: "Pola Angka",
        description: "Kenali dan lanjutkan pola angka...",
        progress: 100, // Completed
        iconData:
            Icons.palette, // Using palette as placeholder for the design icon
        iconColor: Colors.green,
        bgColor: const Color(0xFFE8F5E9),
      ),
      MaterialProgress(
        id: 5,
        title: "Penjumlahan & Pengurangan",
        description: "Kuasai operasi matematika dasar...",
        progress: 90,
        iconData: Icons.calculate,
        iconColor: Colors.cyan,
        bgColor: const Color(0xFFE0F7FA),
      ),
    ];

    _loadProgress();
    initAnimation();
  }

  Future<void> _loadProgress() async {
    try {
      for (var material in materials) {
        String key = 'progress_material_${material.id}';
        String? value = await _storage.read(key: key);
        if (value != null) {
          int index = materials.indexWhere((m) => m.id == material.id);
          if (index != -1) {
            // Preserve static styling data while updating progress
            var current = materials[index];
            materials[index] = MaterialProgress(
              id: current.id,
              title: current.title,
              description: current.description,
              progress: double.parse(value),
              iconData: current.iconData,
              iconColor: current.iconColor,
              bgColor: current.bgColor,
            );
          }
        }
      }
      _calculateTotalProgress();
      materials.refresh();
      update();
    } catch (e) {
      print('Error loading progress: $e');
    }
  }

  void _calculateTotalProgress() {
    if (materials.isEmpty) {
      totalProgress.value = 0.0;
      return;
    }
    double sum = 0.0;
    for (var material in materials) {
      sum += material.progress;
    }
    totalProgress.value = sum / materials.length;
  }

  Future<void> updateProgress(int materialId, double newProgress) async {
    try {
      int index = materials.indexWhere((m) => m.id == materialId);
      if (index != -1 && newProgress > materials[index].progress) {
        var current = materials[index];
        materials[index] = MaterialProgress(
          id: current.id,
          title: current.title,
          description: current.description,
          progress: newProgress,
          iconData: current.iconData,
          iconColor: current.iconColor,
          bgColor: current.bgColor,
        );

        await _storage.write(
          key: 'progress_material_$materialId',
          value: newProgress.toString(),
        );

        _calculateTotalProgress();
        materials.refresh();
        update();
      }
    } catch (e) {
      print('Error updating progress: $e');
    }
  }

  Future<void> initAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    canStartAnimation.value = true;
  }
}

class MaterialProgress {
  final int id;
  final String title;
  final String description;
  final double progress;
  final IconData iconData;
  final Color iconColor;
  final Color bgColor;

  MaterialProgress({
    required this.id,
    required this.title,
    this.description = '',
    required this.progress,
    this.iconData = Icons.book,
    this.iconColor = Colors.blue,
    this.bgColor = Colors.white,
  });
}

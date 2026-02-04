import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressController extends GetxController {
  // Overall Progress
  final RxDouble overallProgress = 75.0.obs;

  // Sub Topics Data
  final List<Map<String, dynamic>> subTopics = [
    {
      "title": "Membangun Kubus",
      "progress": 0.9,
      "color": const Color(0xFF40E0D0) // Turquoise
    },
    {
      "title": "Rotasi Bentuk 3D",
      "progress": 0.7,
      "color": const Color(0xFF40E0D0)
    },
    {
      "title": "Menghitung Sisi",
      "progress": 0.6,
      "color": const Color(0xFF40E0D0)
    },
    {
      "title": "Proyeksi Ortografik",
      "progress": 0.85,
      "color": const Color(0xFF40E0D0)
    },
  ];

  // Timeline Data
  final List<Map<String, dynamic>> timeline = [
    {
      "title": "Modul 3: Membangun Kubus Selesai",
      "date": "12 Mei 2024",
      "type": "completed", // icon: check
      "color": const Color(0xFF40E0D0) // Turquoise
    },
    {
      "title": "Kuis Visualisasi Spasial Dikerjakan",
      "date": "10 Mei 2024",
      "type": "quiz", // icon: book/quiz
      "color": const Color(0xFFFFD700) // Gold/Yellow
    },
    {
      "title": "Modul 2: Rotasi Bentuk 3D Selesai",
      "date": "08 Mei 2024",
      "type": "completed",
      "color": const Color(0xFF40E0D0)
    },
    {
      "title": "Mendapat Lencana \"Pembangun Ahli\"",
      "date": "07 Mei 2024",
      "type": "reward", // icon: medal
      "color": const Color(0xFFFFD700)
    },
  ];

  // Rewards Data
  final List<Map<String, dynamic>> rewards = [
    {
      "title": "Lencana Bintang",
      "subtitle": "Penyelesaian Cepat",
      "color": const Color(0xFFFFD700), // Yellow
      "icon": Icons.star_border
    },
    {
      "title": "Piala Kreativitas",
      "subtitle": "Solusi Unik",
      "color": const Color(0xFF6495ED), // Cornflower Blue
      "icon": Icons.emoji_events_outlined
    },
    {
      "title": "Mahkota Presisi",
      "subtitle": "Akurasi Tinggi",
      "color": const Color(0xFFFF69B4), // Hot Pink
      "icon": Icons.psychology_outlined
    },
  ];

  // Recommendations Data
  final List<Map<String, dynamic>> recommendations = [
    {
      "title": "Kuis Tantangan Spasial",
      "action": "Mulai",
      "icon": Icons.emoji_events_outlined,
      "color": const Color(0xFFFFF8E1) // Light Yellow bg
    },
    {
      "title": "Modul Lanjutan Geometri",
      "action": "Mulai",
      "icon": Icons.menu_book_outlined,
      "color": const Color(0xFFFFF8E1)
    },
    {
      "title": "Latihan Memecahkan Teka-teki",
      "action": "Mulai",
      "icon": Icons.extension_outlined,
      "color": const Color(0xFFFFF8E1)
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Simulate loading or animation if needed
  }
}

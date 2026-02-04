import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/modules/detailmateri/controller/materi_controller.dart';
import 'package:project_ta/widgets/custom_button.dart';

class DetailMateriScreen extends StatelessWidget {
  const DetailMateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int index = Get.arguments ?? 0;
    final controller = Get.find<MateriPageController>();
    final material = controller.materials[index];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          material.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF40E0D0), // Cyan
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.check_box_outline_blank, // Cube-like icon
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          material.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${material.progress.toInt()}% Selesai',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tentang Pelajaran Ini
                  const Text(
                    'Tentang Pelajaran Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pelajaran ini memperkenalkan konsep dasar ${material.title.toLowerCase()} dan bagaimana cara membangunnya. Anda akan belajar mengenali sisi, sudut, dan rusuk melalui aktivitas interaktif.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Apa yang Akan Anda Pelajari
                  const Text(
                    'Apa yang Akan Anda Pelajari',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBulletPoint(
                      'Mengenali bentuk dasar dalam kehidupan sehari-hari.'),
                  _buildBulletPoint(
                      'Menghitung jumlah sisi, rusuk, dan titik sudut.'),
                  _buildBulletPoint(
                      'Membuat jaring-jaring dari bentuk dua dimensi.'),
                  _buildBulletPoint(
                      'Memahami volume dasar dan luas permukaan.'),

                  const SizedBox(height: 32),

                  // Detail Pelajaran
                  const Text(
                    'Detail Pelajaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                      Icons.access_time, 'Perkiraan Waktu', '25 menit'),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.book_outlined, 'Sumber Daya',
                      'Video interaktif, lembar kerja'),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: CustomButton(
              onPressed: () {
                Get.toNamed(AppRoutes.materiContent, arguments: index);
              },
              color: const Color(0xFF40E0D0),
              width: double.infinity,
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.play_arrow_outlined, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Mulai Pelajaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF40E0D0), size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

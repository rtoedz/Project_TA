import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/modules/hompage/controller/homepage_menu_controller.dart';
import 'package:project_ta/modules/detailmateri/controller/materi_controller.dart';

class HomepageMenuScreen extends StatelessWidget {
  const HomepageMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomepageMenuController());

    // Ensure history is refreshed when building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadLearningHistory();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Σ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // Navigate to settings if needed, or profile
              Get.toNamed(AppRoutes.profile);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Profile Greeting
            FutureBuilder<String>(
              future: controller.loadName(),
              builder: (context, snapshot) {
                final name = snapshot.data ?? 'Krisna Prasetya';
                return Row(
                  children: [
                    FutureBuilder<String>(
                      future: controller.loadAvatar(),
                      builder: (context, avatarSnapshot) {
                        if (avatarSnapshot.hasData &&
                            avatarSnapshot.data!.isNotEmpty) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(avatarSnapshot.data!),
                          );
                        }
                        return const CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              Color(0xFF8B0000), // Dark Red/Brown like in image
                          child: Icon(Icons.person, color: Colors.white),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Hai, $name!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), // Light yellow
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: controller.loadName(),
                          builder: (context, snapshot) {
                            final name = snapshot.data ?? 'Krisna Prasetya';
                            return Text(
                              'Halo, $name!',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Selamat datang kembali di petualangan matematikamu!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mascot
                  Image.asset(
                    'assets/images/mascot.png', // Ensure this exists, or use lottie
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.sentiment_very_satisfied,
                          size: 60, color: Colors.blue);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // History Section Title
            const Text(
              'Riwayat Belajar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // Learning History List
            GetBuilder<HomepageMenuController>(
              builder: (controller) {
                if (controller.learningHistory.isEmpty) {
                  return const Center(child: Text('Belum ada riwayat belajar'));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.learningHistory.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final history = controller.learningHistory[index];
                    return _buildHistoryCard(history);
                  },
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(history) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to detail
          try {
            if (Get.isRegistered<MateriPageController>()) {
              final materiController = Get.find<MateriPageController>();
              final materialIndex = materiController.materials
                  .indexWhere((m) => m.id == history.materialId);
              if (materialIndex != -1) {
                Get.toNamed(AppRoutes.detailMateri, arguments: materialIndex);
              } else {
                Get.toNamed(AppRoutes.detailMateri,
                    arguments: history.materialId);
              }
            } else {
              Get.toNamed(AppRoutes.detailMateri,
                  arguments: history.materialId);
            }
          } catch (e) {
            // Fallback
          }
        },
        child: Row(
          children: [
            // Circular Progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: history.progress / 100,
                    strokeWidth: 5,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(history.progress),
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${history.progress.toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getDescriptionForTitle(history.title),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 80) return const Color(0xFF40E0D0); // Turquoise
    if (progress >= 50) return const Color(0xFF40E0D0);
    return const Color(
        0xFF40E0D0); // Using same color as design seems to use one color theme
  }

  String _getDescriptionForTitle(String title) {
    if (title.contains("Visualisasi"))
      return "Pelajari cara mengenal bentuk dan pola dalam ruang tiga";
    if (title.contains("Penjumlahan"))
      return "Kuasai dasar-dasar matematika dengan latihan";
    if (title.contains("Geometri"))
      return "Perkenalkan dirimu pada dunia titik, garis, dan sudut. Fondasi";
    if (title.contains("Pola"))
      return "Temukan dan pahami pola yang ada dalam deret angka. Latih";
    return "Lanjutkan pembelajaran anda";
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/core/theme/app_colors.dart';
import 'package:project_ta/modules/detailquiz/controller/quizdetail_controller.dart';
import 'package:project_ta/widgets/custom_button.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final int score = args['score'] ?? 0;
    final int totalScore = 100; // Assuming 100 is max
    final int earnedPoints = args['earnedPoints'] ?? 0;
    final bool passed = score >= 80;

    // Determine which controller to use for reset logic
    // We might need to find the existing one or it might be deleted
    // Ideally, we should handle retry logic by navigating back effectively

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Hasil Kuis',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Hide back button
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.offAllNamed(AppRoutes.home);
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FA), // Light cyan background
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Lottie.asset(
                      passed
                          ? 'assets/lottie/trophy.json'
                          : 'assets/lottie/try_again.json',
                      height: 120,
                      repeat: false,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      passed ? 'Selamat!' : 'Tetap Semangat!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40E0D0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$score/$totalScore',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kamu mendapatkan $earnedPoints poin',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF40E0D0)),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${score}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40E0D0),
                        ),
                      ),
                      const Text(
                        'Akurasi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CustomButton(
                onPressed: () {
                  // Coba Lagi logic
                  // Check if attempts allow
                  if (Get.isRegistered<QuizdetailController>()) {
                    final controller = Get.find<QuizdetailController>();
                    if (controller.attemptsRemaining.value > 0) {
                      controller.resetQuiz();
                      Get.back(); // Go back to quiz detail
                    } else {
                      Get.snackbar('Kesempatan Habis',
                          'Kamu tidak memiliki kesempatan lagi untuk kuis ini.');
                    }
                  } else {
                    // If controller is gone, navigate to intro or detail (re-init)
                    Get.offNamed(AppRoutes.quizDetail,
                        arguments: {'id': args['id']});
                  }
                },
                color: Colors.white,
                width: double.infinity,
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    color: Color(0xFF40E0D0),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.home);
                },
                color: const Color(0xFF40E0D0),
                width: double.infinity,
                child: const Text(
                  'Lanjut Pelajaran',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

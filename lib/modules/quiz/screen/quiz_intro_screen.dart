import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/core/theme/app_colors.dart';
import 'package:project_ta/widgets/custom_button.dart';

class QuizIntroScreen extends StatelessWidget {
  const QuizIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final quizId = args['id'];
    // In a real app, we would fetch quiz details using quizId
    // For now, we'll use static/dummy data matching the design

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Rincian Kuis',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tantangan Matematika\nHarian',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40E0D0), // Cyan/Turquoise
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Uji kemampuan penjumlahan, pengurangan, dan perkalianmu dengan tantangan ini! Sempurna untuk melatih kecepatan dan akurasimu.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInfoRow(Icons.help_outline, '10 Pertanyaan'),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                        Icons.emoji_events_outlined, '80 Poin Potensial',
                        iconColor: Colors.amber),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.timer_outlined, '15 Menit Batas Waktu'),
                    const SizedBox(height: 32),
                    CustomButton(
                      onPressed: () {
                        // Navigate to the actual quiz
                        Get.toNamed(
                          AppRoutes.quizDetail,
                          arguments: args,
                        );
                      },
                      color: const Color(0xFF40E0D0),
                      width: double.infinity,
                      child: const Text(
                        'Mulai Kuis',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF40E0D0)).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? Colors.black87,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

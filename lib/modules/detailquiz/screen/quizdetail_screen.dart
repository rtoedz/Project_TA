import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta/modules/detailquiz/controller/quizdetail_controller.dart';
import 'package:project_ta/widgets/custom_button.dart';

class QuizdetailScreen extends StatelessWidget {
  const QuizdetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizdetailController>(
      init: QuizdetailController(),
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (!didPop) {
              await controller.handleEarlyExit(); // Or show dialog
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.black, size: 20),
                onPressed: () async {
                  await controller.handleEarlyExit();
                  Get.back();
                },
              ),
              title: const Text(
                '9:41', // Status bar time placeholder or empty
                style: TextStyle(color: Colors.transparent),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Text(
                                        'Pertanyaan ${controller.currentQuestionIndex.value + 1}/${controller.questions.length}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      )),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '01:23 tersisa', // Placeholder timer
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.lightbulb_outline,
                                  color: Colors.amber[300]),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Divider(color: Colors.grey[200]),
                          const SizedBox(height: 24),

                          // Question
                          Obx(() {
                            final question = controller.questions[
                                controller.currentQuestionIndex.value];
                            return Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.4,
                              ),
                            );
                          }),

                          const SizedBox(height: 32),

                          // Options
                          Obx(() {
                            final question = controller.questions[
                                controller.currentQuestionIndex.value];
                            return Column(
                              children: List.generate(question.options.length,
                                  (index) {
                                final isSelected =
                                    controller.selectedAnswerIndex.value ==
                                        index;
                                final isAnswered = controller.isAnswered.value;

                                // Color logic
                                Color borderColor = Colors.grey[200]!;
                                Color bgColor = Colors.white;
                                Color textColor = Colors.black;

                                if (isSelected) {
                                  borderColor = const Color(0xFF40E0D0); // Cyan
                                  bgColor =
                                      const Color(0xFFE0F7FA); // Light Cyan
                                  textColor = const Color(0xFF40E0D0);
                                }

                                return GestureDetector(
                                  onTap: () {
                                    if (!isAnswered) {
                                      controller.answerQuestion(index);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: borderColor, width: 2),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color(0xFF40E0D0)
                                                  : Colors.grey[400]!,
                                            ),
                                          ),
                                          child: Text(
                                            String.fromCharCode(65 + index),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? const Color(0xFF40E0D0)
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            question.options[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isSelected
                                                  ? const Color(0xFF40E0D0)
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle_outline,
                                              color: Color(0xFF40E0D0)),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey[100]!)),
                    ),
                    child: Column(
                      children: [
                        // Progress Bar Text
                        Obx(() => Row(
                              children: [
                                Text(
                                  'Progress: Pertanyaan ${controller.currentQuestionIndex.value + 1} dari ${controller.questions.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 8),
                        // Linear Progress
                        Obx(() => ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (controller.currentQuestionIndex.value +
                                        1) /
                                    controller.questions.length,
                                backgroundColor: Colors.grey[200],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF40E0D0)),
                                minHeight: 8,
                              ),
                            )),

                        const SizedBox(height: 24),

                        // Navigation Buttons
                        Row(
                          children: [
                            // Previous Button
                            Expanded(
                              child: Obx(() => CustomButton(
                                    onPressed: controller
                                                .currentQuestionIndex.value >
                                            0
                                        ? () => controller.previousQuestion()
                                        : () {}, // Disabled or no-op
                                    color: Colors.grey[100]!,
                                    child: Text(
                                      'Sebelumnya',
                                      style: TextStyle(
                                        color: controller.currentQuestionIndex
                                                    .value >
                                                0
                                            ? Colors.black
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ),
                            const SizedBox(width: 16),
                            // Next/Send Button
                            Expanded(
                              child: Obx(() => CustomButton(
                                    onPressed: () {
                                      if (controller
                                              .currentQuestionIndex.value <
                                          controller.questions.length - 1) {
                                        controller.nextQuestion();
                                      } else {
                                        controller.saveScore();
                                      }
                                    },
                                    color: const Color(0xFF40E0D0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.currentQuestionIndex
                                                      .value <
                                                  controller.questions.length -
                                                      1
                                              ? 'Selanjutnya'
                                              : 'Kirim',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.send,
                                            size: 16, color: Colors.white),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

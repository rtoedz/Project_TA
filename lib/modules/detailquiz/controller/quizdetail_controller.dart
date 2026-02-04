import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/modules/detailquiz/model/quiz_model.dart';
import 'package:project_ta/modules/detailquiz/widgets/quiz_done_popup.dart';
import 'package:project_ta/modules/quiz/controller/quiz_controller.dart';
import 'package:project_ta/widgets/custom_container.dart';

class QuizdetailController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxBool isAnswered = false.obs;
  final RxInt selectedAnswerIndex = (-1).obs;
  late List<Question> questions;
  late int materialId;

  // New properties for attempt tracking
  final RxInt attemptsRemaining = 2.obs; // Start with 2 attempts
  final RxBool isFirstAttempt = true.obs;
  final RxInt highestScore = 0.obs;
  final int minimumPassingScore = 80;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    materialId = Get.arguments['id'];

    // Load original questions and shuffle if needed
    questions = List.from(QuizData.materialQuestions[materialId] ?? []);

    // Ensure we have exactly 10 questions
    if (questions.length > 10) {
      questions = questions.sublist(0, 10);
    }

    // Load saved attempts and scores
    _loadAttempts();
    _loadScores();

    // Check if quiz retake is allowed
    checkQuizRetakeEligibility();
  }

  Future<void> _loadAttempts() async {
    final key = 'quiz_${materialId}_attempts';
    final attempts = await _secureStorage.read(key: key);

    if (attempts != null) {
      attemptsRemaining.value = int.tryParse(attempts) ?? 2;
      isFirstAttempt.value = attemptsRemaining.value == 2;
    }
  }

  Future<void> _loadScores() async {
    final key = 'quiz_${materialId}_points';
    final savedScore = await _secureStorage.read(key: key);

    if (savedScore != null) {
      highestScore.value = int.tryParse(savedScore) ?? 0;
    }
  }

  Future<void> _saveAttempts() async {
    final key = 'quiz_${materialId}_attempts';
    await _secureStorage.write(
        key: key, value: attemptsRemaining.value.toString());
  }

  // Handle early exit from quiz
  Future<void> handleEarlyExit() async {
    // Only reduce attempts and save score if they've started answering questions
    if (currentQuestionIndex.value > 0 || isAnswered.value) {
      // Decrease attempts
      if (attemptsRemaining.value > 0) {
        attemptsRemaining.value--;
        await _saveAttempts();
      }

      // Save current score
      final key = 'quiz_${materialId}_points';
      final storedScore = await _secureStorage.read(key: key);
      final previousScore = int.tryParse(storedScore ?? '0') ?? 0;

      // Only update if current score is higher than previous
      if (score.value > previousScore) {
        await _secureStorage.write(key: key, value: score.value.toString());
      }
    }

    // Refresh quiz list
    final quizController = Get.find<QuizController>();
    await quizController.refreshQuizPage();
  }

  /// Checks if user is eligible to take/retake this quiz and shows appropriate messages
  Future<void> checkQuizRetakeEligibility() async {
    await _loadScores();
    await _loadAttempts();

    // Get previous best score (if any)
    if (highestScore.value >= minimumPassingScore && !isFirstAttempt.value) {
      // If already passed and this is a retake attempt, show popup
      Future.delayed(Duration(milliseconds: 500), () {
        Get.dialog(
          AlertDialog(
            title: Text(
              'Poin Minimum Sudah Tercapai',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/success.json',
                  height: 100,
                  width: 100,
                  repeat: true,
                ),
                SizedBox(height: 16),
                Text(
                  'Kamu sudah mencapai nilai minimum (${highestScore.value} poin) untuk kuis ini.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Mengulang kuis ini tidak akan mengubah nilai kamu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedContainerButton(
                    alignment: Alignment.center,
                    containerColor: Colors.red,
                    onTap: () {
                      Get.back(result: true);
                      Get.back();
                    },
                    width: 120,
                    height: 60,
                    child: Text(
                      'Kembali ke Daftar Kuis',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AnimatedContainerButton(
                    alignment: Alignment.center,
                    containerColor: Colors.green,
                    onTap: () => Get.back(result: true),
                    width: 120,
                    height: 60,
                    child: Text(
                      'Tetap Mencoba',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          barrierDismissible: false,
        );
      });
    } else if (attemptsRemaining.value <= 0) {
      // If no attempts remaining, go back to quiz list
      Future.delayed(Duration(milliseconds: 500), () {
        Get.dialog(
          AlertDialog(
            title: Text('Kesempatan Habis'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/try_again.json',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 16),
                Text(
                  'Kamu sudah menggunakan semua kesempatan untuk kuis ini.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Nilai tertinggi kamu adalah ${highestScore.value} poin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back(); // Go back to quiz list
                },
                child: Text('Kembali ke Daftar Kuis'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      });
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void answerQuestion(int selectedAnswer) {
    if (!isAnswered.value) {
      selectedAnswerIndex.value = selectedAnswer;
      isAnswered.value = true;

      // Calculate points based on correct answer
      if (selectedAnswer ==
          questions[currentQuestionIndex.value].correctAnswer) {
        // Award points - each question is worth 10 points (total 100 points for 10 questions)
        score.value += 10;
      }
      update();
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      isAnswered.value = false;
      selectedAnswerIndex.value = -1;
      update();

      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      // We might need to restore the answer state if we want to support changing answers
      // For now, reset to unanswered or keep it simple as per design flow
      // Design implies we can go back.
      // If we go back, do we allow changing answer? Usually yes.
      // But current logic adds points immediately on answer. This might be tricky.
      // Simplification: Just go back to view.
      isAnswered.value = false; // Or store answers in a map/list
      selectedAnswerIndex.value = -1;
      update();
    }
  }

  Future<void> saveScore() async {
    if (currentQuestionIndex.value == questions.length - 1) {
      // Decrease attempts remaining for this quiz
      if (attemptsRemaining.value > 0) {
        attemptsRemaining.value--;
        await _saveAttempts();
      }

      // Calculate final score
      final currentScore = _calculateFinalScore();

      // Get previous best score (if any)
      final key = 'quiz_${materialId}_points';
      final storedScore = await _secureStorage.read(key: key);
      final previousScore = int.tryParse(storedScore ?? '0') ?? 0;

      // Only update if current score is higher
      final highestScore = max(currentScore, previousScore);
      await _secureStorage.write(key: key, value: highestScore.toString());

      // Update first attempt flag
      isFirstAttempt.value = false;

      // Navigate to result screen
      Get.offNamed(AppRoutes.quizResult, arguments: {
        'score': currentScore,
        'earnedPoints': currentScore, // Display current attempt score
        'totalQuestions': questions.length,
        'id': materialId,
      });

      // Refresh quiz scores in the main controller
      if (Get.isRegistered<QuizController>()) {
        final quizController = Get.find<QuizController>();
        quizController.loadScores();
      }
    }
  }

  int _calculateFinalScore() {
    int finalScore = score.value;

    // On second attempt, if the user didn't pass on the first attempt,
    // cap the score at 80 even if they get all questions correct
    if (!isFirstAttempt.value && highestScore.value < minimumPassingScore) {
      finalScore = min(finalScore, minimumPassingScore);
    }

    return finalScore;
  }

  void resetQuiz() {
    // Shuffle questions for the second attempt
    questions = List.from(QuizData.materialQuestions[materialId] ?? []);

    // Ensure we still have exactly 10 questions
    if (questions.length > 10) {
      questions = questions.sublist(0, 10);
    }

    // Shuffle the questions for the second attempt
    questions.shuffle();

    // Reset state
    currentQuestionIndex.value = 0;
    score.value = 0;
    isAnswered.value = false;
    selectedAnswerIndex.value = -1;
    update();
  }
}

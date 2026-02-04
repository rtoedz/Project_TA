import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/modules/quiz/controller/quiz_controller.dart';
import 'package:project_ta/widgets/custom_container.dart';

class KuisItems extends StatelessWidget {
  final KuisProgress material;

  const KuisItems({
    Key? key,
    required this.material,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!material.isUnlocked) {
          // Show dialog why quiz is locked - now showing clear material progress requirement
          _showLockReasonDialog(context);
        } else if (material.attemptsRemaining <= 0) {
          // Show dialog that attempts are exhausted
          _showNoAttemptsDialog(context);
        } else {
          // Navigate to quiz intro
          Get.toNamed(
            AppRoutes.quizIntro,
            arguments: {'id': material.id},
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Get.height * 0.02),
        padding: EdgeInsets.all(Get.width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Get.width * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: Get.width * 0.002,
              blurRadius: Get.width * 0.01,
              offset: Offset(0, Get.height * 0.002),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${material.id}: ${material.title}',
                    style: TextStyle(
                      fontSize: Get.width * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Heart icons for attempts (only if quiz is unlocked)
                if (material.isUnlocked)
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: material.attemptsRemaining >= 1
                            ? Colors.red
                            : Colors.grey[300],
                        size: Get.width * 0.05,
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.favorite,
                        color: material.attemptsRemaining >= 2
                            ? Colors.red
                            : Colors.grey[300],
                        size: Get.width * 0.05,
                      ),
                    ],
                  ),
                // Lock/unlock icon
                if (!material.isUnlocked)
                  Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: Get.width * 0.06,
                  ),
              ],
            ),
            SizedBox(height: Get.height * 0.01),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Get.width * 0.025),
                    child: LinearProgressIndicator(
                      value: material.progress / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(material.progress),
                      ),
                      minHeight: Get.height * 0.008,
                    ),
                  ),
                ),
                SizedBox(width: Get.width * 0.02),
                Text(
                  '${material.progress.toInt()} Poin',
                  style: TextStyle(
                    color: _getProgressColor(material.progress),
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * 0.03,
                  ),
                ),
              ],
            ),

            // Show material progress indicator for all quizzes, even locked first quiz
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progres Belajar:',
                          style: TextStyle(
                            fontSize: Get.width * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Get.width * 0.025),
                          child: LinearProgressIndicator(
                            value: material.materialProgress / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getMaterialProgressColor(
                                  material.materialProgress),
                            ),
                            minHeight: Get.height * 0.006,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Text(
                    '${material.materialProgress.toInt()}%',
                    style: TextStyle(
                      color:
                          _getMaterialProgressColor(material.materialProgress),
                      fontWeight: FontWeight.bold,
                      fontSize: Get.width * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLockReasonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(alignment: Alignment.center, child: Text('Kuis Terkunci')),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/lottie/locked.json',
                width: 150,
                height: 150,
                repeat: true,
              ),
            ),
            Text(
              material.materialProgress < 100
                  ? 'Kuis ini terkunci karena kamu belum mempelajari materi sepenuhnya.'
                  : 'Kuis ini terkunci karena kamu belum menyelesaikan kuis sebelumnya.',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            Text(
              'Progres belajar kamu: ${material.materialProgress.toInt()}%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              material.materialProgress < 100
                  ? 'Selesaikan materi terlebih dahulu untuk membuka kuis ini.'
                  : 'Selesaikan kuis sebelumnya dengan nilai minimal 80 untuk membuka kuis ini.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: AnimatedContainerButton(
              containerColor: Colors.green,
              width: Get.width * 0.6,
              height: Get.height * 0.06,
              onTap: () => Get.back(),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog to show when attempts are exhausted
  void _showNoAttemptsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
            alignment: Alignment.center,
            child: Text(material.progress >= 80
                ? 'Kamu sudah lulus untuk kuis ini'
                : 'Kesempatan Habis')),
        titleTextStyle: TextStyle(
          fontSize: material.progress >= 80 ? 18 : 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            material.progress >= 80
                ? SizedBox.shrink()
                : Lottie.asset('assets/lottie/heart.json',
                    repeat: false, reverse: true),
            SizedBox(height: material.progress >= 80 ? 0 : 16),
            material.progress >= 80
                ? SizedBox.shrink()
                : Text(
                    'Kamu telah menggunakan semua kesempatan untuk kuis ini',
                    textAlign: TextAlign.center,
                  ),
            SizedBox(height: 8),
            Text(
              'Poin Kamu: ${material.progress.toInt()} Poin',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              material.progress >= 80
                  ? 'Selamat! Kamu telah lulus kuis ini'
                  : 'Kuis berikutnya tetap terbuka karena kesempatan kamu telah habis',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: material.progress >= 80 ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: AnimatedContainerButton(
              containerColor: Colors.green,
              width: Get.width * 0.6,
              height: Get.height * 0.06,
              onTap: () => Get.back(),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 80) {
      return Colors.green;
    } else if (progress >= 40) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  Color _getMaterialProgressColor(double progress) {
    if (progress >= 100) {
      return Colors.green;
    } else if (progress >= 50) {
      return Colors.blue;
    } else {
      return Colors.amber;
    }
  }
}

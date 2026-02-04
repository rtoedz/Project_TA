import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta/modules/progress/controller/progress_controller.dart';
import 'package:hexcolor/hexcolor.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
      init: ProgressController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: const Text(
              'Visualisasi Spasial',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () {
                // Navigate back or to home
                Get.back();
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Overall Progress Card
                _buildOverallProgressCard(controller),
                const SizedBox(height: 30),

                // 2. Sub-Topics Progress
                _buildSectionTitle('Kemajuan Sub-Topik'),
                const SizedBox(height: 16),
                _buildSubTopicsList(controller),
                const SizedBox(height: 30),

                // 3. Timeline
                _buildSectionTitle('Linimasa Pembelajaran'),
                const SizedBox(height: 16),
                _buildTimeline(controller),
                const SizedBox(height: 30),

                // 4. Rewards
                _buildSectionTitle('Hadiah Diterima'),
                const SizedBox(height: 16),
                _buildRewards(controller),
                const SizedBox(height: 30),

                // 5. Recommendations
                _buildSectionTitle('Rekomendasi Selanjutnya'),
                const SizedBox(height: 16),
                _buildRecommendations(controller),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildOverallProgressCard(ProgressController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA), // Light cyan/blue background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kemajuan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Keseluruhan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lihat Detail',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: controller.overallProgress.value / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.white,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.black87),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${controller.overallProgress.value.toInt()}%',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Little dots on the circle could be added with CustomPainter if needed
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Luar Biasa! Terus tingkatkan keterampilanmu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTopicsList(ProgressController controller) {
    return Column(
      children: controller.subTopics.map((topic) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topic['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${(topic['progress'] * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: topic['progress'],
                backgroundColor: Colors.grey[200],
                color: topic['color'],
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeline(ProgressController controller) {
    return Column(
      children: List.generate(controller.timeline.length, (index) {
        final item = controller.timeline[index];
        final isLast = index == controller.timeline.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _getTimelineIconBgColor(item['type']),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTimelineIcon(item['type']),
                      color: Colors.black87,
                      size: 16,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.grey[300],
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['date'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Color _getTimelineIconBgColor(String type) {
    switch (type) {
      case 'completed':
        return const Color(0xFF40E0D0).withOpacity(0.3); // Light Turquoise
      case 'quiz':
        return const Color(0xFFFFD700).withOpacity(0.3); // Light Gold
      case 'reward':
        return const Color(0xFFFFD700).withOpacity(0.3); // Light Gold
      default:
        return Colors.grey[200]!;
    }
  }

  IconData _getTimelineIcon(String type) {
    switch (type) {
      case 'completed':
        return Icons.check;
      case 'quiz':
        return Icons.menu_book;
      case 'reward':
        return Icons.emoji_events;
      default:
        return Icons.circle;
    }
  }

  Widget _buildRewards(ProgressController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildRewardCard(controller.rewards[0])),
            const SizedBox(width: 16),
            Expanded(
                child: _buildRewardCard(controller.rewards[1], isBlue: true)),
          ],
        ),
        const SizedBox(height: 16),
        _buildRewardCard(controller.rewards[2], isPink: true),
      ],
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward,
      {bool isBlue = false, bool isPink = false}) {
    Color bgColor;
    if (isBlue) {
      bgColor = const Color(0xFF6495ED).withOpacity(0.2); // Light Blue
    } else if (isPink) {
      bgColor = const Color(0xFFFF69B4).withOpacity(0.2); // Light Pink
    } else {
      bgColor = const Color(0xFFFFD700).withOpacity(0.2); // Light Yellow
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(reward['icon'], size: 32, color: Colors.black87),
          const SizedBox(height: 8),
          Text(
            reward['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reward['subtitle'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(ProgressController controller) {
    return Column(
      children: controller.recommendations.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item['color'],
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'], color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  item['action'],
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

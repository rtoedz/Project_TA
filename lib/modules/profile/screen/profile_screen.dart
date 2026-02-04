import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/modules/profile/controller/profile_controller.dart';
import 'package:project_ta/modules/profile/widget/edit_avatar.dart';
import 'package:project_ta/modules/profile/widget/edit_name.dart';
import 'package:project_ta/modules/profile/widget/menu_itemlist.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            Get.offAllNamed(AppRoutes.home);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Get.height * 0.08),
              child: AppBar(
                scrolledUnderElevation: 0,
                title: const Text(
                  'Profil & Pengaturan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                centerTitle: true,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Profil Pengguna',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: (Get.width * 0.25).clamp(80.0, 100.0),
                                height: (Get.width * 0.25).clamp(80.0, 100.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Obx(() {
                                  if (controller.avatarPath.isEmpty) {
                                    return const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  } else {
                                    return ClipOval(
                                      child: Image.asset(
                                        controller.avatarPath.value,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                }),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                        EditAvatarDialog(
                                          controller: controller,
                                        ),
                                        barrierDismissible: false);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.015),
                          // Name Text
                          Obx(
                            () {
                              return Column(
                                children: [
                                  Text(
                                    controller.userName.value,
                                    style: TextStyle(
                                      fontSize:
                                          (Get.width * 0.05).clamp(18.0, 22.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.age.value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: Get.height * 0.02),

                          // Contact Parent Button
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.1),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Action to contact parent
                              },
                              icon: const Icon(Icons.phone_outlined,
                                  color: Colors.black54, size: 18),
                              label: const Text(
                                'Hubungi Orang Tua',
                                style: TextStyle(color: Colors.black87),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: Get.height * 0.03),

                          // Stats Grid
                          _buildStatsGrid(controller),

                          SizedBox(height: Get.height * 0.03),

                          // Settings Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pengaturan Aplikasi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Akun',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.materials.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.materials[index];
                                    return MenuItemlist(
                                      title: item.title,
                                      icon: item.icon,
                                      onTap: () {
                                        if (index == 0) {
                                          Get.dialog(
                                              EditNameDialog(
                                                controller: controller,
                                              ),
                                              barrierDismissible: false);
                                        } else if (index == 1) {
                                          Get.toNamed(AppRoutes.tentangKami);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Get.height * 0.05),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(ProfileController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light Yellow
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildStatItem(
            Icons.psychology_outlined,
            controller.lessonsCompleted.value.toString(),
            'Pelajaran Selesai',
            Colors.orange,
          ),
          _buildStatItem(
            Icons.lightbulb_outline,
            controller.quizzesPassed.value.toString(),
            'Kuis Berhasil',
            Colors.orange,
          ),
          _buildStatItem(
            Icons.access_time,
            '${controller.studyHours.value} Jam',
            'Waktu Belajar',
            Colors.orange,
          ),
          _buildStatItem(
            Icons.star_border,
            controller.starsCollected.value.toString(),
            'Bintang Dikumpulkan',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

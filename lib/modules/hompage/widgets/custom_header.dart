import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project_ta/core/theme/app_colors.dart';
import 'package:project_ta/modules/hompage/controller/homepage_menu_controller.dart';
import 'package:project_ta/modules/hompage/widgets/user_details.dart';

class CustomHeader extends StatelessWidget {
  final HomepageMenuController controller;

  const CustomHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Get.height * 0.4,
      decoration: const BoxDecoration(
        color: AppColors.tealPrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: Get.height * 0.05,
            left: Get.width * 0.04,
            right: Get.width * 0.04,
            child: UserDetailsWidget(
              controller: controller,
            ),
          ),
          Positioned(
            top: Get.height * 0.16,
            left: Get.width * 0.04,
            right: Get.width * 0.04,
            child: Container(
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Lottie.asset(
                    'assets/lottie/maskot.json',
                    width: Get.width * 0.35,
                  ),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: controller.loadName(),
                      builder: (context, snapshot) {
                        String name =
                            snapshot.connectionState == ConnectionState.waiting
                                ? '...'
                                : (snapshot.data ?? 'User');
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, $name',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Get.width * 0.045,
                                color: AppColors.darkGray,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Text(
                              'Langkah kecil hari ini bisa jadi kesuksesan besar esok.',
                              style: TextStyle(
                                fontSize: Get.width * 0.035,
                                color: AppColors.midGray,
                              ),
                            ),
                            Text(
                              'Yuk, mulai belajar! 💡',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Get.width * 0.035,
                                color: AppColors.tealPrimary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

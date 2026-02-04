import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/modules/hompage/controller/homepage_menu_controller.dart';

class UserDetailsWidget extends StatelessWidget {
  final HomepageMenuController controller;
  const UserDetailsWidget({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.profile),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
              0.2), // Transparent white for better contrast on Teal
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            FutureBuilder<String>(
              future: controller.loadAvatar(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    padding: const EdgeInsets.all(2), // White stroke
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                      ),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(2), // White stroke
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(snapshot.data!),
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.all(2), // White stroke
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.teal),
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FutureBuilder<String>(
                future: controller.loadName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const Text(
                      'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
            ),
            Icon(Icons.settings, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

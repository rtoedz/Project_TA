import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta/core/theme/app_colors.dart';
import 'package:project_ta/modules/detailmateri/screen/materi_screen.dart';
import 'package:project_ta/modules/homescreen/controller/homescreen_controller.dart';
import 'package:project_ta/modules/hompage/screen/homepage_menu_screen.dart';
import 'package:project_ta/modules/profile/screen/profile_screen.dart';
import 'package:project_ta/modules/progress/screen/progress_screen.dart';
import 'package:project_ta/modules/quiz/screen/quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> homeWidgets = [
      HomepageMenuScreen(), // 0: Beranda
      MateriPageScreen(), // 1: Belajar
      QuizScreen(), // 2: Kuis
      ProgressScreen(), // 3: Progres
      ProfileScreen(), // 4: Profil
    ];

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.softGray,
            body: Obx(() => homeWidgets[controller.navIndex]),
            bottomNavigationBar: Obx(() => _buildBottomNavBar(controller)),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar(HomeController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: controller.navIndex,
        onTap: controller.setNavIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.tealPrimary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Belajar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Kuis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Progres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

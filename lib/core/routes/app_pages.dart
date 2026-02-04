import 'package:get/get.dart';
import 'package:project_ta/modules/detailmateri/screen/materi_screen.dart';
import 'package:project_ta/modules/detailquiz/screen/quiz_result_screen.dart';
import 'package:project_ta/modules/detailquiz/screen/quizdetail_screen.dart';
import 'package:project_ta/modules/firsttimeuser/screen/firsttime_user_screen.dart';
import 'package:project_ta/modules/homescreen/screen/homescreen.dart';
import 'package:project_ta/modules/hompage/screen/homepage_menu_screen.dart';
import 'package:project_ta/modules/materipagescreen/screen/detail_materi_screen.dart';
import 'package:project_ta/modules/materipagescreen/screen/materi_content_screen.dart';
import 'package:project_ta/modules/profile/screen/profile_screen.dart';
import 'package:project_ta/modules/quiz/screen/quiz_intro_screen.dart';
import 'package:project_ta/modules/splash_screen/screen/splash_screen.dart';
import 'package:project_ta/modules/sumberreferensi/screen/referensi_screen.dart';
import 'package:project_ta/modules/tentangkami/tentang_kami_screen.dart';
import 'package:project_ta/modules/login/screen/login_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.homeMenu, page: () => const HomepageMenuScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppRoutes.detailMateri, page: () => MateriPageScreen()),
    GetPage(name: AppRoutes.detailPageMateri, page: () => DetailMateriScreen()),
    GetPage(name: AppRoutes.materiContent, page: () => MateriContentScreen()),
    GetPage(name: AppRoutes.firsttimeuser, page: () => FirsttimeUserScreen()),
    GetPage(name: AppRoutes.profile, page: () => ProfileScreen()),
    GetPage(name: AppRoutes.quizIntro, page: () => QuizIntroScreen()),
    GetPage(name: AppRoutes.quizDetail, page: () => QuizdetailScreen()),
    GetPage(name: AppRoutes.quizResult, page: () => QuizResultScreen()),
    GetPage(name: AppRoutes.tentangKami, page: () => AboutUsScreen()),
    GetPage(name: AppRoutes.referensiSumber, page: () => ReferensiScreen()),
  ];
}

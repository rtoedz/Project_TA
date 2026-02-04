import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final _secureStorage = const FlutterSecureStorage();
  RxString avatarPath = ''.obs;
  RxString userName = ''.obs;
  RxString errorMessage = ''.obs;

  // Stats
  final RxInt lessonsCompleted = 12.obs;
  final RxInt quizzesPassed = 8.obs;
  final RxInt studyHours = 25.obs;
  final RxInt starsCollected = 150.obs;
  final RxString age = '8 tahun'.obs;

  TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAvatar();
    loadName();
  }

  Future<void> updateAvatar(String newAvatarPath) async {
    await _secureStorage.write(key: 'avatar', value: newAvatarPath);
    avatarPath.value = newAvatarPath;
  }

  Future<void> loadAvatar() async {
    String? savedAvatar = await _secureStorage.read(key: 'avatar');
    avatarPath.value = savedAvatar ?? '';
  }

  Future<void> loadName() async {
    String? savedName = await _secureStorage.read(key: 'name');
    userName.value = savedName ?? 'User';
  }

  Future<void> updateName(String newName) async {
    if (newName.isNotEmpty) {
      await _secureStorage.write(key: 'name', value: newName);
      userName.value = newName;
      nameController.clear();
    }
  }

  final List<ItemProfile> materials = [
    ItemProfile(
      icon: 'assets/images/pofile/edit_nama.svg',
      title: "Ganti Nama kamu",
    ),
    ItemProfile(
      icon: 'assets/images/pofile/tentang_kami.svg',
      title: "Tentang Kami",
    ),
    // ItemProfile(
    //   icon: 'assets/images/pofile/referensi.svg',
    //   title: "Sumber & Referensi",
    // ),
  ];
}

class ItemProfile {
  final String icon;
  final String title;

  ItemProfile({
    required this.icon,
    required this.title,
  });
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta/modules/materipagescreen/controller/detail_materi_controller.dart';
import 'package:project_ta/modules/materipagescreen/widgets/customheader_materi.dart';
import 'package:project_ta/modules/materipagescreen/widgets/pembelajarandua.dart';
import 'package:project_ta/modules/materipagescreen/widgets/pembelajaransatu.dart';
import 'package:project_ta/modules/materipagescreen/widgets/pembelajarantiga.dart';

class MateriContentScreen extends StatelessWidget {
  const MateriContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int args = Get.arguments ?? 0;

    return GetBuilder<DetailMateriController>(
      init: DetailMateriController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Kembali',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios,
                  size: 25, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF009CE1),
            titleSpacing: 0,
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              controller.update();
              return false;
            },
            child: SingleChildScrollView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomheaderMateri(args: args),
                  SizedBox(height: Get.height * 0.01),
                  if (args == 0)
                    const Pembelajaransatu()
                  else if (args == 1)
                    const Pembelajarandua()
                  else if (args == 2)
                    const Pembelajarantiga()
                  else
                    const Center(child: Text('Materi Tidak Ditemukan'))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

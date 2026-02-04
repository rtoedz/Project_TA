import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_ta/core/routes/app_routes.dart';
import 'package:project_ta/modules/detailmateri/controller/materi_controller.dart';

class MateriPageScreen extends StatelessWidget {
  const MateriPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return GetBuilder<MateriPageController>(
      init: MateriPageController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.black, size: 20),
              onPressed: () {
                // Navigate back
                Get.back();
              },
            ),
            title: const Text(
              'Materi Pembelajaran',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.05,
              vertical: Get.height * 0.02,
            ),
            itemCount: controller.materials.length,
            itemBuilder: (context, index) {
              final material = controller.materials[index];
              return _buildMaterialItem(material);
            },
          ),
        );
      },
    );
  }

  Widget _buildMaterialItem(MaterialProgress material) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.detailPageMateri,
          arguments:
              Get.find<MateriPageController>().materials.indexOf(material),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: material.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                material.iconData,
                color: material.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    material.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Progress or Check
            const SizedBox(width: 8),
            if (material.progress >= 100)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.cyan, width: 2),
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.cyan),
              )
            else
              Text(
                '${material.progress.toInt()}%',
                style: const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

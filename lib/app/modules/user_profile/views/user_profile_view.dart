import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_profile_controller.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Add swipe-to-go-back functionality
      onHorizontalDragEnd: (DragEndDetails details) {
        // Check if the swipe was from left to right with sufficient velocity
        if (details.primaryVelocity != null && details.primaryVelocity! > 200) {
          Get.back();
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        // Optional: Add visual feedback during swipe (you can implement this later)
        // For now, we'll just handle the gesture
        if (details.delta.dx > 20) {
          // User is swiping right significantly
          // You could add visual feedback here like changing opacity
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.title.value)),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Get.back(),
            tooltip: 'Go back',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Get.back(),
              tooltip: 'Close',
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => controller.onRefresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.widgets,
                            size: 64,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome to UserProfile Module',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This is a generated UI module with navigation controls.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '💡 Tip: Swipe right or use the back/close buttons to navigate back!',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.lightBlue[300]
                                          : Colors.blue[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.onRefresh,
                    child: const Text('Refresh Data'),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

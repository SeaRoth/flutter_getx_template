import 'package:get/get.dart';

class UserProfileController extends GetxController {
  // Reactive variables
  final RxString title = 'UserProfile Module'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('UserProfileController initialized');
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  @override
  void onClose() {
    print('UserProfileController disposed');
    super.onClose();
  }

  // Methods
  void loadData() async {
    try {
      isLoading.value = true;
      // TODO: Implement data loading logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
      print('Data loaded for UserProfile');
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onRefresh() {
    loadData();
  }
}

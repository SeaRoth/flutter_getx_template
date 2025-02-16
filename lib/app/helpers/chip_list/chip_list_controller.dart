import 'package:flutter_getx_template/app/helpers/shared_pref_manager.dart';
import 'package:get/get.dart';

class ChipListController extends GetxController {
  final String preferenceKey;
  final RxList<int> selectedMatchQueueIds = <int>[].obs;

  ChipListController({required this.preferenceKey});

  @override
  void onReady() {

    super.onReady();
  }

  @override
  void onInit() {
    loadMultiSelectState();
    super.onInit();
  }

  Future<void> loadMultiSelectState() async {
    final sharedPrefsManager = SharedPrefsManager();
    selectedMatchQueueIds.value = await sharedPrefsManager.getIntList(preferenceKey);
  }

  Future<void> saveMultiSelectState() async {
    final sharedPrefsManager = SharedPrefsManager();
    await sharedPrefsManager.saveIntList(preferenceKey, selectedMatchQueueIds.value);
  }
}

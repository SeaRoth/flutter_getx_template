import 'package:flutter_getx_template/app/helpers/shared_pref_manager.dart';
import 'package:get/get.dart';

class ChipListController extends GetxController {
  final String preferenceKey;
  final RxList<int> selectedMatchQueueIds = <int>[0].obs;

  ChipListController({required this.preferenceKey});

  @override
  void onInit() {
    loadMultiSelectState();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
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

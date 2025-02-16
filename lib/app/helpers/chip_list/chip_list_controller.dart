import 'package:flutter_getx_template/app/helpers/shared_pref_manager.dart';
import 'package:get/get.dart';

class ChipListController extends GetxController {
  final String preferenceKey;
  final RxList<int> selectedMatchQueueIds = <int>[0].obs;
  final bool multiSelect;

  ChipListController({required this.preferenceKey, required this.multiSelect});

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
    final tempList = await sharedPrefsManager.getIntList(preferenceKey);
    if(multiSelect == false && tempList.isEmpty) {
      tempList.add(0);
    }
    selectedMatchQueueIds.value = tempList;
  }

  Future<void> saveMultiSelectState() async {
    final sharedPrefsManager = SharedPrefsManager();
    await sharedPrefsManager.saveIntList(preferenceKey, selectedMatchQueueIds.value);
  }
}

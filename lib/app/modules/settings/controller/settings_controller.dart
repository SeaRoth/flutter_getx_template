import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/helpers/scroll_position_manager.dart';
import 'package:flutter_getx_template/app/modules/loading/loading_controller.dart';
import 'package:flutter_getx_template/app/modules/our_controller.dart';
import 'package:flutter_getx_template/app/modules/theme_controller.dart';
import 'package:get/get.dart';

class SettingsController extends OurController {
  var settingsText = "settings text from controller".obs;
  final ThemeController themeController = Get.find<ThemeController>();
  final loadingController = Get.find<LoadingController>();

  final ScrollController scrollController = ScrollController();
  static const String pageKey = 'settings_page';

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_saveScrollPositionSync);
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptScrollRestore();
    });
  }

  void onViewResumed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptScrollRestore();
    });
  }

  void _saveScrollPositionSync() {
    if (scrollController.hasClients) {
      final position = scrollController.position.pixels;
      ScrollPositionManager.instance.saveScrollPosition(pageKey, position);
    }
  }

  Future<void> _saveScrollPosition() async {
    if (scrollController.hasClients) {
      final position = scrollController.position.pixels;
      await ScrollPositionManager.instance
          .saveScrollPosition(pageKey, position);
    }
  }

  void _attemptScrollRestore() {
    _restoreScrollPosition();
    Future.delayed(const Duration(milliseconds: 50), _restoreScrollPosition);
    Future.delayed(const Duration(milliseconds: 150), _restoreScrollPosition);
    Future.delayed(const Duration(milliseconds: 300), _restoreScrollPosition);
    Future.delayed(const Duration(milliseconds: 600), _restoreScrollPosition);
    Future.delayed(const Duration(milliseconds: 1000), _restoreScrollPosition);
  }

  void _restoreScrollPosition() {
    if (scrollController.hasClients &&
        scrollController.position.hasContentDimensions) {
      final savedPosition =
          ScrollPositionManager.instance.getScrollPosition(pageKey);
      if (savedPosition > 0) {
        final maxScrollExtent = scrollController.position.maxScrollExtent;
        final targetPosition =
            savedPosition > maxScrollExtent ? maxScrollExtent : savedPosition;

        try {
          scrollController.jumpTo(targetPosition);

          Future.delayed(const Duration(milliseconds: 100), () {
            if (scrollController.hasClients) {
              final currentPosition = scrollController.position.pixels;
              if ((currentPosition - targetPosition).abs() > 10) {
                scrollController.jumpTo(targetPosition);
              }
            }
          });
        } catch (e) {
          // Silently handle restoration errors
        }
      }
    }
  }

  Future<void> saveBeforeNavigation() async {
    await _saveScrollPosition();
  }

  void restoreAfterNavigation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _attemptScrollRestore();
    });
  }

  @override
  void onClose() {
    scrollController.removeListener(_saveScrollPositionSync);
    _saveScrollPositionSync();
    scrollController.dispose();
    super.onClose();
  }
}

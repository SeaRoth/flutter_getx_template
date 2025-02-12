import 'package:flutter_getx_template/app/modules/details/bindings/details_binding.dart';
import 'package:flutter_getx_template/app/modules/details/views/details_view.dart';
import 'package:flutter_getx_template/app/modules/home/bindings/home_binding.dart';
import 'package:flutter_getx_template/app/modules/home/views/home_view.dart';
import 'package:flutter_getx_template/app/modules/main/bindings/main_binding.dart';
import 'package:flutter_getx_template/app/modules/main/views/main_view.dart';

import 'package:flutter_getx_template/app/modules/settings/bindings/settings_binding.dart';
import 'package:flutter_getx_template/app/modules/settings/views/settings_view.dart';
import 'package:get/get.dart';

import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initialPageRoute = Routes.routeHome;

  static final routes = [
    GetPage(
      name: '/',
      page: () => const RootView(),
      binding: RootBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      children: [
        GetPage(
          preventDuplicates: true,
          name: _Paths.pathHome,
          page: () => const HomeView(),
          bindings: [
            HomeBinding(),
          ],
          title: null,
          children: [
            GetPage(name: _Paths.pathRewards, page: () => const MainView(), preventDuplicates: true, title: 'Ranked View', binding: MainBinding()),
            GetPage(middlewares: [
              //only enter this route when authed
              //EnsureAuthMiddleware(),
            ], name: _Paths.pathTasks, page: () => const DetailsView(), title: 'Summoner List View', transition: Transition.size, binding: DetailsBinding()),
            GetPage(
              name: _Paths.pathProfile,
              title: "Settings",
              transition: Transition.size,
              page: () => const SettingsView(),
              binding: SettingsBinding(),
            ),
          ],
        ),
      ],
    ),
  ];
}

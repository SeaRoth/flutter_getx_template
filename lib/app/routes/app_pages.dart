import 'package:flutter_getx_template/app/modules/home/bindings/home_binding.dart';
import 'package:flutter_getx_template/app/modules/home/views/home_view.dart';
import 'package:flutter_getx_template/app/modules/profile/bindings/profile_binding.dart';
import 'package:flutter_getx_template/app/modules/profile/views/profile_view.dart';
import 'package:flutter_getx_template/app/modules/rewards/bindings/rewards_binding.dart';
import 'package:flutter_getx_template/app/modules/rewards/views/rewards_view.dart';
import 'package:flutter_getx_template/app/modules/tasks/bindings/tasks_binding.dart';
import 'package:flutter_getx_template/app/modules/tasks/views/tasks_view.dart';
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
            GetPage(
                name: _Paths.pathRewards, page: () => const RewardsView(), preventDuplicates: true, title: 'Ranked View', binding: RewardsBinding()),
            GetPage(
                middlewares: [
                  //only enter this route when authed
                  //EnsureAuthMiddleware(),
                ],
                name: _Paths.pathTasks,
                page: () => const TasksView(),
                title: 'Summoner List View',
                transition: Transition.size,
                binding: TasksBinding()),
            GetPage(
              name: _Paths.pathProfile,
              title: "Settings",
              transition: Transition.size,
              page: () => const ProfileView(),
              binding: ProfileBinding(),
            ),
          ],
        ),
      ],
    ),
  ];
}

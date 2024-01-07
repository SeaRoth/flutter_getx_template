import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GetRouterOutlet.builder(
            route: Routes.routeHome,
            builder: (context) {
              return Scaffold(
                body: Stack(children: [
                  Obx(() => Visibility(
                        visible: controller.finishedLeagueInit.isTrue,
                        child: GetRouterOutlet(
                          initialRoute: Routes.routeRewards,
                          anchorRoute: Routes.routeHome,
                        ),
                      )),
                ]),
                bottomNavigationBar: IndexedRouteBuilder(
                    routes: const [Routes.routeRewards, Routes.routeTasks, Routes.routeProfile],
                    builder: (context, routes, index) {
                      final delegate = context.delegate;
                      return BottomNavigationBar(
                        currentIndex: index,
                        onTap: (value) => delegate.toNamed(routes[value]),
                        items: const [
                          // _Paths.HOME + [Empty]
                          BottomNavigationBarItem(
                            icon: Icon(Icons.stars_rounded),
                            label: 'Rewards',
                          ),
                          // _Paths.HOME + Routes.PROFILE
                          BottomNavigationBarItem(
                            icon: Icon(Icons.account_box_rounded),
                            label: 'Tasks',
                          ),
                          // _Paths.HOME + _Paths.PRODUCTS
                          BottomNavigationBarItem(
                            icon: Icon(Icons.account_box_rounded),
                            label: 'Profile',
                          ),
                        ],
                      );
                    }),
              );
            },
          ),
        ),
      ],
    );
  }
}

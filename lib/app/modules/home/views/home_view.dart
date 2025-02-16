import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/helpers/bottom_sheet_helper.dart';
import 'package:flutter_getx_template/app/modules/home/views/my_custom_bottom_nav_bar.dart';
import 'package:flutter_getx_template/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.details_rounded), label: 'Add'),
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage('assets/icon_small.png'),
          color: Colors.black,
        ),
        label: 'My Label',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'People'),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ];
    return Column(
      children: [
        Expanded(
          child: GetRouterOutlet.builder(
            route: Routes.routeHome,
            builder: (context) {
              return Scaffold(
                body: Stack(children: [
                  GetRouterOutlet(
                    initialRoute: Routes.routeMain,
                    anchorRoute: Routes.routeHome,
                  ),
                ]),
                bottomNavigationBar: IndexedRouteBuilder(
                    routes: const [Routes.routeMain, Routes.routeDetails, "add button", Routes.routeSettings],
                    builder: (context, routes, index) {
                      final delegate = context.delegate;

                      return CustomBottomNavigationBar(
                          currentIndex: index,
                          onTap: (value) {
                            if (value == 2) {
                              createBottomSheetDialog(context: context, contentsWidget: Text("hi"), headerWidget: Text("hi"));
                            } else {
                              delegate.toNamed(routes[value]);
                            }
                          },
                          items: items);
                      //   items: const [
                      //     // _Paths.HOME + [Empty]
                      //     BottomNavigationBarItem(
                      //       icon: Icon(Icons.stars_rounded),
                      //       label: 'Main',
                      //     ),
                      //     // _Paths.HOME + Routes.PROFILE
                      //     BottomNavigationBarItem(
                      //       icon: Icon(Icons.account_box_rounded),
                      //       label: 'Details',
                      //     ),
                      //     // _Paths.HOME + _Paths.PRODUCTS
                      //     BottomNavigationBarItem(
                      //       icon: Icon(Icons.account_box_rounded),
                      //       label: 'Settings',
                      //     ),
                      //   ],
                      // );

                      // return BottomNavigationBar(
                      //   currentIndex: index,
                      //   onTap: (value) => delegate.toNamed(routes[value]),
                      //   items: const [
                      //     // _Paths.HOME + [Empty]
                      //     BottomNavigationBarItem(
                      //       icon: Icon(Icons.stars_rounded),
                      //       label: 'Main',
                      //     ),
                      //     // _Paths.HOME + Routes.PROFILE
                      //     BottomNavigationBarItem(
                      //       icon: Icon(Icons.account_box_rounded),
                      //       label: 'Details',
                      //     ),
                      //     // _Paths.HOME + _Paths.PRODUCTS
                      //     BottomNavigationBarItem(
                      //       icon: Icon(Icons.account_box_rounded),
                      //       label: 'Settings',
                      //     ),
                      //   ],
                      // );
                    }),
              );
            },
          ),
        ),
      ],
    );
  }
}

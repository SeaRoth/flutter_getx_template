import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_getx_template/app/helpers/bottom_sheet_helper.dart';
import 'package:flutter_getx_template/app/modules/home/views/my_custom_bottom_nav_bar.dart';
import 'package:flutter_getx_template/app/modules/loading/loading_view.dart';
import 'package:flutter_getx_template/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:flutter/services.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Add'),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_box_outlined),
        label: 'My Label',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.people), label: 'People'),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ];
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                          routes: const [Routes.routeMain, Routes.routeDetails, "add button", Routes.routeFriends, Routes.routeSettings],
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
                          }),
                    );
                  },
                ),
              ),
            ],
          ),
          LoadingView()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_getx_template/app/modules/theme_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const navBarHeight = 32.0; // Further reduced from 40 to 32
    const fabRadius = 28.0; // Standard FAB radius

    return Container(
      height: navBarHeight +
          bottomPadding, // Dynamic height: content + safe area only
      child: Stack(
        children: [
          // Background painter - extends to full height including safe area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GetBuilder<ThemeController>(
              builder: (controller) {
                return CustomPaint(
                  size: Size(MediaQuery.of(context).size.width,
                      navBarHeight + bottomPadding),
                  painter: BottomNavBarPainter(
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor, // Use scaffold background
                    bottomPadding: bottomPadding,
                    navBarHeight: navBarHeight,
                  ),
                );
              },
            ),
          ),
          // Navigation icons
          Positioned(
            bottom: bottomPadding + 2, // Reduced padding from 6px to 2px
            left: 0,
            right: 0,
            child: SizedBox(
              height: 28, // Keep icon area height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < widget.items.length; i++)
                    if (i == widget.items.length / 2)
                      SizedBox(width: fabRadius * 2) // Space for FAB
                    else
                      SizedBox(
                        width: 48, // Constrain width
                        height: 28, // Constrain height
                        child: InkWell(
                          onTap: () => widget.onTap(i),
                          borderRadius: BorderRadius.circular(14),
                          child: Center(
                            child: widget.items[i].icon is Icon
                                ? Icon(
                                    (widget.items[i].icon as Icon).icon,
                                    size: 22,
                                    color: widget.currentIndex == i
                                        ? Colors.blue
                                        : Colors.grey,
                                  )
                                : widget.items[i].icon is ImageIcon
                                    ? ImageIcon(
                                        (widget.items[i].icon as ImageIcon)
                                            .image,
                                        size: 22,
                                        color: widget.currentIndex == i
                                            ? Colors.blue
                                            : Colors.grey,
                                      )
                                    : SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: widget.items[i]
                                            .icon, // Use the widget directly (handles SizedBox, Image, etc.)
                                      ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          // Floating Action Button
          Positioned(
            top: 0, // FAB extends above the nav bar
            left: MediaQuery.of(context).size.width / 2 - fabRadius,
            child: FloatingActionButton(
              onPressed: () => widget.onTap(widget.items.length ~/ 2),
              backgroundColor: Colors.blue,
              child: widget.items[widget.items.length ~/ 2].icon is Icon
                  ? widget.items[widget.items.length ~/ 2].icon
                  : widget.items[widget.items.length ~/ 2].icon is ImageIcon
                      ? ImageIcon(
                          (widget.items[widget.items.length ~/ 2].icon
                                  as ImageIcon)
                              .image,
                          color: Colors.white,
                        )
                      : widget.items[widget.items.length ~/ 2].icon,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBarPainter extends CustomPainter {
  final Color backgroundColor;
  final double bottomPadding;
  final double navBarHeight;

  BottomNavBarPainter({
    required this.backgroundColor,
    this.bottomPadding = 0,
    this.navBarHeight = 56.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Create the curved notch for the FAB
    final notchWidth = size.width * 0.25; // Width of the notch
    final notchHeight = 15.0; // Reduced notch depth (was 20.0)
    final centerX = size.width * 0.5;

    // Left side to notch start
    path.lineTo(centerX - notchWidth / 2, 0);

    // Curved notch for FAB
    path.quadraticBezierTo(centerX, -notchHeight, centerX + notchWidth / 2, 0);

    // Right side from notch end
    path.lineTo(size.width, 0);

    // Right edge down to bottom of entire area (including safe area)
    path.lineTo(
        size.width, size.height); // This ensures color fills to very bottom

    // Bottom edge across full width
    path.lineTo(0, size.height);

    // Left edge up to start
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

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
    const navBarHeight = 60.0; // Standard height for bottom nav bar
    const fabRadius = 28.0;

    // Ensure minimum padding for devices without safe areas
    final effectiveBottomPadding = bottomPadding < 8 ? 8.0 : bottomPadding;

    return Container(
      height: navBarHeight + effectiveBottomPadding,
      child: Stack(
        children: [
          // Background with notch
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GetBuilder<ThemeController>(
              builder: (controller) {
                return CustomPaint(
                  size: Size(MediaQuery.of(context).size.width,
                      navBarHeight + effectiveBottomPadding),
                  painter: BottomNavBarPainter(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    bottomPadding: effectiveBottomPadding,
                    navBarHeight: navBarHeight,
                  ),
                );
              },
            ),
          ),
          // Navigation icons
          Positioned(
            bottom: effectiveBottomPadding + 8,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < widget.items.length; i++)
                    if (i == widget.items.length ~/ 2)
                      SizedBox(width: fabRadius * 2 + 16) // More space for FAB
                    else
                      SizedBox(
                        width: 50,
                        height: 44,
                        child: InkWell(
                          onTap: () => widget.onTap(i),
                          borderRadius: BorderRadius.circular(22),
                          child: Center(
                            child: widget.items[i].icon is Icon
                                ? Icon(
                                    (widget.items[i].icon as Icon).icon,
                                    size: 26,
                                    color: widget.currentIndex == i
                                        ? Colors.blue
                                        : Colors.grey[600],
                                  )
                                : widget.items[i].icon is ImageIcon
                                    ? ImageIcon(
                                        (widget.items[i].icon as ImageIcon)
                                            .image,
                                        size: 26,
                                        color: widget.currentIndex == i
                                            ? Colors.blue
                                            : Colors.grey[600],
                                      )
                                    : SizedBox(
                                        width: 26,
                                        height: 26,
                                        child: widget.items[i].icon,
                                      ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          // Floating Action Button positioned properly in the notch
          Positioned(
            top: 4, // Small offset from the very top
            left: MediaQuery.of(context).size.width / 2 - fabRadius,
            child: Container(
              width: fabRadius * 2,
              height: fabRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => widget.onTap(widget.items.length ~/ 2),
                  borderRadius: BorderRadius.circular(fabRadius),
                  child: Center(
                    child: widget.items[widget.items.length ~/ 2].icon is Icon
                        ? Icon(
                            (widget.items[widget.items.length ~/ 2].icon
                                    as Icon)
                                .icon,
                            color: Colors.white,
                            size: 28,
                          )
                        : widget.items[widget.items.length ~/ 2].icon
                                is ImageIcon
                            ? ImageIcon(
                                (widget.items[widget.items.length ~/ 2].icon
                                        as ImageIcon)
                                    .image,
                                color: Colors.white,
                                size: 28,
                              )
                            : Container(
                                width: 28,
                                height: 28,
                                child: ClipOval(
                                  child: widget
                                      .items[widget.items.length ~/ 2].icon,
                                ),
                              ),
                  ),
                ),
              ),
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
    this.navBarHeight = 60.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Calculate dimensions for a clean notch
    final centerX = size.width * 0.5;
    final notchRadius = 32.0; // Slightly larger than FAB radius for clearance
    final notchMargin = 8.0; // Space around the notch

    // Start from top-left
    path.moveTo(0, 0);

    // Left side to notch
    path.lineTo(centerX - notchRadius - notchMargin, 0);

    // Create smooth semicircular notch
    path.arcToPoint(
      Offset(centerX + notchRadius + notchMargin, 0),
      radius: Radius.circular(notchRadius + notchMargin),
      clockwise: false,
    );

    // Right side from notch
    path.lineTo(size.width, 0);

    // Right edge down to bottom
    path.lineTo(size.width, size.height);

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

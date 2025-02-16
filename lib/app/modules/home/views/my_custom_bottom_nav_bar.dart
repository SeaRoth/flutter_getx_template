import 'package:flutter/material.dart';

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
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 60),
            painter: BottomNavBarPainter(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < widget.items.length; i++)
                if (i == widget.items.length / 2)
                  const SizedBox(width: 56)
                else
                  IconButton(
                    icon: widget.items[i].icon is Icon
                        ? widget.items[i].icon
                        : ImageIcon(
                      (widget.items[i].icon as ImageIcon).image,
                      color: widget.currentIndex == i ? Colors.blue : Colors.grey,
                    ),
                    color: widget.currentIndex == i ? Colors.blue : Colors.grey,
                    onPressed: () => widget.onTap(i),
                  ),
            ],
          ),
          Positioned(
            top: 0,
            child: FloatingActionButton(
              onPressed: () => widget.onTap(widget.items.length ~/ 2),
              backgroundColor: Colors.blue,
              child: widget.items[widget.items.length ~/ 2].icon is Icon
                  ? widget.items[widget.items.length ~/ 2].icon
                  : ImageIcon(
                (widget.items[widget.items.length ~/ 2].icon as ImageIcon).image,
                color: Colors.greenAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.4, 0);
    path.quadraticBezierTo(size.width * 0.5, -20, size.width * 0.6, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
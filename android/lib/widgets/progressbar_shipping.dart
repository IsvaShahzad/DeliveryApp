import 'package:flutter/material.dart';

class ProgressBarShipping extends StatelessWidget {
  final List<String> steps;
  final int currentIndex;

  const ProgressBarShipping({
    Key? key,
    required this.steps,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, 50), // Adjust height as needed
            painter: ProgressLineShipping(
              stepCount: steps.length,
              stepWidth: 60.0, // Adjust width as needed
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Extra space for the first circle
              ...List.generate(
                steps.length,
                    (index) => Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 40, // Adjust size if needed
                        height: 40, // Adjust size if needed
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index <= currentIndex ? Colors.blueGrey : Colors.blueGrey,
                          border: Border.all(
                            color: index <= currentIndex ? Colors.blueGrey : Colors.blueGrey,
                            width: 2, // Border width
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(), // Display the step number
                            style: TextStyle(
                              color: index <= currentIndex ? Colors.white : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 16, // Adjust font size if needed
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        steps[index], // Display the title below the circle
                        style: TextStyle(
                          color: index <= currentIndex ? Colors.black38 : Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12, // Adjust font size if needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Extra space for the last circle
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressLineShipping extends CustomPainter {
  final int stepCount;
  final double stepWidth;

  ProgressLineShipping({required this.stepCount, required this.stepWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke; // Use stroke to create lines

    // Ensure the line spans the entire width
    double totalWidth = size.width;
    double spacing = totalWidth / (stepCount - 1);

    for (int i = 0; i < stepCount - 1; i++) {
      final startOffset = Offset(spacing * i, size.height / 2);
      final endOffset = Offset(spacing * (i + 1), size.height / 2);
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

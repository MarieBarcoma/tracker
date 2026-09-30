import 'package:flutter/material.dart';
import 'package:expense_tracker/pages/home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141518),
      body: SafeArea(
        child: Stack(
          children: [
            // Top right big orange/red glowing sun/sphere effect matching reference
            Positioned(
              top: -20,
              right: -30,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF3D00),
                      const Color(0xFFFFB300).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Background wave lines and star sparkles
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundCurvesPainter(),
              ),
            ),

            // Main Content Layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // Tilted Floating Mastercard Preview
                  Center(
                    child: Transform.rotate(
                      angle: -0.06,
                      child: Container(
                        width: 290,
                        height: 175,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF23242A).withValues(alpha: 0.95),
                              const Color(0xFF111215).withValues(alpha: 0.95),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 25,
                              offset: const Offset(0, 12),
                            ),
                          ],
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Mastercard Logo
                                Row(
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEB001B),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(-11, 0),
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Added Name
                                const Text(
                                  'Marie Barcoma',
                                  style: TextStyle(
                                    color: Color.fromARGB(179, 255, 255, 255),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'My Wallet',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      '* * * *    * * * *    1 4 3',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        letterSpacing: 2.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Centered Section for Titles, Subtitle, and Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Hollow Outline Font Style for "EXPENSE"
                      Text(
                        'EXPENSE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.5
                            ..color = Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Solid Bold Font Style for "TRACKER"
                      const Text(
                        'TRACKER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Subtitle Description Centered
                      const Text(
                        'The right app make it easy to manage your expenses on the go. Personal Capital · Expensify',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Next Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF141518),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.05, size.width, size.height * 0.2);

    path.moveTo(0, size.height * 0.45);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.38, size.width, size.height * 0.5);

    canvas.drawPath(path, paint);

    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    void drawSparkle(double x, double y) {
      canvas.drawLine(Offset(x - 6, y), Offset(x + 6, y), starPaint);
      canvas.drawLine(Offset(x, y - 6), Offset(x, y + 6), starPaint);
    }

    drawSparkle(size.width * 0.45, size.height * 0.12);
    drawSparkle(size.width * 0.30, size.height * 0.22);
    drawSparkle(size.width * 0.82, size.height * 0.46);
    drawSparkle(size.width * 0.47, size.height * 0.48);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
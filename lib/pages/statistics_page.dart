import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // Selected timeframe tab: 0 = Week, 1 = Month, 2 = Year
  int selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Top App Bar row with Back button, Title, and Share icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF141518), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Text(
                  'Statistics',
                  style: TextStyle(
                    color: Color(0xFF141518),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.ios_share_rounded, color: Color(0xFF141518), size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Total Balance & Date Header
            const Center(
              child: Column(
                children: [
                  Text(
                    '\$5480.00',
                    style: TextStyle(
                      color: Color(0xFF141518),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sep 16, 2021',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Timeframe Selector Pill (Week, Month, Year)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildTabButton('Week', 0),
                  _buildTabButton('Month', 1),
                  _buildTabButton('Year', 2),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Custom Wave Chart Widget with Tooltip Overlay
            Container(
              height: 220,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  // Wave Graphic Painter
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WaveChartPainter(),
                    ),
                  ),
                  // Tooltip floating above Sep peak point
                  Positioned(
                    top: 15,
                    left: 175,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        '\$268.04',
                        style: TextStyle(
                          color: Color(0xFF141518),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Month Labels Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Jun', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text('Jul', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text('Aug', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text('Sep', style: TextStyle(color: Color(0xFF141518), fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('Oct', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text('Nov', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Top Spending Section Header
            const Text(
              'Top Spending',
              style: TextStyle(
                color: Color(0xFF141518),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Spending Item 1: iPhone 13
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.apple, color: Colors.black, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'iPhone 13',
                            style: TextStyle(
                              color: Color(0xFF141518),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '23 Aug, 2021',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    '-\$745.00',
                    style: TextStyle(
                      color: Color(0xFF141518),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // Spending Item 2: Payoneer
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.circle_outlined, color: Colors.orange, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Payoneer',
                            style: TextStyle(
                              color: Color(0xFF141518),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '15 Aug, 2021',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    '-\$35.00',
                    style: TextStyle(
                      color: Color(0xFF141518),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper builder for toggle pill tabs
  Widget _buildTabButton(String text, int index) {
    bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF141518) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Painter to draw the smooth spline waveform chart and the specific Sep data point circle
class WaveChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF141518)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Smooth bezier curve coordinates simulating the statistics wave trend
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.15, size.height * 0.85,
      size.width * 0.25, size.height * 0.35,
      size.width * 0.4, size.height * 0.45,
    );
    path.cubicTo(
      size.width * 0.5, size.height * 0.55,
      size.width * 0.55, size.height * 0.25,
      size.width * 0.7, size.height * 0.48,
    );
    path.cubicTo(
      size.width * 0.85, size.height * 0.7,
      size.width * 0.9, size.height * 0.1,
      size.width, size.height * 0.2,
    );

    canvas.drawPath(path, paint);

    // Draw interactive highlighted point circle for Sep (approx center)
    final pointPaint = Paint()
      ..color = const Color(0xFF141518)
      ..style = PaintingStyle.fill;

    final innerWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Center point position matching Sep dip
    Offset sepPoint = Offset(size.width * 0.55, size.height * 0.48);

    canvas.drawCircle(sepPoint, 8, pointPaint);
    canvas.drawCircle(sepPoint, 4, innerWhitePaint);

    // Dashed guide line dropping down from Sep point
    final dashPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;

    double startY = sepPoint.dy + 10;
    double endY = size.height - 5;
    while (startY < endY) {
      canvas.drawLine(Offset(sepPoint.dx, startY), Offset(sepPoint.dx, startY + 4), dashPaint);
      startY += 8;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
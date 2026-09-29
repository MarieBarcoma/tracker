import 'package:flutter/material.dart';
import 'package:expense_tracker/pages/home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration or Logo Icon
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF5C73F2).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(30),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 80,
                  color: Color(0xFF5C73F2),
                ),
              ),
              const SizedBox(height: 40),

              // Title
              const Text(
                'Marie\nExpense Tracker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Take control of your finances, track your spending, and achieve your financial goals with ease.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 50),

              // Get Started Button
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
                    backgroundColor: const Color.fromARGB(255, 219, 55, 159),
                    foregroundColor: const Color.fromARGB(255, 14, 1, 1),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
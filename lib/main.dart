import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/pages/welcome_page.dart'; // Import the welcome page

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open hive box
  await Hive.openBox("expense_database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(), // Set WelcomePage as the initial entry point
      ),
    );
  }
}
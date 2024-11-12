import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/pages/home/home_page.dart';
import 'package:todo_app/providers/task_group_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/providers/theme_provider.dart'; // Novo import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dbytniimigkfzepepyja.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRieXRuaWltaWdrZnplcGVweWphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA4NDYyNDgsImV4cCI6MjA0NjQyMjI0OH0.xAlNz2oG_T4fpQzENdh5INpxj3L-5I2ag24PzHA69ZE',
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => TaskGroupProvider()..listTaskGroups(),
      ),
      ChangeNotifierProvider(
        create: (_) => TaskProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task APP',
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData.light(
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
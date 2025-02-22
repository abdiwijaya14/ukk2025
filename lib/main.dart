import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://drqqhvbjomnkemfjabnd.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRycXFodmJqb21ua2VtZmphYm5kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc1OTQxNTEsImV4cCI6MjA1MzE3MDE1MX0.pydtORdL-fHAvdigTRo8LLvw1uo2XSeEWUJ511yPOL4",
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

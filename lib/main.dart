import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TawseelAlBadeerApp());
}

class TawseelAlBadeerApp extends StatelessWidget {
  const TawseelAlBadeerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'توصيل البدير',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'System',
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          // جلب دور المستخدم من قاعدة البيانات وتوجيهه للصفحة المخصصة
          return FutureBuilder<DataSnapshot>(
            future: FirebaseDatabase.instance
                .ref('users/${snapshot.data!.uid}')
                .get(),
            builder: (context, userSnap) {
              if (userSnap.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (userSnap.hasData && userSnap.data!.value != null) {
                final userData = Map<String, dynamic>.from(
                    userSnap.data!.value as Map);
                final role = userData['role'];
                final status = userData['status'];

                if (role == 'driver' && status != 'approved') {
                  FirebaseAuth.instance.signOut();
                  return const LoginScreenError(
                      error: '⏳ حسابك ككابتن قيد المراجعة وبانتظار موافقة الإدارة.');
                }

                if (role == 'admin') {
                  return const AdminPanelScreen();
                } else if (role == 'driver') {
                  return const DriverDashboardScreen();
                }
              }
              return const CustomerHomeScreen();
            },
          );
        }
        return const LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول - توصيل البدير')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('مرحباً بك في تطبيق توصيل البدير',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // الانتقال لتسجيل الدخول أو المتجر كزائر
              },
              child: const Text('دخول المتجر والتسوق السريع'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreenError extends StatelessWidget {
  final String error;
  const LoginScreenError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red)),
        ),
      ),
    );
  }
}

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('لوحة تحكم المدير')));
}

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('بوابة الكابتن')));
}

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('واجهة الزبون والمتجر')));
}

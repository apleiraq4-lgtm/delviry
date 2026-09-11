import 'package:flutter/material.dart';

void main() {
  runApp(const BudayrDeliveryApp());
}

class BudayrDeliveryApp extends StatelessWidget {
  const BudayrDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'توصيل البدير',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RoleSelectionScreen(),
    );
  }
}

// 1. شاشة اختيار دور المستخدم (البدء)
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق توصيل البدير - اختيار الواجهة'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.local_shipping, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text(
              'أهلاً بك في نظام توصيل البدير',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerScreen()));
              },
              icon: const Icon(Icons.person),
              label: const Text('واجهة الزبون (طلب توصيل)', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CaptainScreen()));
              },
              icon: const Icon(Icons.delivery_dining),
              label: const Text('واجهة الكابتن (السائقين)', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminScreen()));
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('واجهة الإدارة (الأدمن)', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. واجهة الزبون
class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _orderController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب توصيل جديد - البدير'), backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(labelText: 'تفاصيل الطلب (مثال: وجبة طعام، أوراق...)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'العنوان بالتفصيل داخل البدير', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_orderController.text.isNotEmpty && _addressController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلبك بنجاح إلى الإدارة والكابتن')));
                  _orderController.clear();
                  _addressController.clear();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              child: const Text('تأكيد وإرسال الطلب'),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. واجهة الكابتن (السائق)
class CaptainScreen extends StatelessWidget {
  const CaptainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> availableOrders = [
      {'id': '1', 'details': 'توصيل طلب مطعم', 'address': 'السوق - قرب المجمع'},
      {'id': '2', 'details': 'توصيل مواد إلكترونية', 'address': 'حي العسكري'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('طلبات الكابتن المتاحة'), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: availableOrders.length,
        itemBuilder: (context, index) {
          final order = availableOrders[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.motorcycle, color: Colors.orange),
              title: Text('طلب #${order['id']} - ${order['details']}'),
              subtitle: Text('العنوان: ${order['address']}'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم قبول الطلب #${order['id']} بنجاح')));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('قبول'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 4. واجهة الأدمن (الإدارة)
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم الإدارة - البدير'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('إحصائيات النظام العامة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('الطلبات النشطة', '12', Colors.blue),
                _buildStatCard('الكابتن المتاحين', '5', Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            const Text('إدارة الطلبات الحالية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('طلب #101 - أحمد محمد'),
                subtitle: const Text('الحالة: قيد التوصيل بواسطة الكابتن علي'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الطلب')));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color)),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

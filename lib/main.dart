import 'package:flutter/material.dart';

void main() {
  runApp(const BadeerDeliveryApp());
}

// نموذج البيانات المشترك للطلبات
class OrderItem {
  final String id;
  final String customerName;
  final String phone;
  final String details;
  final String type; // 'متجر' أو 'تكسي'
  String status;

  OrderItem({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.details,
    required this.type,
    this.status = 'قيد الانتظار',
  });
}

// قائمة طلبات تجريبية للنظام
List<OrderItem> globalOrders = [
  OrderItem(id: '1', customerName: 'علي حسن', phone: '07800000000', details: 'وجبة سريعة من المتجر', type: 'متجر', status: 'بانتظار المندوب'),
  OrderItem(id: '2', customerName: 'محمد كاظم', phone: '07700000000', details: 'طلب توصيل تكسي فوري', type: 'تكسي', status: 'قيد التنفيذ'),
];

class BadeerDeliveryApp extends StatelessWidget {
  const BadeerDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'توصيل البدير',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// الشاشة الرئيسية والترحيبية (index.html equivalent)
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FEE7),
      appBar: AppBar(
        title: const Text('متجر وتكسي البدير'),
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.local_shipping, size: 80, color: Color(0xFF16A34A)),
            const SizedBox(height: 20),
            const Text(
              'أهلاً بك في منصة البدير الذكية',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagerScreen()));
              },
              icon: const Icon(Icons.store),
              label: const Text('دخول المتجر والتسوق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminScreen()));
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('لوحة الإدارة الشاملة (Admin)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// واجهة المتجر والتسوق (manager.html equivalent)
class ManagerScreen extends StatelessWidget {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متجر البدير - المنتجات'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الأقسام المتاحة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(label: const Text('الكل'), backgroundColor: Colors.blue.shade100),
                const SizedBox(width: 8),
                const Chip(label: const Text('مأكولات')),
                const SizedBox(width: 8),
                const Chip(label: const Text('مواد عامة')),
              ],
            ),
            const SizedBox(height: 20),
            const Text('المنتجات المعروضة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildProductCard(context, 'وجبة سريعة', '3,500 د.ع'),
                  _buildProductCard(context, 'مشروب غازي', '1,000 د.ع'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String price) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fastfood, size: 40, color: Color(0xFF2563EB)),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(price, style: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تمت إضافة $name إلى السلة')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('أضف للسلة', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// لوحة الإدارة الشاملة (admin.html equivalent)
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز العمليات والإدارة العامة'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('متابعة الطلبات المباشرة والتكسي:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: globalOrders.length,
                itemBuilder: (context, index) {
                  final order = globalOrders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(
                        order.type == 'تكسي' ? Icons.local_taxi : Icons.shopping_bag,
                        color: order.type == 'تكسي' ? Colors.blue : Colors.green,
                      ),
                      title: Text('طلب #${order.id} - الزبون: ${order.customerName}'),
                      subtitle: Text('التفاصيل: ${order.details}\nالحالة: ${order.status}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            globalOrders.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حذف الطلب بنجاح')),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

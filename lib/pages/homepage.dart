import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/produk_page.dart';
import 'package:flutter_application_1/pages/pelanggan_page.dart';
import 'package:flutter_application_1/pages/user_page.dart';
import 'package:flutter_application_1/pages/pembayaran_page.dart';
import 'package:flutter_application_1/widgets/drawer_menu.dart';
import 'package:flutter_application_1/widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    ProdukPage(),
    PelangganPage(),
    UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]), // Tampilan sesuai tab
          if (_selectedIndex == 0) // Tombol hanya muncul di Dashboard
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PembayaranPage()),
                    );
                  },
                  icon: Icon(Icons.payment),
                  label: Text("Pembayaran"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Dashboard", style: TextStyle(fontSize: 24)),
    );
  }
}

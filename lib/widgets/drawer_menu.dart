import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/services/supabase_service.dart';
import 'package:flutter_application_1/pages/pelanggan_page.dart';



class DrawerMenu extends StatelessWidget {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Menu",
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Produk"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/produk");
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Pelanggan"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PelangganPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await _supabaseService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()), // Kembali ke Login
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

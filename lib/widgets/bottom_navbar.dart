import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/transaksi_page.dart'; // Import halaman transaksi

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Produk'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pelanggan'),
        BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'User'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Riwayat'), // Tambahan Riwayat Transaksi
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue, // Warna ikon saat dipilih
      unselectedItemColor: Colors.black, // Warna ikon saat tidak dipilih
      onTap: (index) {
        if (index == 4) { // Jika "Riwayat" ditekan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransaksiPage()), // Arahkan ke halaman transaksi
          );
        } else {
          onItemTapped(index); // Jalankan fungsi navigasi yang sudah ada
        }
      },
      type: BottomNavigationBarType.fixed, // Agar semua label terlihat
    );
  }
}

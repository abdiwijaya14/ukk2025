import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_application_1/services/supabase_service.dart';

class PembayaranPage extends StatefulWidget {
  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final SupabaseService supabaseService = SupabaseService();
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> pelangganList = [];
  Map<int, int> jumlahBeli = {};
  String? selectedPelanggan;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final produkData = await supabaseService.fetchProduk();
      final pelangganData = await supabaseService.fetchPelanggan();
      
      setState(() {
        produkList = produkData.map((item) => {
          'produkid': item['ProdukID'] ?? 0,
          'namaproduk': item['NamaProduk'] ?? 'Produk Tidak Diketahui',
          'harga': item['Harga'] ?? 0.0,
          'stok': item['Stok'] ?? 0,
        }).toList();

        pelangganList = pelangganData.map((item) => {
          'pelangganid': item['pelangganID'] ?? 0,
          'namapelanggan': item['namapelanggan'] ?? 'Pelanggan Tidak Diketahui',
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error saat mengambil data: $e');
    }
  }

  void tambahProduk(int index) {
    int produkId = produkList[index]['produkid'];
    int stok = produkList[index]['stok'];
    setState(() {
      jumlahBeli[produkId] = (jumlahBeli[produkId] ?? 0) + 1;
      if (jumlahBeli[produkId]! > stok) {
        jumlahBeli[produkId] = stok;
      }
    });
  }

  void kurangiProduk(int index) {
    int produkId = produkList[index]['produkid'];
    setState(() {
      if (jumlahBeli.containsKey(produkId) && jumlahBeli[produkId]! > 0) {
        jumlahBeli[produkId] = jumlahBeli[produkId]! - 1;
        if (jumlahBeli[produkId] == 0) {
          jumlahBeli.remove(produkId);
        }
      }
    });
  }

Future<void> prosesPembayaran() async {
  if (selectedPelanggan == null || jumlahBeli.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Pilih pelanggan dan tambahkan produk!'),
    ));
    return;
  }

  int totalHarga = jumlahBeli.entries.fold(0, (total, entry) {
    var produk = produkList.firstWhere((p) => p['produkid'] == entry.key);
    return total + (produk['harga'] as num).toInt() * entry.value;
  });

  int diskon = (totalHarga * 3) ~/ 100;
  int pajak = (totalHarga * 2) ~/ 100;
  int totalBayar = totalHarga - diskon + pajak;

  try {
    // Insert ke tabel penjualan
    final penjualanResponse = await supabaseService.client.from('penjualan').insert({
      'TanggalPenjualan': DateTime.now().toIso8601String(),
      'TotalHarga': totalBayar,
      'PelangganID': int.parse(selectedPelanggan!),
    }).select('PenjualanID').single();

    final penjualanid = penjualanResponse['PenjualanID'];
    print("✅ Penjualan berhasil disimpan! ID: $penjualanid");

    // Insert ke tabel detail penjualan
    for (var entry in jumlahBeli.entries) {
      var produk = produkList.firstWhere((p) => p['produkid'] == entry.key);
      final detailResponse = await supabaseService.client.from('detailpenjualan').insert({
        'PenjualanID': penjualanid,
        'ProdukID': entry.key,
        'JumblahProduk': entry.value,
        'Subtotal': produk['harga'] * entry.value,
      }).select('*').single();

      print("✅ Detail transaksi berhasil: $detailResponse");

      // Kurangi stok produk
      final stokUpdate = await supabaseService.client.from('produk').update({
        'Stok': produk['stok'] - entry.value,
      }).match({'ProdukID': entry.key});

      print("✅ Stok produk ${produk['namaproduk']} diperbarui: $stokUpdate");
    }

    generatePDF(penjualanid, totalHarga, diskon, pajak, totalBayar);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Pembayaran berhasil!'),
      backgroundColor: Colors.green,
    ));

    setState(() {
      jumlahBeli.clear();
      selectedPelanggan = null;
    });

  } catch (e) {
    print("❌ ERROR: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Terjadi kesalahan saat menyimpan pembayaran.'),
      backgroundColor: Colors.red,
    ));
  }
}



  Future<void> generatePDF(int penjualanid, int totalHarga, int diskon, int pajak, int totalBayar) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("Struk Pembayaran", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          ...jumlahBeli.entries.map((entry) {
            var produk = produkList.firstWhere((p) => p['produkid'] == entry.key);
            return pw.Text('${produk['namaproduk']} x${entry.value} - Rp ${produk['harga'] * entry.value}');
          }).toList(),
          pw.Divider(),
          pw.Text('Total: Rp $totalHarga'),
          pw.Text('Diskon: -Rp $diskon'),
          pw.Text('Pajak: +Rp $pajak'),
          pw.Text('Total Bayar: Rp $totalBayar', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ],
      );
    }));

    final Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "struk_penjualan_$penjualanid.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pembayaran')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButtonFormField(
                  value: selectedPelanggan,
                  items: pelangganList.map((pelanggan) => DropdownMenuItem(
                    value: pelanggan['pelangganid'].toString(),
                    child: Text(pelanggan['namapelanggan']),
                  )).toList(),
                  onChanged: (value) => setState(() => selectedPelanggan = value as String?),
                  decoration: InputDecoration(labelText: 'Pilih Pelanggan'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: produkList.length,
                    itemBuilder: (context, index) {
                      final produk = produkList[index];
                      int jumlah = jumlahBeli[produk['produkid']] ?? 0;
                      return ListTile(
                        title: Text(produk['namaproduk']),
                        subtitle: Text('Harga: Rp ${produk['harga']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: Icon(Icons.remove), onPressed: () => kurangiProduk(index)),
                            Text('$jumlah'),
                            IconButton(icon: Icon(Icons.add), onPressed: () => tambahProduk(index)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(onPressed: prosesPembayaran, child: Text('Bayar')),
              ],
            ),
    );
  }
}

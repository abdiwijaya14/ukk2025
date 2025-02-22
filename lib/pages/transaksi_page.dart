import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<int, List<dynamic>> detailCache = {}; // Cache untuk menyimpan detail transaksi yang sudah di-load
  Set<int> expandedItems = {}; // Set untuk menyimpan transaksi yang sedang diperluas

  Future<List<dynamic>> fetchTransaksi() async {
    final response = await supabase
        .from('penjualan')
        .select('*')
        .order('TanggalPenjualan', ascending: false);
    return response;
  }

Future<List<dynamic>> fetchDetailTransaksi(int penjualanID) async {
  try {
    final response = await supabase
        .from('detailpenjualan')
        .select('JumblahProduk, Subtotal, produk!detailpenjualan_ProdukID_fkey(NamaProduk)')
        .eq('PenjualanID', penjualanID);

    print("Detail Transaksi ($penjualanID): $response"); // Cek hasil di console
    return response;
  } catch (e) {
    print("Error fetching detail transaksi: $e");
    return [];
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Transaksi")),
      body: FutureBuilder<List<dynamic>>(
        future: fetchTransaksi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan!"));
          }
          final transaksi = snapshot.data ?? [];
          if (transaksi.isEmpty) {
            return Center(child: Text("Tidak ada transaksi"));
          }
          return ListView.builder(
            itemCount: transaksi.length,
            itemBuilder: (context, index) {
              final item = transaksi[index];
              final penjualanID = item['PenjualanID'];
              final isExpanded = expandedItems.contains(penjualanID);

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Total: Rp ${item['TotalHarga']}"),
                      subtitle: Text("Tanggal: ${item['TanggalPenjualan']}"),
                      leading: Icon(Icons.receipt),
                      trailing: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            expandedItems.remove(penjualanID);
                          } else {
                            expandedItems.add(penjualanID);
                          }
                        });
                      },
                    ),
                    if (isExpanded)
                      FutureBuilder<List<dynamic>>(
                        future: fetchDetailTransaksi(penjualanID),
                        builder: (context, detailSnapshot) {
                          if (detailSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (detailSnapshot.hasError) {
                            return Text("Gagal memuat detail transaksi");
                          }
                          final details = detailSnapshot.data ?? [];
                          if (details.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Tidak ada detail transaksi"),
                            );
                          }
                          return Column(
                            children: details.map((detail) {
                              return ListTile(
                                title: Text(detail['produk']['NamaProduk'] ?? "Produk Tidak Ditemukan"),
                                subtitle: Text("Jumlah: ${detail['JumblahProduk']}"),
                                trailing: Text("Subtotal: Rp ${detail['Subtotal']}"),
                              );
                            }).toList(),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

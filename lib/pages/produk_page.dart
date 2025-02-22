import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/supabase_service.dart';

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final SupabaseService supabaseService = SupabaseService();
  List<dynamic> produkList = [];

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  Future<void> _loadProduk() async {
    final data = await supabaseService.fetchProduk();
    setState(() {
      produkList = data;
    });
  }

  Future<void> _tambahProduk() async {
    TextEditingController namaController = TextEditingController();
    TextEditingController hargaController = TextEditingController();
    TextEditingController stokController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Produk"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: namaController, decoration: InputDecoration(labelText: "Nama Produk")),
              TextField(controller: hargaController, decoration: InputDecoration(labelText: "Harga"), keyboardType: TextInputType.number),
              TextField(controller: stokController, decoration: InputDecoration(labelText: "Stok"), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                await supabaseService.tambahProduk(
                  namaController.text,
                  double.parse(hargaController.text),
                  int.parse(stokController.text),
                );
                Navigator.pop(context);
                _loadProduk();
              },
              child: Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editProduk(int id, String nama, double harga, int stok) async {
    TextEditingController namaController = TextEditingController(text: nama);
    TextEditingController hargaController = TextEditingController(text: harga.toString());
    TextEditingController stokController = TextEditingController(text: stok.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Produk"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: namaController, decoration: InputDecoration(labelText: "Nama Produk")),
              TextField(controller: hargaController, decoration: InputDecoration(labelText: "Harga"), keyboardType: TextInputType.number),
              TextField(controller: stokController, decoration: InputDecoration(labelText: "Stok"), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                await supabaseService.editProduk(
                  id,
                  namaController.text,
                  double.parse(hargaController.text),
                  int.parse(stokController.text),
                );
                Navigator.pop(context);
                _loadProduk();
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _hapusProduk(int id) async {
    await supabaseService.hapusProduk(id);
    _loadProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Produk")),
      body: ListView.builder(
        itemCount: produkList.length,
        itemBuilder: (context, index) {
          final produk = produkList[index];
          return Card(
            child: ListTile(
              title: Text(produk['NamaProduk']),
              subtitle: Text("Harga: ${produk['Harga']} | Stok: ${produk['Stok']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _editProduk(produk['ProdukID'], produk['NamaProduk'], produk['Harga'].toDouble(), produk['Stok'].toInt())),
                  IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _hapusProduk(produk['ProdukID'])),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahProduk,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

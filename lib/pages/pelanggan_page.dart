import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/supabase_service.dart';

class PelangganPage extends StatefulWidget {
  @override
  _PelangganPageState createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  final SupabaseService supabaseService = SupabaseService();
  List<dynamic> pelangganList = [];

  @override
  void initState() {
    super.initState();
    _loadPelanggan();
  }

  Future<void> _loadPelanggan() async {
    final data = await supabaseService.fetchPelanggan();
    setState(() {
      pelangganList = data;
    });
  }

  Future<void> _tambahPelanggan() async {
    TextEditingController namaController = TextEditingController();
    TextEditingController alamatController = TextEditingController();
    TextEditingController teleponController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Pelanggan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: namaController, decoration: InputDecoration(labelText: "Nama Pelanggan")),
              TextField(controller: alamatController, decoration: InputDecoration(labelText: "Alamat")),
              TextField(controller: teleponController, decoration: InputDecoration(labelText: "Nomor Telepon"), keyboardType: TextInputType.phone),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                await supabaseService.tambahPelanggan(
                  namaController.text,
                  alamatController.text,
                  teleponController.text,
                );
                Navigator.pop(context);
                _loadPelanggan();
              },
              child: Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editPelanggan(int id, String nama, String alamat, String telepon) async {
    TextEditingController namaController = TextEditingController(text: nama);
    TextEditingController alamatController = TextEditingController(text: alamat);
    TextEditingController teleponController = TextEditingController(text: telepon);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Pelanggan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: namaController, decoration: InputDecoration(labelText: "Nama Pelanggan")),
              TextField(controller: alamatController, decoration: InputDecoration(labelText: "Alamat")),
              TextField(controller: teleponController, decoration: InputDecoration(labelText: "Nomor Telepon"), keyboardType: TextInputType.phone),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                await supabaseService.editPelanggan(
                  id,
                  namaController.text,
                  alamatController.text,
                  teleponController.text,
                );
                Navigator.pop(context);
                _loadPelanggan();
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _hapusPelanggan(int id) async {
    await supabaseService.hapusPelanggan(id);
    _loadPelanggan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pelanggan")),
      body: ListView.builder(
        itemCount: pelangganList.length,
        itemBuilder: (context, index) {
          final pelanggan = pelangganList[index];
          return Card(
            child: ListTile(
              title: Text(pelanggan['namapelanggan']),
              subtitle: Text("Alamat: ${pelanggan['alamat']} | Telepon: ${pelanggan['nomortelepon']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _editPelanggan(pelanggan['pelangganID'], pelanggan['namapelanggan'], pelanggan['alamat'], pelanggan['nomortelepon'])),
                  IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _hapusPelanggan(pelanggan['pelangganID'])),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahPelanggan,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

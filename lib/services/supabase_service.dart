import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // Fungsi Logout
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Fetch produk dari Supabase
  Future<List<Map<String, dynamic>>> fetchProduk() async {
    final response = await client.from('produk').select();
    return response;
  }

  // Tambah produk
  Future<void> tambahProduk(String nama, double harga, int stok) async {
    await client.from('produk').insert({
      'NamaProduk': nama,
      'Harga': harga,
      'Stok': stok,
    });
  }

  // Edit produk
  Future<void> editProduk(int id, String nama, double harga, int stok) async {
    await client.from('produk').update({
      'NamaProduk': nama,
      'Harga': harga,
      'Stok': stok,
    }).eq('ProdukID', id);
  }

  // Hapus produk
  Future<void> hapusProduk(int id) async {
    await client.from('produk').delete().eq('ProdukID', id);
  }

  // Fetch pelanggan dari Supabase
  Future<List<Map<String, dynamic>>> fetchPelanggan() async {
    final response = await client.from('pelanggan').select();
    return response;
  }

  // Tambah pelanggan
  Future<void> tambahPelanggan(String nama, String alamat, String telepon) async {
    await client.from('pelanggan').insert({
      'namapelanggan': nama,
      'alamat': alamat,
      'nomortelepon': telepon,
    });
  }

  // Edit pelanggan
  Future<void> editPelanggan(int id, String nama, String alamat, String telepon) async {
    await client.from('pelanggan').update({
      'namapelanggan': nama,
      'alamat': alamat,
      'nomortelepon': telepon,
    }).eq('pelangganID', id);
  }

  // Hapus pelanggan
  Future<void> hapusPelanggan(int id) async {
    await client.from('pelanggan').delete().eq('pelangganID', id);
  }

  // Fetch data user dari Supabase
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await client.from('user').select();
    return response;
  }

  // Tambah user
  Future<void> tambahUser(String username, String password, String role) async {
    await client.from('user').insert({
      'username': username,
      'password': password, // Harus di-hash jika digunakan untuk login!
      'role': role,
    });
  }

  // Edit user
  Future<void> editUser(int id, String username, String password, String role) async {
    await client.from('user').update({
      'username': username,
      'password': password, // Harus di-hash jika digunakan untuk login!
      'role': role,
    }).eq('id', id);
  }

  // Hapus user
  Future<void> hapusUser(int id) async {
    await client.from('user').delete().eq('id', id);
  }
}

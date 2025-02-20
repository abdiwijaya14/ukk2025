import 'package:flutter/material.dart';

class Tambahproduk extends StatefulWidget {
  const Tambahproduk({super.key});

  @override
  State<Tambahproduk> createState() => _TambahprodukState();
}

class _TambahprodukState extends State<Tambahproduk> {
  // final formProduk
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tambah Produk", style: TextStyle(fontSize: 30),),
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            
          ],
        ),
      ),
    );
  }
}
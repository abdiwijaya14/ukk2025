import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Produkindex extends StatefulWidget {
  const Produkindex({super.key});

  @override
  State<Produkindex> createState() => _ProdukindexState();
}

class _ProdukindexState extends State<Produkindex> {
  List produk = [];
  login() async {
    var result = await Supabase.instance.client.from("produk").select();
    setState(() {
      produk = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: Text("Produk"),

        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 2.5,
          children: [
            ...List.generate(produk.length, (index) {
              return Card(
                  child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${produk[index]["NamaProduk"]}"),
                        Text("Rp.${produk[index]["Harga"]}"),
                        Text("Stok: ${produk[index]["Stok"]}")
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    )
                  ],
                ),
              ));
            })
          ],
        ),
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(
        Icons.add
      ),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

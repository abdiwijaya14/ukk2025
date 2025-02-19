import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login toko member JMT",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BerandaPage()),
                  );
                },
                child: Text("Login"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text("Buat Akun"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Pendaftaran (RegisterPage)
class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Akun")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Daftar Akun Baru",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Daftar"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Beranda (Setelah Login)
class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beranda")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListPage()),
                );
              },
              child: Text("pembelian produk"),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Daftar Produk
class ProductListPage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {'name': 'Master Rim RCB', 'description': 'Bergaransi', 'price': 'Rp. 500.000'},
    {'name': 'VND Racing', 'description': 'Belilah di toko kami', 'price': 'Rp. 100.000'},
    {'name': 'Tokico', 'description': 'Belilah produk kami', 'price': 'Rp. 300.000'},
    {'name': 'VND Racing', 'description': 'Kualitas no.1', 'price': 'Rp. 300.000'},
    {'name': 'Aiteck', 'description': 'Memiliki kualitas yang sangat kuat', 'price': 'Rp. 900.000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Produk")),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(products[index]['name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deskripsi: ${products[index]['description']}'),
                  Text('Harga: ${products[index]['price']}'),
                ],
              ),
              trailing: Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: products[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Halaman Detail Produk
class ProductDetailPage extends StatefulWidget {
  final Map<String, String> product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    int price = int.tryParse(widget.product['price']?.replaceAll(RegExp(r'\D'), '') ?? '0') ?? 0;
    int totalPrice = price * quantity;

    return Scaffold(
      appBar: AppBar(title: Text("Detail Produk")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product['name'] ?? '', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Harga: ${widget.product['price']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Row(
              children: [
                IconButton(icon: Icon(Icons.remove), onPressed: () { if (quantity > 1) setState(() => quantity--); }),
                Text('Quantity: $quantity', style: TextStyle(fontSize: 18)),
                IconButton(icon: Icon(Icons.add), onPressed: () { setState(() => quantity++); }),
              ],
            ),
            SizedBox(height: 20),
            Text('Total Harga: Rp. ${totalPrice.toString()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PurchaseReceiptPage(product: widget.product, quantity: quantity, totalPrice: totalPrice),
                  ),
                );
              },
              child: Text("Proses Pemesanan"),
            ),
          ],
        ),
      ),
    );
  }
}

class PurchaseReceiptPage extends StatelessWidget {
  final Map<String, String> product;
  final int quantity;
  final int totalPrice;

  PurchaseReceiptPage({required this.product, required this.quantity, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Struk Pembelian")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Struk Pembelian", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Produk: ${product['name']}", style: TextStyle(fontSize: 18)),
            Text("Jumlah: $quantity", style: TextStyle(fontSize: 18)),
            Text("Total Harga: Rp. $totalPrice", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text("Kembali ke Beranda"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/pages/homepage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usernameCtrl = TextEditingController();
    final pwCtrl = TextEditingController();
    final formLogin = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formLogin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login toko member JMT",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: pwCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final supabase = Supabase.instance.client;

                    // Ambil user dari database
                    final user = await supabase
                        .from("user")
                        .select("id, username, role") // Ambil data yg diperlukan aja
                        .eq("username", usernameCtrl.text)
                        .eq("password", pwCtrl.text)
                        .maybeSingle(); // Cek kalau hanya ada 1 user

                    if (user != null) {
                      // Login berhasil, arahkan ke HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      // Jika user tidak ditemukan
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Username atau password salah",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                      ));
                    }
                  },
                  child: Text("Login"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

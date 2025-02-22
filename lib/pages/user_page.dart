import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/supabase_service.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final SupabaseService supabaseService = SupabaseService();
  List<dynamic> userList = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final data = await supabaseService.fetchUsers();
    setState(() {
      userList = data;
    });
  }

  Future<void> _tambahUser() async {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController roleController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
              TextField(controller: roleController, decoration: InputDecoration(labelText: "Role")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                await supabaseService.tambahUser(
                  usernameController.text,
                  passwordController.text,
                  roleController.text,
                );
                Navigator.pop(context);
                _loadUsers();
              },
              child: Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editUser(int id, String username, String password, String role) async {
    TextEditingController usernameController = TextEditingController(text: username);
    TextEditingController passwordController = TextEditingController(text: password);
    TextEditingController roleController = TextEditingController(text: role);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
              TextField(controller: roleController, decoration: InputDecoration(labelText: "Role")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                await supabaseService.editUser(
                  id,
                  usernameController.text,
                  passwordController.text,
                  roleController.text,
                );
                Navigator.pop(context);
                _loadUsers();
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _hapusUser(int id) async {
    await supabaseService.hapusUser(id);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Management")),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return Card(
            child: ListTile(
              title: Text(user['username']),
              subtitle: Text("Role: ${user['role']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _editUser(user['id'], user['username'], user['password'], user['role'])),
                  IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _hapusUser(user['id'])),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahUser,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

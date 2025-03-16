import 'package:flutter/material.dart';
import 'package:form_login/helpers/database_helper.dart';
import 'package:form_login/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Password tidak cocok"),
              backgroundColor: Colors.red),
        );
        return;
      }

      var user = await _dbHelper.getUser(username);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Username sudah digunakan"),
              backgroundColor: Colors.orange),
        );
        return;
      }

      await _dbHelper.registerUser(name, username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Registrasi Berhasil! Silakan Login"),
            backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Masukkan nama lengkap"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Masukkan username"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) => (value == null || value.isEmpty)
                    ? "Masukkan password"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: "Konfirmasi Password"),
                obscureText: true,
                validator: (value) => (value == null || value.isEmpty)
                    ? "Masukkan konfirmasi password"
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage())),
                child: const Text("Sudah punya akun? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

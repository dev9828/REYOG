import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signup() {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Account created successfully!'),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Create an Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                ),
                child: const Text("Sign Up",
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: _goToLogin,
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

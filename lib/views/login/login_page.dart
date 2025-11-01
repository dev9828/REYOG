import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Validate form before proceeding
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/splash');
    }
  }

  void _goToSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Reyogo",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // 📨 EMAIL FIELD
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    // ✅ Email regex validation
                    const pattern =
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                    final regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // 🔒 PASSWORD FIELD
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // 🔘 LOGIN BUTTON
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 14),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 18),

                // 🔗 SIGNUP NAVIGATION
                TextButton(
                  onPressed: _goToSignup,
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

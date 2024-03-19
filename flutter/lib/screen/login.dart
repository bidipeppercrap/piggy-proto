import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:piggy_android/screen/account_detail.dart';
import 'package:piggy_android/screen/account_list.dart';
import 'package:piggy_android/services/auth.dart';
import 'package:piggy_android/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../types/account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      final token = await submitCredential(usernameController.text, passwordController.text);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', token.token);
      AccountSession.token = token.token;

      Map<String, dynamic> decoded = JwtDecoder.decode(AccountSession.token);

      if (decoded['role'] == 'accountant') {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountListScreen()),
        );
      }

      if (decoded['role'] == 'user') {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountDetailScreen(currentAccount: Account.fromJwt(decoded))),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'username'
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'password'
              ),
            ),
            ElevatedButton(onPressed: () => login(), child: const Text('Submit'))
          ],
        ),
      ),
    );
  }
}
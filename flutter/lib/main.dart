import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:piggy_android/screen/account_detail.dart';
import 'package:piggy_android/screen/account_list.dart';
import 'package:piggy_android/screen/login.dart';
import 'package:piggy_android/store.dart';
import 'package:piggy_android/types/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

String token = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  token = await readToken();

  runApp(const MyApp());
}

Widget firstScreen(BuildContext context) {
  Map<String, dynamic> decoded = JwtDecoder.decode(AccountSession.token);

  if (decoded['role'] == 'accountant') {
    return const AccountListScreen();
  }

  if (decoded['role'] == 'user') {
    return AccountDetailScreen(currentAccount: Account.fromJwt(decoded));
  }

  return const MyHomePage(title: 'title');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piggy Proto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: token.isNotEmpty ? firstScreen(context) : const LoginScreen(),
    );
  }
}

Future<String> readToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String token = prefs.getString('token') ?? '';
  AccountSession.token = token;

  return token;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<String> token;

  @override
  void initState() {
    super.initState();
    token = readToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('wtf'),
      )
    );
  }
}

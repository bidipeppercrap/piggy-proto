import 'package:flutter/material.dart';
import 'package:piggy_android/services/account.dart';
import 'package:piggy_android/types/response.dart';
import 'package:piggy_android/widgets/account_list.dart';

import '../types/account.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  late Future<PaginatedResponse<Account>> futurePaginated;

  Future<void> refreshAccounts() async {
    setState(() {
      futurePaginated = AccountService.find();
    });
  }

  @override
  void initState() {
    super.initState();
    futurePaginated = AccountService.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: FutureBuilder<PaginatedResponse<Account>>(
        future: futurePaginated,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: refreshAccounts,
              child: AccountList(accounts: snapshot.data!.data,),
            );
          } else if (snapshot.hasError) {
            return Text('Future snapshot error: ${snapshot.error}');
          }

          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}
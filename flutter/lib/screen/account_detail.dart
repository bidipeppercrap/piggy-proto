import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piggy_android/widgets/account_detail_entries.dart';
import 'package:piggy_android/widgets/account_detail_header.dart';

import '../services/account.dart';
import '../types/account.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({super.key, required this.currentAccount, this.isAccountant = false});

  final Account currentAccount;
  final bool isAccountant;

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  late Future<Account> accountDetail;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  Future<void> refreshAccount() async {
    setState(() {
      accountDetail = widget.isAccountant
          ? AccountService.findById(widget.currentAccount.id!, startDateController.text, endDateController.text)
          : AccountService.findSelf(startDateController.text, endDateController.text);
    });
  }

  @override
  void initState() {
    super.initState();

    startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    endDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))).toString();
    accountDetail = widget.isAccountant
        ? AccountService.findById(widget.currentAccount.id!, startDateController.text, endDateController.text)
        : AccountService.findSelf(startDateController.text, endDateController.text);
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account: ${widget.currentAccount.name}'),
        ),
        body: FutureBuilder<Account>(
          future: accountDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: refreshAccount,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView(
                    children: <Widget>[
                      AccountDetailHeader(
                          totalBalance: snapshot.data!.totalDebit! - snapshot.data!.totalCredit!,
                          totalQueryDebit: snapshot.data!.totalQueryDebit!,
                          totalQueryCredit: snapshot.data!.totalQueryCredit!,
                          startDate: startDateController.text, endDate: endDateController.text
                      ),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: TextField(
                                  controller: startDateController,
                                  decoration: const InputDecoration(
                                      hintText: 'Start Date'
                                  ),
                                ),),
                                const SizedBox(width: 15),
                                const Text('-'),
                                const SizedBox(width: 15),
                                Expanded(child: TextField(
                                  controller: endDateController,
                                  decoration: const InputDecoration(
                                      hintText: 'End Date'
                                  ),
                                ))
                              ],
                            ),
                          )
                      ),
                      const ListDistinct(text: 'Start of Entry',),
                      AccountDetailEntries(
                          accountId: snapshot.data!.id!,
                          isAccountant: widget.isAccountant,
                          entries: snapshot.data!.entries!,
                          onRefresh: refreshAccount,
                      ),
                      const ListDistinct(text: 'End of Entry',),
                    ],
                  )
                )
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

class ListDistinct extends StatelessWidget {
  const ListDistinct({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
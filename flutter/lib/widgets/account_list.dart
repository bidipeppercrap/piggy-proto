import 'package:flutter/material.dart';
import 'package:piggy_android/screen/account_detail.dart';
import 'package:piggy_android/widgets/quick_transfer_dialog.dart';

import '../types/account.dart';

class AccountList extends StatelessWidget {
  const AccountList({
    super.key,
    required this.accounts
  });

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: accounts.length,
      itemBuilder: (_, int index) {
        final double balance = accounts[index].totalDebit! - accounts[index].totalCredit!;

        return ListTile(
          title: Text(accounts[index].name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Balance: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    TextSpan(
                      text: balance.toString(),
                      style: TextStyle(
                        color: balance < 0 ? Colors.red : Colors.green
                      )
                    )
                  ]
                )
              ),
              Row(
                children: <Widget>[
                  TextButton(onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountDetailScreen(currentAccount: accounts[index], isAccountant: true,)),
                  ), child: const Text('Detail')),
                  TextButton(onPressed: () => _dialogBuilder(context, accounts[index]), child: const Text('Transfer')),
                ],
              )
            ],
          )
        );
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Account transferTo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return QuickTransferDialog(transferTo: transferTo,);
        }
    );
  }
}
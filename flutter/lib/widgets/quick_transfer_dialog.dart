import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:piggy_android/services/entry.dart';
import 'package:piggy_android/store.dart';

import '../types/account.dart';

class QuickTransferDialog extends StatefulWidget {
  const QuickTransferDialog({
    super.key,
    required this.transferTo
  });

  final Account transferTo;

  @override
  State<QuickTransferDialog> createState() => _QuickTransferDialogState();
}

class _QuickTransferDialogState extends State<QuickTransferDialog> {

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  Account selectedAccount = Account(name: '', username: '', role: '');

  Future<void> beginTransfer() async {
    await EntryService.transfer(selectedAccount.id!, widget.transferTo.id!, double.parse(amountController.text), descriptionController.text);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    final decoded = JwtDecoder.decode(AccountSession.token);

    selectedAccount = Account.fromJwt(decoded);
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Transfer: ${widget.transferTo.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
              onPressed: () { },
              child: Text(selectedAccount!.name)
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: 'Amount'
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description'
            ),
          )
        ],
      ),
      actions: <TextButton>[
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: const Text('Cancel')),
        TextButton(onPressed: beginTransfer , child: const Text('Transfer'))
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:piggy_android/services/entry.dart';

import '../types/entry.dart';

typedef OnRefreshCallback = Future<void> Function();

class AccountDetailEntries extends StatelessWidget {
  const AccountDetailEntries({
    super.key,
    required this.accountId,
    this.isAccountant = false,
    required this.entries,
    required this.onRefresh
  });

  final int accountId;
  final bool isAccountant;
  final List<Entry> entries;
  final OnRefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    Future<void> deleteEntry(int id) async {
      await EntryService.deleteEntry(id);
      await onRefresh();
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (_, int index) {
        initializeDateFormatting('id');
        final createdAt = DateFormat('yyyy-MM-dd HH:mm:ssZ').parseUTC(entries[index].createdAt.toString()).toLocal();
        String createdAtDate = DateFormat('yyyy MMM dd').format(createdAt);
        String createdAtTime = DateFormat('Hm').format(createdAt);

        return Card(
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                Text(createdAtDate),
                Text(
                  createdAtTime,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
            title: Text(
              entries[index].amount.toString(),
              style: TextStyle(
                  color: entries[index].debtorId == accountId ? Colors.green : Colors.red
              ),
            ),
            subtitle: Text(entries[index].description ?? ''),
            trailing: isAccountant ? TextButton(onPressed: () => deleteEntry(entries[index].id!), child: const Icon(Icons.delete)) : null,
          )
        );
      },
    );
  }
}
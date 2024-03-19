import 'package:flutter/material.dart';

class AccountDetailHeader extends StatelessWidget {
  const AccountDetailHeader({
    super.key,
    required this.totalBalance,
    required this.totalQueryDebit,
    required this.totalQueryCredit,
    required this.startDate,
    required this.endDate
  });

  final double totalBalance;
  final double totalQueryDebit;
  final double totalQueryCredit;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Total Balance: $totalBalance',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                )
            ),
            const SizedBox(
              height: 9,
            ),
            RichText(text: TextSpan(
              children: <TextSpan>[
                const TextSpan(text: 'Total Balance as of: ', style: TextStyle(color: Colors.black)),
                TextSpan(
                  text: '$startDate - $endDate',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  )
                )
              ]
            )),
            RichText(text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: totalQueryDebit.toString(),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                  )
                ),
                const TextSpan(
                    text: ' - ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    )
                ),
                TextSpan(
                    text: totalQueryCredit.toString(),
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                    )
                )
              ]
            )),
            Text(
                (totalQueryDebit - totalQueryCredit).toString(),
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: (totalQueryDebit - totalQueryCredit) < 0 ? Colors.red : Colors.green
                )
            )
          ],
        ),
      )
    );
  }
}
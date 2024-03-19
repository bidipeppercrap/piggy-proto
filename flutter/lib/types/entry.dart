class Entry {
  Entry({
    this.id,
    this.description,
    required this.amount,
    required this.debtorId,
    required this.creditorId,
    required this.createdAt
  });

  int? id;
  String? description;
  final double amount;
  final int debtorId;
  final int creditorId;
  final DateTime createdAt;

  factory Entry.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'description': String? description,
        'amount': String amount,
        'debtor_id': int debtorId,
        'creditor_id': int creditorId,
        'created_at': String createdAt
      } => Entry(
        id: id,
        description: description,
        amount: double.parse(amount),
        debtorId: debtorId,
        creditorId: creditorId,
        createdAt: DateTime.parse(createdAt)
      ),
      _ => throw const FormatException('failed to load entry')
    };
  }
}
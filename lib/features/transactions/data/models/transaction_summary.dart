class TransactionSummary {
  final double income;
  final double expense;
  final double balance;

  TransactionSummary({
    required this.income,
    required this.expense,
    required this.balance,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      income: json['income']?.toDouble() ?? 0.0,
      expense: json['expense']?.toDouble() ?? 0.0,
      balance: json['balance']?.toDouble() ?? 0.0,
    );
  }
}

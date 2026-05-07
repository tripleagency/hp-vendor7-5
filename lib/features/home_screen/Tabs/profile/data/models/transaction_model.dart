class TransactionModel {
  final String title;
  final String id;
  final String amount;
  final String date;
  final bool isWithdrawal;

  const TransactionModel({
    required this.title,
    required this.id,
    required this.amount,
    required this.date,
    required this.isWithdrawal,
  });
}

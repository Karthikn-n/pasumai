class InvoiceModel {
  final int id;
  final String orderId;
  final int customerId;
  final String invoiceNo;
  final String invoiceFile;
  final String invoiceDate;
  final String amount;
  final String status;
  final String createdAt;
  final String updatedAt;

  InvoiceModel({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.invoiceNo,
    required this.invoiceFile,
    required this.invoiceDate,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      invoiceNo: json['invoice_no'] ?? '',
      invoiceFile: json['invoice_file'] ?? '',
      invoiceDate: json['invoice_date'] ?? '',
      amount: json['amount'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

/// A host-supplied loyalty account at a car rental supplier.
class SupplierLoyaltyAccount {
  const SupplierLoyaltyAccount({
    required this.customerAccount,
    this.supplierName,
  });

  /// The customer's loyalty number at the supplier.
  final String customerAccount;

  /// The supplier the account belongs to, such as `Hertz`.
  final String? supplierName;

  /// The channel map: `supplierName` is left out when null.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerAccount': customerAccount,
      'supplierName': supplierName,
    }..removeWhere((_, value) => value == null);
  }
}

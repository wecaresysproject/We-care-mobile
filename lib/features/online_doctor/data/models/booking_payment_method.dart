/// طرق الدفع المتاحة فى شاشة "حجز موعد".
enum BookingPaymentMethod {
  bankCard,
  eWallet;

  String get label => switch (this) {
        BookingPaymentMethod.bankCard => "بطاقة بنكية",
        BookingPaymentMethod.eWallet => "محفظة الكترونية",
      };

  /// أيقونة الطريقة داخل `assets/svgs`.
  String get iconAsset => switch (this) {
        BookingPaymentMethod.bankCard => "assets/svgs/visa_card_icon.svg",
        BookingPaymentMethod.eWallet => "assets/svgs/e_wallet_icon.svg",
      };

  /// مقاس الأيقونة زى ما هى فى التصميم.
  double get iconSize => switch (this) {
        BookingPaymentMethod.bankCard => 38,
        BookingPaymentMethod.eWallet => 34,
      };
}

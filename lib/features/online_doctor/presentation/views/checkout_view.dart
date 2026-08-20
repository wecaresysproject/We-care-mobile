import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/checkout_card_data_fields.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/checkout_payment_dialogs.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/checkout_summary_card.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';

/// شاشة "الدفع" — بتظهر بعد اختيار "بطاقة بنكية" فى شاشة "حجز موعد".
class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();

  final _expiryYearFocus = FocusNode();
  final _cvvFocus = FocusNode();

  /// دايالوج التحميل اتقفل قبل ما الدفع يخلص — عشان النتيجة متتكملش بعد الإلغاء.
  bool _paymentCancelled = false;

  //! رسوم البرنامج لسه ثابتة زى التصميم — هتيجى من الـ API مع endpoint الدفع.
  static const int _programFee = 50;

  List<TextEditingController> get _controllers => [
        _cardNumberController,
        _cardHolderController,
        _expiryMonthController,
        _expiryYearController,
        _cvvController,
      ];

  @override
  void initState() {
    super.initState();
    // زرار "إتمام الدفع" بيتفعّل أول ما كل الحقول تكتمل.
    for (final controller in _controllers) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _expiryYearFocus.dispose();
    _cvvFocus.dispose();
    super.dispose();
  }

  bool get _isFormComplete {
    final month = int.tryParse(_expiryMonthController.text);
    return _cardNumberController.text.replaceAll(' ', '').length == 16 &&
        _cardHolderController.text.trim().isNotEmpty &&
        month != null &&
        month >= 1 &&
        month <= 12 &&
        _expiryYearController.text.length == 2 &&
        _cvvController.text.length == 3;
  }

  //! لسه بيحاكى انتظار الدفع بمهلة ثانيتين — هيتربط بـ endpoint الدفع لما يجهز.
  Future<void> _onCompletePayment() async {
    _paymentCancelled = false;
    // قفل الدايالوج بأى طريقة — حتى زرار الرجوع فى أندرويد — بيعتبر إلغاء.
    showCheckoutLoadingDialog(
      context,
      onCancel: () => context.pop(),
    ).then((_) => _paymentCancelled = true);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted || _paymentCancelled) return;

    context.pop(); // قفل دايالوج التحميل قبل عرض النجاح.
    showCheckoutSuccessDialog(context, onGoToBookings: _goToMyBookings);
  }

  /// بيرجع لشاشة "طبيبك أون لاين" وبيفتح "حجوزاتى" — شاشات الحجز خلص دورها.
  void _goToMyBookings() {
    context.pushNamedAndRemoveUntil(
      Routes.myBookingsView,
      predicate: (route) =>
          route.settings.name == Routes.onlineDoctorView || route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: const DoctorSpecializationsAppBar(title: "الدفع"),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // الكارت أضيق من الحقول بمقدار 8 من كل ناحية — زى التصميم.
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: CheckoutSummaryCard(
                        bookingPrice: widget.doctor.consultationFee,
                        programFee: _programFee,
                      ),
                    ),
                    verticalSpacing(24),
                    const CheckoutFieldLabel(
                      title: "رقم البطاقة",
                      iconAsset: "assets/svgs/checkout_card_icon.svg",
                    ),
                    verticalSpacing(12),
                    CheckoutGradientTextField(
                      controller: _cardNumberController,
                      hintText: "اكتب رقم البطاقة",
                      keyboardType: TextInputType.number,
                      inputFormatters: [CardNumberInputFormatter()],
                    ),
                    verticalSpacing(22),
                    const CheckoutFieldLabel(
                      title: "الاسم على البطاقة",
                      iconAsset: "assets/svgs/checkout_card_holder_icon.svg",
                    ),
                    verticalSpacing(12),
                    CheckoutGradientTextField(
                      controller: _cardHolderController,
                      hintText: "اكتب الاسم المدون على البطاقة",
                      keyboardType: TextInputType.name,
                    ),
                    verticalSpacing(22),
                    const CheckoutFieldLabel(
                      title: "تاريخ الانتهاء",
                      iconAsset:
                          "assets/svgs/checkout_expiry_calendar_icon.svg",
                      iconSize: 18,
                    ),
                    verticalSpacing(12),
                    Row(
                      children: [
                        CheckoutPinBoxField(
                          controller: _expiryMonthController,
                          width: 84,
                          maxLength: 2,
                          onChanged: (value) {
                            if (value.length == 2)
                              _expiryYearFocus.requestFocus();
                          },
                        ),
                        horizontalSpacing(20),
                        CheckoutPinBoxField(
                          controller: _expiryYearController,
                          focusNode: _expiryYearFocus,
                          width: 84,
                          maxLength: 2,
                          onChanged: (value) {
                            if (value.length == 2) _cvvFocus.requestFocus();
                          },
                        ),
                      ],
                    ),
                    verticalSpacing(22),
                    const CheckoutFieldLabel(
                      title: "رمز الأمان",
                      iconAsset: "assets/svgs/checkout_cvv_lock_icon.svg",
                    ),
                    verticalSpacing(12),
                    Row(
                      children: [
                        CheckoutPinBoxField(
                          controller: _cvvController,
                          focusNode: _cvvFocus,
                          width: 100,
                          maxLength: 3,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              child: AppCustomButton(
                title: "إتمام الدفع",
                isEnabled: _isFormComplete,
                onPressed: _onCompletePayment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

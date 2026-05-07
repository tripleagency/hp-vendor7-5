import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';

enum _PayoutMethod { wallet, vodafoneCash, instapay }

/// Withdrawal request bottom sheet.
///
/// Lets the vendor enter:
///  • the amount they want to withdraw (validated against [availableBalance])
///  • their payout destination — either a mobile wallet number or Instapay
///    handle/account
///
/// Returns a `Map<String, dynamic>` via `Navigator.pop` on success:
/// `{ amount, method, destination }`.
class WithdrawalBottomSheet extends StatefulWidget {
  /// Available wallet balance in EGP. Used to enforce the upper bound on
  /// the withdrawal amount.
  final double availableBalance;

  const WithdrawalBottomSheet({
    super.key,
    required this.availableBalance,
  });

  @override
  State<WithdrawalBottomSheet> createState() => _WithdrawalBottomSheetState();
}

class _WithdrawalBottomSheetState extends State<WithdrawalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _destinationController = TextEditingController();

  _PayoutMethod _method = _PayoutMethod.wallet;
  bool _isAgreed = false;

  @override
  void initState() {
    super.initState();
    // Re-validate / refresh the submit button as the user types.
    _amountController.addListener(() => setState(() {}));
    _destinationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  // ── Validation helpers ─────────────────────────────────────────────────────

  String? _validateAmount(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'amount_required'.tr();
    final amount = double.tryParse(raw);
    if (amount == null || amount <= 0) {
      return 'amount_invalid'.tr();
    }
    if (amount > widget.availableBalance) {
      return 'amount_exceeds_balance'.tr();
    }
    return null;
  }

  String? _validateDestination(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'destination_required'.tr();
    if (_method == _PayoutMethod.wallet ||
        _method == _PayoutMethod.vodafoneCash) {
      // Mobile wallet number — allow Egyptian formats: 10-15 digits.
      if (!RegExp(r'^\d{10,15}$').hasMatch(raw)) {
        return 'wallet_number_invalid'.tr();
      }
    }
    // Instapay can be either a numeric account number OR a handle (user@instapay).
    if (_method == _PayoutMethod.instapay) {
      // Pure-numeric account: 6+ digits
      final isPureNumber = RegExp(r'^\d{6,}$').hasMatch(raw);
      // Handle: any combination of letters/numbers/@/./_/-, min 4 chars
      final isHandle =
          RegExp(r'^[A-Za-z0-9@._\-]{4,}$').hasMatch(raw);
      if (!isPureNumber && !isHandle) {
        return 'instapay_invalid'.tr();
      }
    }
    return null;
  }

  bool get _canSubmit {
    final amountValid = _validateAmount(_amountController.text) == null;
    final destValid = _validateDestination(_destinationController.text) == null;
    return _isAgreed && amountValid && destValid;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.trim());
    String methodValue;
    switch (_method) {
      case _PayoutMethod.wallet:
        methodValue = 'wallet';
        break;
      case _PayoutMethod.vodafoneCash:
        methodValue = 'vodafone_cash';
        break;
      case _PayoutMethod.instapay:
        methodValue = 'instapay';
        break;
    }
    Navigator.pop(context, {
      'amount': amount,
      'method': methodValue,
      'destination': _destinationController.text.trim(),
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(),
                SizedBox(height: 8.h),
                _buildHeader(),
                SizedBox(height: 18.h),
                _buildBalanceCard(),
                SizedBox(height: 18.h),
                _label('amount_label'.tr()),
                SizedBox(height: 6.h),
                _buildAmountField(),
                SizedBox(height: 16.h),
                _label('payout_method_label'.tr()),
                SizedBox(height: 8.h),
                _buildMethodSelector(),
                SizedBox(height: 14.h),
                _label(_method == _PayoutMethod.instapay
                    ? 'instapay_handle_label'.tr()
                    : 'wallet_number_label'.tr()),
                SizedBox(height: 6.h),
                _buildDestinationField(),
                SizedBox(height: 18.h),
                _buildAgreementCheckbox(),
                SizedBox(height: 20.h),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Sub-widgets ────────────────────────────────────────────────────────────

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 44.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          'request_withdrawal_title'.tr(),
          style: AppStyles.inter18MediumBlack.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.savings_outlined,
              color: AppColors.primary, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            'available_balance'.tr(),
            style: AppStyles.inter12Regular.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            '${widget.availableBalance.toStringAsFixed(2)} ${'currency_egp'.tr()}',
            style: AppStyles.inter14Regular.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppStyles.inter12Regular.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildAmountField() {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          validator: _validateAmount,
          decoration: _fieldDecoration('amount_hint'.tr()),
          style: AppStyles.inter14Regular,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: TextButton(
            onPressed: () {
              _amountController.text =
                  widget.availableBalance.toStringAsFixed(2);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'max'.tr(),
              style: AppStyles.inter12Regular.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodSelector() {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(child: _methodChip(_PayoutMethod.wallet)),
          Expanded(child: _methodChip(_PayoutMethod.vodafoneCash)),
          Expanded(child: _methodChip(_PayoutMethod.instapay)),
        ],
      ),
    );
  }

  Widget _methodChip(_PayoutMethod m) {
    final isSelected = _method == m;
    final String label;
    final IconData icon;
    switch (m) {
      case _PayoutMethod.wallet:
        label = 'method_wallet'.tr();
        icon = Icons.phone_android;
        break;
      case _PayoutMethod.vodafoneCash:
        label = 'method_vodafone_cash'.tr();
        icon = Icons.smartphone_outlined;
        break;
      case _PayoutMethod.instapay:
        label = 'method_instapay'.tr();
        icon = Icons.flash_on;
        break;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _method = m;
          _destinationController.clear();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? AppColors.primary : Colors.grey.shade600,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppStyles.inter12Regular.copyWith(
                color: isSelected ? AppColors.primary : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationField() {
    final isPhoneBased = _method == _PayoutMethod.wallet ||
        _method == _PayoutMethod.vodafoneCash;
    return TextFormField(
      controller: _destinationController,
      keyboardType: isPhoneBased ? TextInputType.phone : TextInputType.text,
      inputFormatters: isPhoneBased
          ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))]
          : null,
      validator: _validateDestination,
      decoration: _fieldDecoration(
        isPhoneBased ? 'wallet_number_hint'.tr() : 'instapay_handle_hint'.tr(),
        prefixIcon: Icon(
          isPhoneBased
              ? Icons.phone_iphone_rounded
              : Icons.alternate_email_rounded,
          color: Colors.grey.shade500,
          size: 18.sp,
        ),
      ),
      style: AppStyles.inter14Regular,
    );
  }

  InputDecoration _fieldDecoration(String hint, {Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
      filled: true,
      fillColor: const Color(0xFFF7F8F9),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.primary, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.error, width: 1.2),
      ),
    );
  }

  Widget _buildAgreementCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22.w,
          height: 22.h,
          child: Checkbox(
            value: _isAgreed,
            onChanged: (value) =>
                setState(() => _isAgreed = value ?? false),
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            side: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'withdrawal_terms_prefix'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
              ),
              children: [
                TextSpan(
                  text: 'withdrawal_terms_link'.tr(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: CustomElevatedButton(
        text: 'send_request_button'.tr(),
        onButtonClicked: _canSubmit ? _submit : null,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        backGroundColor: _canSubmit ? AppColors.primary : Colors.grey,
      ),
    );
  }
}

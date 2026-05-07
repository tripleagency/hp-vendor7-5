import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/withdrawal_bottom_sheet.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/data/models/transaction_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/widgets/withdrawal_success_dialog.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // Toggle this to see different states
  bool _hasTransactions = false;

  final List<TransactionModel> _transactions = const [
    TransactionModel(
      title: 'transaction_type_food_order',
      id: '#45544',
      amount: '900',
      date: '26/10/2023 - 09:47',
      isWithdrawal: false,
    ),
    TransactionModel(
      title: 'transaction_type_withdrawn',
      id: '#45544',
      amount: '25.000',
      date: '26/10/2023 - 09:47',
      isWithdrawal: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _WalletHeader(
            balance: _hasTransactions ? '45.500' : '0.00',
          ), // Example balance
          Expanded(
            child: _hasTransactions
                ? _TransactionsList(transactions: _transactions)
                : const _EmptyWalletState(),
          ),
          if (_hasTransactions) _buildBottomButton(),
        ],
      ),
      floatingActionButton: kDebugMode
          ? Padding(
              padding: EdgeInsets.only(bottom: 90.h),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _hasTransactions = !_hasTransactions;
                  });
                },
                child: const Icon(Icons.swap_horiz),
              ),
            )
          : null,
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.w,
        bottom: 60.h,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: CustomElevatedButton(
          text: 'request_withdrawal_button'.tr(),
          onButtonClicked: () async {
            final balance = double.tryParse(
                  _hasTransactions ? '45.500' : '0.00',
                ) ??
                0.0;
            final result = await showModalBottomSheet<dynamic>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  WithdrawalBottomSheet(availableBalance: balance),
            );

            if (result is Map && context.mounted) {
              showDialog(
                context: context,
                builder: (context) => const WithdrawalSuccessDialog(),
              );
            }
          },
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          backGroundColor: AppColors.primary,
        ),
      ),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  final String balance;

  const _WalletHeader({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 50.h,
        left: 20.w,
        right: 20.w,
        bottom: 30.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.r),
          bottomLeft: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                'wallet_title'.tr(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Text(
            'your_balance_label'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                balance,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'currency_egp'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyWalletState extends StatelessWidget {
  const _EmptyWalletState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 110.h),
          Image.asset(
            AppAssets.wallet,
            height: 193.h,
            width: 206.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 30.h),
          Text(
            'no_balance_message'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const _TransactionsList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'transaction_history_title'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 20.h),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => Divider(height: 24.h),
              itemBuilder: (context, index) {
                return _TransactionItem(transaction: transactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: transaction.isWithdrawal
                ? const Color(0xFFFFEAEA)
                : const Color(0xFFE8F5E9),
          ),
          child: Icon(
            transaction.isWithdrawal
                ? Icons.account_balance_wallet_outlined
                : Icons.fastfood_outlined,
            color: transaction.isWithdrawal ? Colors.red : Colors.green,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: transaction.isWithdrawal ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                transaction.id,
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.amount} ${'currency_egp'.tr()}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              transaction.date,
              style: TextStyle(fontSize: 12.sp, color: Colors.black45),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/support/presentation/pages/chat_screen.dart';

enum SupportFilter { all, open, closed }

class SupportTicket {
  final String id;
  final String subject;
  final String lastMessage;
  final DateTime updatedAt;
  final bool isOpen;
  final int unreadCount;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.lastMessage,
    required this.updatedAt,
    required this.isOpen,
    this.unreadCount = 0,
  });
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  SupportFilter _filter = SupportFilter.all;

  // mock data للعرض - هيتربط بـ API لاحقاً
  final List<SupportTicket> _tickets = [];

  List<SupportTicket> get _filteredTickets {
    switch (_filter) {
      case SupportFilter.all:
        return _tickets;
      case SupportFilter.open:
        return _tickets.where((t) => t.isOpen).toList();
      case SupportFilter.closed:
        return _tickets.where((t) => !t.isOpen).toList();
    }
  }

  void _openNewTicket() {
    context.slideTo(const ChatScreen());
  }

  @override
  Widget build(BuildContext context) {
    final tickets = _filteredTickets;
    final isEmpty = tickets.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 56.w,
        title: Text(
          'support_title'.tr(),
          style: AppStyles.inter18MediumBlack.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter chips - horizontal scroll عشان مش يتزحلقوا
          SizedBox(
            height: 44.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
              children: [
                _buildFilterChip(
                  label: 'support_filter_all'.tr(),
                  filter: SupportFilter.all,
                  count: _tickets.length,
                ),
                SizedBox(width: 8.w),
                _buildFilterChip(
                  label: 'support_filter_open'.tr(),
                  filter: SupportFilter.open,
                  count: _tickets.where((t) => t.isOpen).length,
                ),
                SizedBox(width: 8.w),
                _buildFilterChip(
                  label: 'support_filter_closed'.tr(),
                  filter: SupportFilter.closed,
                  count: _tickets.where((t) => !t.isOpen).length,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: isEmpty ? _buildEmptyState() : _buildTicketsList(tickets),
          ),
        ],
      ),
      floatingActionButton: isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _openNewTicket,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: AppColors.white),
              label: Text(
                'support_new_ticket'.tr(),
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  // ============================================================
  //                       Filter Chip
  // ============================================================

  Widget _buildFilterChip({
    required String label,
    required SupportFilter filter,
    required int count,
  }) {
    final isSelected = _filter == filter;
    return GestureDetector(
      onTap: () => setState(() => _filter = filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check, size: 14.sp, color: AppColors.white),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: AppStyles.inter14Regular.copyWith(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
            if (count > 0) ...[
              SizedBox(width: 6.w),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white.withValues(alpha: 0.25)
                      : AppColors.bg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '$count',
                  style: AppStyles.inter12Regular.copyWith(
                    color:
                        isSelected ? AppColors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  //                       Empty State
  // ============================================================

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          SizedBox(height: 24.h),
          // Illustration
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  size: 32.sp,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'support_empty_title'.tr(),
            style: AppStyles.inter18MediumBlack.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'support_empty_subtitle'.tr(),
              style: AppStyles.inter14Regular.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.h),
          // CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openNewTicket,
              icon: const Icon(Icons.add, color: AppColors.white),
              label: Text(
                'support_new_ticket'.tr(),
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Help footer
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline,
                    size: 18.sp, color: AppColors.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'support_help_hint'.tr(),
                    style: AppStyles.inter12Regular.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // ============================================================
  //                       Tickets List
  // ============================================================

  Widget _buildTicketsList(List<SupportTicket> tickets) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 100.h),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return _TicketCard(
          ticket: ticket,
          onTap: () => context.slideTo(const ChatScreen()),
        );
      },
    );
  }
}

// ============================================================
//                       Ticket Card
// ============================================================

class _TicketCard extends StatelessWidget {
  final SupportTicket ticket;
  final VoidCallback onTap;

  const _TicketCard({required this.ticket, required this.onTap});

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatDate(DateTime d) {
    return '${_twoDigits(d.day)}/${_twoDigits(d.month)}  ${_twoDigits(d.hour)}:${_twoDigits(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: ticket.isOpen
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.statusDeliveredBg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      ticket.isOpen
                          ? Icons.chat_bubble_outline_rounded
                          : Icons.task_alt_rounded,
                      size: 18.sp,
                      color: ticket.isOpen
                          ? AppColors.primary
                          : AppColors.orderSuccessGreen,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      ticket.subject,
                      style: AppStyles.inter14Regular.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _statusBadge(ticket.isOpen),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                ticket.lastMessage,
                style: AppStyles.inter12Regular.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 12.sp, color: AppColors.textLight),
                  SizedBox(width: 4.w),
                  Text(
                    _formatDate(ticket.updatedAt),
                    style: AppStyles.inter12Regular.copyWith(
                      color: AppColors.textLight,
                      fontSize: 11.sp,
                    ),
                  ),
                  const Spacer(),
                  if (ticket.unreadCount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${ticket.unreadCount}',
                        style: AppStyles.inter12Regular.copyWith(
                          color: AppColors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(bool isOpen) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isOpen ? AppColors.statusNewBg : AppColors.statusDeliveredBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: isOpen
                  ? AppColors.orderAmber
                  : AppColors.orderSuccessGreen,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            isOpen
                ? 'support_status_open'.tr()
                : 'support_status_closed'.tr(),
            style: AppStyles.inter12Regular.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isOpen
                  ? AppColors.orderAmber
                  : AppColors.orderSuccessGreen,
            ),
          ),
        ],
      ),
    );
  }
}

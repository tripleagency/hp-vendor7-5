import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/add_item/presentation/pages/create_recipe_screen.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';

/// Card representing a single item in the vendor's "My Recipes" list.
///
/// Visual structure:
///   ┌──────────────────────────────────────────────────────┐
///   │ ┌──────┐  Item name                       [status •] │
///   │ │image │  EGP 35.00  ̶2̶1̶0̶                            │
///   │ │      │  [Category]                                 │
///   │ └──────┘  ─────────────────────────────────────────  │
///   │  [ Edit ]                       Published  ──◯────  │
///   └──────────────────────────────────────────────────────┘
class ItemCard extends StatelessWidget {
  final ItemEntity item;
  final ValueChanged<bool>? onToggle;

  const ItemCard({super.key, required this.item, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top: image + (name + price + status pill) ──────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.inter16MediumBlack.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _StatusPill(isPublished: item.isPublished),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      _buildPriceRow(),
                      if (_categoryLabel(context, item).isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        _CategoryTag(name: _categoryLabel(context, item)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Hairline separator before action row ──────────────────────
          Container(height: 1, color: AppColors.cardBorder),

          // ── Bottom action row: Edit button + publish toggle ───────────
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 8.h),
            child: Row(
              children: [
                _EditButton(onPressed: () => _openEdit(context)),
                const Spacer(),
                _PublishToggle(
                  isPublished: item.isPublished,
                  onChanged: onToggle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  void _openEdit(BuildContext context) {
    // Edit mode — passes the existing item to prefill the form and switches
    // the screen into Update mode.
    context.slideTo(CreateRecipeScreen(existingItem: item));
  }

  /// CategoryEntity stores names per-locale (`nameEn` / `nameAr`); pick the
  /// matching one based on the active app locale.
  static String _categoryLabel(BuildContext context, ItemEntity item) {
    final cat = item.category;
    if (cat == null) return '';
    final isArabic = context.locale.languageCode.toLowerCase() == 'ar';
    final value = isArabic ? cat.nameAr : cat.nameEn;
    return value.trim();
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 110.w,
        height: 100.h,
        child: item.thumbnailUrl != null
            ? CachedNetworkImage(
                imageUrl: item.thumbnailUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _imagePlaceholder(),
                errorWidget: (_, __, ___) => _imageErrorWidget(),
              )
            : _imageErrorWidget(),
      ),
    );
  }

  Widget _buildPriceRow() {
    final hasDiscount =
        item.discount != null && (double.tryParse(item.discount!) ?? 0) > 0;

    final priceText =
        hasDiscount ? item.effectivePrice.toStringAsFixed(2) : item.price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          priceText,
          style: AppStyles.inter14MediumPrimary.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 15.sp,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          'EGP',
          style: AppStyles.inter12Regular.copyWith(
            color: AppColors.primary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        if (hasDiscount) ...[
          SizedBox(width: 8.w),
          Text(
            item.price,
            style: AppStyles.inter12Regular.copyWith(
              color: AppColors.gray,
              fontSize: 12.sp,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.gray,
            ),
          ),
        ],
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.bg,
      alignment: Alignment.center,
      child: SizedBox(
        width: 24.w,
        height: 24.h,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _imageErrorWidget() {
    return Container(
      color: AppColors.bg,
      child: Icon(
        Icons.fastfood_rounded,
        color: AppColors.textLight,
        size: 28.sp,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Visual sub-widgets
// ──────────────────────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final bool isPublished;
  const _StatusPill({required this.isPublished});

  @override
  Widget build(BuildContext context) {
    final color = isPublished ? AppColors.success : AppColors.warning;
    final label = isPublished ? 'publish_label'.tr() : 'pause_label'.tr();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: AppStyles.inter12Regular.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String name;
  const _CategoryTag({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        name,
        style: AppStyles.inter12Regular.copyWith(
          color: AppColors.textSecondary,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _EditButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit_outlined,
                size: 14.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                'edit_button'.tr(),
                style: AppStyles.inter12semiBoldBlack.copyWith(
                  color: AppColors.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PublishToggle extends StatelessWidget {
  final bool isPublished;
  final ValueChanged<bool>? onChanged;
  const _PublishToggle({required this.isPublished, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final label = isPublished ? 'publish_label'.tr() : 'pause_label'.tr();
    return Row(
      children: [
        Text(
          label,
          style: AppStyles.inter12Regular.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 6.w),
        // Slightly compact switch sized down for the action row.
        Transform.scale(
          scale: 0.85,
          child: Switch.adaptive(
            value: isPublished,
            onChanged: onChanged,
            activeColor: AppColors.white,
            activeTrackColor: AppColors.success,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.gray.withOpacity(0.4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

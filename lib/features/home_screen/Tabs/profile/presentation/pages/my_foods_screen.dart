import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/data/models/food_item.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/widgets/food_item_card.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';

class MyFoodsScreen extends StatefulWidget {
  const MyFoodsScreen({super.key});

  @override
  State<MyFoodsScreen> createState() => _MyFoodsScreenState();
}

class _MyFoodsScreenState extends State<MyFoodsScreen> {
  // Dummy data for visualization
  final List<FoodItem> _items = [
    FoodItem(
      id: '1',
      name: 'Sample Item 1',
      price: '0.00',
      imagePath: AppAssets.friedChicken,
      isPublished: true,
    ),
    FoodItem(
      id: '2',
      name: 'Sample Item 2',
      price: '0.00',
      imagePath: AppAssets.friedChicken,
      isPublished: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('my_recipes_title'.tr(), style: AppStyles.inter20RegularBlack),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _items.isEmpty ? const _EmptyState() : _buildListState(),
    );
  }

  Widget _buildListState() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('recent_add_label'.tr(), style: AppStyles.inter16MediumBlack),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              return FoodItemCard(
                item: _items[index],
                onToggle: (value) {
                  setState(() {
                    _items[index].isPublished = value;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.emptyFood,
            width: 376.w,
            height: 376.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 32.h),
          Text('empty_state'.tr(), style: AppStyles.inter26Regular),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}

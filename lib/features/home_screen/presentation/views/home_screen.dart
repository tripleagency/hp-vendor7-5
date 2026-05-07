import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/presentation/pages/items_tab.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/home_tab/presentation/views/home_tab.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/pages/orders_screen.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/profile_screen.dart';
import '../../../../core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import '../manager/home_cubit.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/cache/cache_helper.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/manager/profile_cubit.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = const [
    HomeTab(),
    OrdersScreen(),
    ItemsTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() {
    final vendorId = sl<CacheHelper>().getData(key: 'vendor_id');
    if (vendorId != null) {
      final int id = vendorId is int
          ? vendorId
          : int.tryParse(vendorId.toString()) ?? 0;
      if (id > 0) {
        context.read<ProfileCubit>().getVendorProfile(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        // OrdersCubit مشترك بين الـ Home tab والـ Orders tab عشان لما الـ
        // status يتغير في أي مكان (مثلاً الـ user يقبل order)، الـ counts
        // في الـ Home tab تتحدث فوراً.
        BlocProvider(create: (_) => sl<OrdersCubit>()..getOrders()),
      ],
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success && state.vendor != null) {
            // Success logic if needed, but the provider is going away
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();
            int currentIndex = 0;
            if (state is HomeChangeBottomNav) {
              currentIndex = state.index;
            }

            return Scaffold(
              body: _screens[currentIndex],
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (index) {
                    cubit.changeBottomNavIndex(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: Colors.grey,
                  selectedLabelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  items: [
                    BottomNavigationBarItem(
                      icon: _buildSvgIcon(AppAssets.homeSvg, Colors.grey),
                      activeIcon: _buildSvgIcon(
                        AppAssets.selectedHome,
                        AppColors.primary,
                      ),
                      label: 'home'.tr(),
                    ),
                    BottomNavigationBarItem(
                      icon: _buildSvgIcon(AppAssets.order, Colors.grey),
                      activeIcon: _buildSvgIcon(
                        AppAssets.selectedOrder,
                        AppColors.primary,
                      ),
                      label: 'orders'.tr(),
                    ),
                    BottomNavigationBarItem(
                      icon: _buildSvgIcon(AppAssets.item, Colors.grey),
                      activeIcon: _buildSvgIcon(
                        AppAssets.selectedItem,
                        AppColors.primary,
                      ),
                      label: 'items'.tr(),
                    ),
                    BottomNavigationBarItem(
                      icon: _buildSvgIcon(AppAssets.profile, Colors.grey),
                      activeIcon: _buildSvgIcon(
                        AppAssets.selectedProfile,
                        AppColors.primary,
                      ),
                      label: 'profile'.tr(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSvgIcon(String asset, Color color) {
    return SvgPicture.asset(
      asset,
      height: 22.h,
      width: 22.w,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

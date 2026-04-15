import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/home_tab/cubits/home/home_cubit.dart';
import 'package:we_care/features/home_tab/cubits/home/home_state.dart';

class BannerCrausalWidget extends StatelessWidget {
  const BannerCrausalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.adsRequestStatus != current.adsRequestStatus ||
          previous.ads != current.ads,
      builder: (context, state) {
        switch (state.adsRequestStatus) {
          case RequestStatus.loading:
            return _buildSkeleton();
          case RequestStatus.success:
            if (state.ads.isEmpty) {
              return const SizedBox.shrink();
            }
            return _buildCarousel(state.ads);
          case RequestStatus.failure:
            return _buildErrorWidget(state, context);
          default:
            if (state.ads.isNotEmpty) {
              return _buildCarousel(state.ads);
            }
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(seconds: 1),
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
  // Widget _buildSkeleton() {
  //   return Skeletonizer(
  //     enabled: true,
  //     effect: const ShimmerEffect(
  //       baseColor: Colors.red,
  //       highlightColor: Colors.white,
  //       begin: Alignment.centerLeft,
  //       end: Alignment.centerRight,
  //       duration: Duration(seconds: 1),
  //     ),
  //     child: Container(
  //       height: 130.h,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12.r),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCarousel(List<String> images) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 130.h,
        autoPlay: true,
        viewportFraction: 1,
        enlargeCenterPage: false,
      ),
      items: images.map(
        (imageUrl) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              placeholder: (context, url) => Skeletonizer(
                enabled: true,
                child: Container(
                  color: Colors.grey[300],
                  height: 130.h,
                  width: double.infinity,
                ),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error_outline, color: Colors.red),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildErrorWidget(HomeState state, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 32,
          ),
          verticalSpacing(8),
          Text(
            state.errorMessage ?? "حدث خطأ أثناء تحميل الإعلانات",
            textAlign: TextAlign.center,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              color: AppColorsManager.textColor,
            ),
          ),
          verticalSpacing(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.read<HomeCubit>().getAds(),
              icon: const Icon(
                Icons.refresh,
                size: 20,
                color: Colors.white,
              ),
              label: Text(
                "إعادة المحاولة",
                style: AppTextStyles.font14whiteWeight600,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

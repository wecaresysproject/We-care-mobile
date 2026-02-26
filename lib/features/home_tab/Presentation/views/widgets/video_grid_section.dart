import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/video_model.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/section_header_widget.dart';
import 'package:we_care/features/home_tab/cubits/home/home_cubit.dart';
import 'package:we_care/features/home_tab/cubits/home/home_state.dart';

class ModulesGuidanceVideosGridSection extends StatefulWidget {
  const ModulesGuidanceVideosGridSection({super.key});

  @override
  State<ModulesGuidanceVideosGridSection> createState() =>
      _ModulesGuidanceVideosGridSectionState();
}

class _ModulesGuidanceVideosGridSectionState
    extends State<ModulesGuidanceVideosGridSection> {
  bool _hasRequested = false;

  void _handleVisibility(BuildContext context) {
    if (_hasRequested) return;

    final cubit = context.read<HomeCubit>();

    if (cubit.state.videoRequestStatus == RequestStatus.initial) {
      _hasRequested = true;
      cubit.getModulesGuidanceVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('modules-guidance-videos-section'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.2) {
          _handleVisibility(context);
        }
      },
      child: Column(
        children: [
          const SectionHeaderWidget(title: "فيديوهات توضيحية"),
          verticalSpacing(5),
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                previous.videoRequestStatus != current.videoRequestStatus ||
                previous.videos != current.videos,
            builder: (context, state) {
              if (state.videoRequestStatus == RequestStatus.failure) {
                return buildErrorWidget(state, context);
              }

              final bool isLoading =
                  state.videoRequestStatus == RequestStatus.loading;

              final List<VideoModel> displayVideos = isLoading
                  ? List.generate(
                      4, (_) => VideoModel(videoLink: '', videoCoverImage: ''))
                  : state.videos;

              if (!isLoading && displayVideos.isEmpty) {
                return Center(
                  child: Text(
                    "لا توجد فيديوهات حالياً",
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      color: AppColorsManager.textColor,
                    ),
                  ),
                );
              }

              return Skeletonizer(
                enabled: isLoading,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayVideos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.89,
                  ),
                  itemBuilder: (context, index) {
                    return VideoItemWidget(video: displayVideos[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Container buildErrorWidget(HomeState state, BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 6.w),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(16),
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
          size: 40,
        ),
        Text(
          state.errorMessage ?? "حدث خطأ أثناء تحميل الفيديوهات",
          textAlign: TextAlign.center,
          style: AppTextStyles.font14whiteWeight600.copyWith(
            color: AppColorsManager.textColor,
          ),
        ),
        verticalSpacing(14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () =>
                context.read<HomeCubit>().getModulesGuidanceVideos(),
            icon: const Icon(
              Icons.refresh,
              size: 24,
              color: Colors.white,
            ),
            label: Text(
              "إعادة المحاولة",
              style: AppTextStyles.font14whiteWeight600,
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class VideoItemWidget extends StatelessWidget {
  final VideoModel video;
  const VideoItemWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchYouTubeVideo(
        video.videoLink.isEmptyOrNull
            ? "https://youtu.be/JiBtnD-173c?si=JF2inq5MS0USOVrb"
            : video.videoLink!,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: video.videoCoverImage ?? '',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/home_screen_videos.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
              ),
            ),
            Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 32.sp,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/models/video_model.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/section_header_widget.dart';
import 'package:we_care/features/home_tab/cubits/home/home_cubit.dart';
import 'package:we_care/features/home_tab/cubits/home/home_state.dart';

class VideoGridSection extends StatelessWidget {
  const VideoGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeaderWidget(title: "فيديوهات توضيحية"),
        verticalSpacing(5),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.videoRequestStatus == RequestStatus.loading) {
              return _buildSkeletonGrid();
            } else if (state.videoRequestStatus == RequestStatus.success) {
              if (state.videos.isEmpty) {
                return const Center(child: Text("لا توجد فيديوهات حالياً"));
              }
              return _buildVideoGrid(state.videos);
            } else if (state.videoRequestStatus == RequestStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? "حدث خطأ ما"),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildVideoGrid(List<VideoModel> videos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.89,
      ),
      itemBuilder: (context, index) {
        return VideoItemWidget(video: videos[index]);
      },
    );
  }

  Widget _buildSkeletonGrid() {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.89,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16.r),
            ),
          );
        },
      ),
    );
  }
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

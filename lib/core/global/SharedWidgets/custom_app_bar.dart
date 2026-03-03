import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';

class AppBarWithImageAndActionButtons extends StatefulWidget {
  const AppBarWithImageAndActionButtons(
      {super.key,
      this.haveBackArrow = false,
      this.onNavigateToBack,
      this.trailingActions});

  final bool haveBackArrow;
  final void Function()? onNavigateToBack;

  /// أيقونات إضافية في آخر الـ Row (زي play / book)
  final List<Widget>? trailingActions;

  @override
  State<AppBarWithImageAndActionButtons> createState() =>
      _AppBarWithImageAndActionButtonsState();
}

class _AppBarWithImageAndActionButtonsState
    extends State<AppBarWithImageAndActionButtons> {
  String userName = "";
  String userPhoto = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // final name = await CacheHelper.getString("userName");
    final photo = await CacheHelper.getString("userPhoto");
    if (mounted) {
      setState(() {
        // userName = name;
        userPhoto = photo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.haveBackArrow
            ? CustomBackArrow(
                onTap: widget.onNavigateToBack,
              )
            : SizedBox.shrink(),
        Spacer(),

        /// Trailing Icons عامة
        if (widget.trailingActions != null) ...widget.trailingActions!,
        horizontalSpacing(8),
        UserAvatarWidget(
          width: 40,
          height: 40,
          borderRadius: 17,
          userImageUrl: userPhoto,
        ),
      ],
    );
  }
}

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.userImageUrl,
  });
  final double width;
  final double height;
  final double borderRadius;
  final String? userImageUrl;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: CachedNetworkImage(
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/user_avatar.png', fit: BoxFit.cover),
            imageUrl: userImageUrl ?? "",
            fit: BoxFit.cover),
      ),
    );
  }
}

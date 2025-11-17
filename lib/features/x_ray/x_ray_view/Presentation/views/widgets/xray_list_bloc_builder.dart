import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/xray_card_item_widget.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/x_ray_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_state.dart';

class XrayListBlocBuilder extends StatelessWidget {
  const XrayListBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XRayViewCubit, XRayViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColorsManager.mainDarkBlue,
              backgroundColor: Colors.white,
            ),
          );
        } else if (state.requestStatus == RequestStatus.failure) {
          return Expanded(
            child: Center(
              child: Text('حدث خطأ في تحميل البيانات',
                  style: AppTextStyles.font22MainBlueWeight700),
            ),
          );
        } else if (state.userRadiologyData.isEmpty &&
            state.requestStatus == RequestStatus.success) {
          return Expanded(
            child: Center(
              child: Text('لا توجد نتائج',
                  style: AppTextStyles.font22MainBlueWeight700),
            ),
          );
        } else if (state.userRadiologyData.isNotEmpty &&
            state.requestStatus == RequestStatus.success) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.userRadiologyData.length,
            itemBuilder: (context, index) {
              final doc = state.userRadiologyData[index];
              return XRayCardItem(
                item: doc,
                onArrowTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => XRayDetailsView(
                        documentId: doc.id!,
                      ),
                    ),
                  );
                  if (context.mounted) {
                    await context.read<XRayViewCubit>().emitUserRadiologyData();
                  }
                },
              );
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

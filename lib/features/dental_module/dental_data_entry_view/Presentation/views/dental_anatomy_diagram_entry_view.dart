import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_cubit.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_state.dart';
import 'package:we_care/features/dental_module/dental_view/views/tooth_anatomy_view.dart';

class DentalAnatomyDiagramEntryView extends StatelessWidget {
  const DentalAnatomyDiagramEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DentalViewCubit>(
      create: (context) => getIt<DentalViewCubit>()..getDefectedTooth(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              CustomAppBarWidget(
                haveBackArrow: true,
              ).paddingSymmetricHorizontal(16),
              verticalSpacing(16),
              buildToothOverLayBlockBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToothOverLayBlockBuilder() {
    return BlocBuilder<DentalViewCubit, DentalViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ToothOverlay(
          isComingFromDataEntry: true,
          toothWithDataList: state.defectedToothList ?? [],
          selectedActionsList: state.defectedToothList ?? [],
          overlayTitle: "“من فضلك اختر السن المصاب لادخال البيانات الخاصة به”",
          onTap: (tappedTooth) async {
            await context.pushNamed(
              Routes.dentalDataEntryView,
              arguments: {
                "toothNumber": tappedTooth.toString(),
              },
            );
          },
        );
      },
    );
  }
}

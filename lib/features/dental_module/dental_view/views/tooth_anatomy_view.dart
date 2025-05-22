import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_cubit.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_state.dart';
import 'package:we_care/features/dental_module/dental_view/views/tooth_operations_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class ToothAnatomyView extends StatelessWidget {
  const ToothAnatomyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DentalViewCubit>(
      create: (context) => getIt<DentalViewCubit>()..getDefectedTooth(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(110.h),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  verticalSpacing(10.h),
                  CustomAppBarWidget(
                    haveBackArrow: true,
                  ),
                  verticalSpacing(8),
                  // TabBar
                  Material(
                    color: Colors.white,
                    child: TabBar(
                      labelColor: AppColorsManager.mainDarkBlue,
                      dividerColor: Colors.transparent,
                      indicatorColor: AppColorsManager.mainDarkBlue,
                      tabs: const [
                        Tab(text: "عرض 3D"),
                        Tab(text: "عرض بفلتر البحث"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: BlocBuilder<DentalViewCubit, DentalViewState>(
            builder: (context, state) {
              if (state.requestStatus==RequestStatus.loading) {
              
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  ToothOverlay(
                    toothWithDataList: state.defectedToothList ?? [],
                    overlayTitle: "“من فضلك اختر السن لعرض التفاصيل ”",
                    selectedActionsList: [],
                    onTap: (toothNumber) {
                      // Handle tap event
                      print('Tooth $toothNumber tapped');
                      navigateToToothDetail(toothNumber, context);
                    },
                  ),
                  SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DataViewFiltersRow(
                          filters: [
                            FilterConfig(
                                title: "السنة",
                                options: [2023, 2022, 2021, "الكل"]),
                            FilterConfig(
                                title: "النوع",
                                options: ["علاج عصب", "حشو عصب"]),
                            FilterConfig(title: "رقم السن", options: [
                              "السن 11",
                              "السن 22",
                              "السن 33",
                              "السن 44"
                            ]),
                          ],
                          onApply: (selectedOption) {
                            // Handle apply button action
                            print('Apply button pressed');
                          },
                        ),
                      ),
                      verticalSpacing(8),
                      ToothOverlay(
                        toothWithDataList: [],
                        overlayTitle: "",
                        selectedActionsList: [],
                        onTap: (toothNumber) {
                          // Handle tap event
                          print('Tooth $toothNumber tapped');
                          navigateToToothDetail(toothNumber, context);
                        },
                      ),
                    ]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ToothOverlay extends StatelessWidget {
  final List<int> toothWithDataList;
  final List<int> selectedActionsList;
  final String overlayTitle;
  final Function(int) onTap;

  const ToothOverlay({
    super.key,
    this.toothWithDataList = const [],
    this.selectedActionsList = const [],
    required this.overlayTitle,
    required this.onTap,
  });

  static const List<int> fdiNumbers = [
    // Upper right
    18, 17, 16, 15, 14, 13, 12, 11,
    // Upper left
    21, 22, 23, 24, 25, 26, 27, 28,
    // Lower left
    38, 37, 36, 35, 34, 33, 32, 31,
    // Lower right
    41, 42, 43, 44, 45, 46, 47, 48,
  ];

  static const List<Offset> toothRelativePositions = [
    // Upper right (18-11)
    Offset(0.180, 0.280),
    Offset(0.195, 0.235),
    Offset(0.210, 0.190),
    Offset(0.225, 0.150),
    Offset(0.245, 0.110),
    Offset(0.279, 0.075),
    Offset(0.347, 0.050),
    Offset(0.440, 0.040),

    // Upper left (21-28)
    Offset(0.535, 0.040),
    Offset(0.625, 0.050),
    Offset(0.689, 0.075),
    Offset(0.730, 0.110),
    Offset(0.760, 0.150),
    Offset(0.770, 0.190),
    Offset(0.786, 0.235),
    Offset(0.799, 0.280),

    // Lower left (38-31)
    Offset(0.799, 0.330), //38
    Offset(0.785, 0.375), //37
    Offset(0.762, 0.420), //36
    Offset(0.735, 0.458), //35
    Offset(0.705, 0.493), //34
    Offset(0.646, 0.520), //33
    Offset(0.580, 0.530), //32
    Offset(0.519, 0.535), //31

    // Lower right (41-48)
    Offset(0.460, 0.535), //41
    Offset(0.400, 0.530), //42
    Offset(0.336, 0.520), //43
    Offset(0.280, 0.493), //44
    Offset(0.239, 0.458), //45
    Offset(0.210, 0.420), //46
    Offset(0.189, 0.375), //47
    Offset(0.170, 0.330), //48
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double imageHeight = height * 0.6; // Adjust as needed
    return SingleChildScrollView(
      child: Column(
        children: [
          if (overlayTitle.isNotEmpty)
            Text(
              overlayTitle,
              style: AppTextStyles.font20blackWeight600,
              textAlign: TextAlign.center,
            ).paddingSymmetricHorizontal(16),
          Stack(
            children: [
              Image.asset(
                'assets/images/teeth_diagram.png',
                width: double.infinity,
                height: imageHeight,
              ),
              AspectRatio(
                aspectRatio: 900 / 1707,
                child: Stack(
                  children: List.generate(fdiNumbers.length, (index) {
                    final pos = toothRelativePositions[index];
                    final number = fdiNumbers[index];
                    return Positioned(
                      left: (pos.dx * width - 8),
                      top: (pos.dy * height - 8),
                      child: ToothCircle(
                        number: number,
                        hasData: toothWithDataList.contains(number),
                        onTap: () => onTap(number),
                      ),
                    );
                  }),
                ),
              ),
              CustomToothActionButton(
                  title: "اللثة العلوية\n يسار",
                  horizontalPosition: 0.33 * width,
                  verticalPosition: 0.15 * height,
                  hasDataPreviously: selectedActionsList.contains(55),
                  onTap: () => onTap(55)),
              CustomToothActionButton(
                  title: "للثة العلوية \n يمين",
                  horizontalPosition: 0.516 * width,
                  verticalPosition: 0.15 * height,
                  hasDataPreviously: selectedActionsList.contains(66),
                  onTap: () => onTap(66)),
              CustomToothActionButton(
                  title: "اللثة السفلية \n يسار",
                  horizontalPosition: 0.33 * width,
                  verticalPosition: 0.355 * height,
                  hasDataPreviously: selectedActionsList.contains(77),
                  onTap: () => onTap(77)),
              CustomToothActionButton(
                  title: "اللثة السفلية \n يمين",
                  horizontalPosition: 0.516 * width,
                  verticalPosition: 0.355 * height,
                  hasDataPreviously: selectedActionsList.contains(88),
                  onTap: () => onTap(88)),
              CustomToothActionButton(
                  title: "الفك العلوي",
                  horizontalPosition: 0.06 * width,
                  verticalPosition: 0.02 * height,
                  hasDataPreviously: selectedActionsList.contains(99),
                  onTap: () => onTap(99)),
              CustomToothActionButton(
                  title: "الفك السفلي",
                  horizontalPosition: 0.06 * width,
                  verticalPosition: 0.55 * height,
                  hasDataPreviously: selectedActionsList.contains(100),
                  onTap: () => onTap(100)),
              CustomToothActionButton(
                  title: "اللثة العلوية",
                  horizontalPosition: 0.80 * width,
                  verticalPosition: 0.02 * height,
                  hasDataPreviously: selectedActionsList.contains(111),
                  onTap: () => onTap(111)),
              CustomToothActionButton(
                  title: "اللثة السفلية",
                  horizontalPosition: 0.80 * width,
                  verticalPosition: 0.55 * height,
                  hasDataPreviously: selectedActionsList.contains(122),
                  onTap: () => onTap(122)),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomToothActionButton extends StatelessWidget {
  const CustomToothActionButton({
    super.key,
    required this.title,
    required this.horizontalPosition,
    required this.verticalPosition,
    required this.onTap,
    this.hasDataPreviously = false,
  });

  final String title;
  final double horizontalPosition;
  final double verticalPosition;
  final Function() onTap;
  final bool hasDataPreviously;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: horizontalPosition,
      top: verticalPosition,
      child: InkWell(
        onTap: hasDataPreviously ? onTap : null,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: hasDataPreviously
                      ? Colors.red
                      : const Color.fromARGB(255, 195, 192, 192),
                  borderRadius: BorderRadius.circular(22),
                ),
                width: 43.w,
                height: 43.h,
              ),
              Center(
                child: Text(
                  title,
                  style: AppTextStyles.font12blackWeight400
                      .copyWith(fontWeight: FontWeight.w800, fontSize: 9.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
      ),
    );
  }
}

class ToothCircle extends StatelessWidget {
  final int number;
  final bool hasData;
  final Function onTap;

  const ToothCircle(
      {super.key,
      required this.number,
      required this.hasData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasData ? () => onTap() : null,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              hasData ? Colors.red : const Color.fromARGB(255, 195, 192, 192),
        ),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void navigateToToothDetail(int toothNumber, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ToothOperationsView(
       selectedTooth: toothNumber,
      ),
    ),
  );
}

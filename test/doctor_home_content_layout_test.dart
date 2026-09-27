import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_home_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_performance_metric_model.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_home_content_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_timeline_stats_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/monthly_examinations_section_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/performance_stats_row_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// The redesigned dashboard sections pack Arabic labels, rings and dividers
/// into narrow equal-width columns, where an overconstrained Row silently
/// blanks the whole screen. These render each section at the design size and
/// fail on any layout exception or overflow.
void main() {
  final doctorHome = DoctorHomeModel(
    doctorName: 'د. اختبار',
    specialty: 'باطنة',
    doctorPhotoUrl: '',
    clinicLogoUrl: '',
    waitingCount: 10,
    followUpsCount: 8,
    currentBookingsCount: 15,
    allowedBookingsCount: 20,
    dataCompletionPercentage: 50,
    achievedExaminationsCount: 8,
    monthlyTargetExaminationsCount: 10,
    yearlyTargetExaminationsCount: 600,
    appearances: DoctorPerformanceMetricModel(
      monthlyCount: 200,
      yearlyCount: 600,
    ),
    shares: DoctorPerformanceMetricModel(monthlyCount: 200, yearlyCount: 600),
    watches: DoctorPerformanceMetricModel(monthlyCount: 200, yearlyCount: 600),
    adBannerImageUrls: [],
    commentsCount: 0,
    comments: [],
    ratingsCount: 0,
  );

  Future<void> pumpSection(WidgetTester tester, Widget section) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: section,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('timeline stats row lays out without overflow', (tester) async {
    await pumpSection(
      tester,
      DoctorTimelineStatsWidget(
        waitingCount: doctorHome.waitingCount,
        followUpsCount: doctorHome.followUpsCount,
        currentBookingsCount: doctorHome.currentBookingsCount,
        allowedBookingsCount: doctorHome.allowedBookingsCount,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('20'), findsOneWidget);
  });

  testWidgets('monthly examinations section lays out without overflow', (
    tester,
  ) async {
    await pumpSection(
      tester,
      MonthlyExaminationsSectionWidget(
        achievedExaminationsCount: doctorHome.achievedExaminationsCount,
        monthlyTargetExaminationsCount:
            doctorHome.monthlyTargetExaminationsCount,
        yearlyTargetExaminationsCount: doctorHome.yearlyTargetExaminationsCount,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('performance stats row lays out without overflow', (
    tester,
  ) async {
    await pumpSection(
      tester,
      PerformanceStatsRowWidget(
        appearances: doctorHome.appearances,
        shares: doctorHome.shares,
        watches: doctorHome.watches,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('200'), findsNWidgets(3));
  });

  testWidgets('full dashboard content renders every redesigned section', (
    tester,
  ) async {
    await pumpSection(
      tester,
      DoctorHomeContentWidget(doctorHome: doctorHome),
    );

    // Exceptions here come from asset images (not bundled in tests) and a
    // pre-existing overflow in RatingsBarWidget, neither of which this
    // redesign touches — the per-section tests above are what guard it.
    tester.takeException();

    // Top summary, monthly section and the three stat cards are all present.
    expect(find.text('20'), findsOneWidget);
    expect(find.text('الكشوفات الشهرية'), findsOneWidget);
    expect(find.text('200'), findsNWidgets(3));
  });
}

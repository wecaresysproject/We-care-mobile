import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';

extension BuildContextOperations on BuildContext {
  S get translate => S.of(this);

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorSchemeTheme => Theme.of(this).colorScheme;

  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  ///Dont show bottom nav bar in the pushed page
  Future<dynamic> pushNamedWithSettingRootNavigator(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(
      this,
      rootNavigator: true,
    ).pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop({Object? result}) => Navigator.of(
        this,
      ).pop(result);

  /// Show a standard SnackBar
  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 4),
    Color backgroundColor = Colors.black,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: Theme.of(this).textTheme.headlineMedium,
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      dismissDirection: DismissDirection.horizontal,
    );

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

extension PaddingListOperations on List<Widget> {
  List<Widget> paddingFrom({
    double? top,
    double? bottom,
    double? right,
    double? left,
  }) {
    return map(
      (listOneChild) => Padding(
        padding: EdgeInsets.only(
          bottom: (bottom ?? 0).h,
          right: (right ?? 0).w,
          left: (left ?? 0).w,
          top: (top ?? 0).h,
        ),
        child: listOneChild,
      ),
    ).toList();
  }

  List<Widget> paddingFromSymmetric({double? vertical, double? horizontal}) {
    return map(
      (e) => Padding(
        padding: EdgeInsetsDirectional.symmetric(
          vertical: (vertical ?? 0).h,
          horizontal: (horizontal ?? 0).w,
        ),
        child: e,
      ),
    ).toList();
  }
}

extension PaddingExtension on Widget {
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding.r),
      child: this,
    );
  }

  Widget paddingFrom({
    double? top,
    double? bottom,
    double? right,
    double? left,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: (top ?? 0).h,
        bottom: (bottom ?? 0).h,
        left: (left ?? 0).w,
        right: (right ?? 0).w,
      ),
      child: this,
    );
  }

  Widget paddingSymmetricHorizontal(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
      child: this,
    );
  }

  Widget paddingSymmetricVertical(double verticalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
      child: this,
    );
  }

  Widget paddingLeft(double leftPadding) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding.w),
      child: this,
    );
  }

  Widget paddingRight(double rightPadding) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding.w),
      child: this,
    );
  }

  Widget paddingTop(double topPadding) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding.h),
      child: this,
    );
  }

  Widget paddingBottom(double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding.h),
      child: this,
    );
  }
}

extension StringExtensions on String? {
  int get toInt => int.parse(this!);
  bool get isEmptyOrNull => this == '' || this == null;
  String get firstLetterToUpperCase =>
      this![0].toUpperCase() + this!.substring(1);
}

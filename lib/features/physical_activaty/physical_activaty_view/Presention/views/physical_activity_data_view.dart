import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/logic/physical_activaty_view_cubit.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/widgets/physical_activity_view_body_widget.dart';

class PhysicalActivityDataView extends StatelessWidget {
  const PhysicalActivityDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhysicalActivityViewCubit>(
      create: (context) =>
          getIt<PhysicalActivityViewCubit>()..getIntialRequests(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/blue_gradiant.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/physical_activity_view_background_1.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            ),
            Image.asset(
              'assets/images/shadow.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            const PhysicalActivityDataViewBody(),
          ],
        ),
      ),
    );
  }
}

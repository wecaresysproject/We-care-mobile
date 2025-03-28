import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/image_with_text_button_widget.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/user_type/Presentation/views/widgets/shadow_text_widget.dart';

class UserTypesView extends StatelessWidget {
  const UserTypesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShadowText(
                text: "WE CARE SYS",
              ),
              verticalSpacing(72),
              CustomImageWithTextButton(
                text: context.translate.patient,
                imagePath: "assets/images/patient.png",
                onTap: () {
                  //TODO: call bloc from this point to save user type in order to use it later in the app when making any request
                  context.pushNamed(Routes.signUpView);
                },
              ),
              verticalSpacing(40),
              CustomImageWithTextButton(
                text: context.translate.doctorSpecialist,
                imagePath: "assets/images/doctor_or_specialist.png",
                onTap: () {
                  context.pushNamed(Routes.signUpView);
                },
              ),
              verticalSpacing(40),
              CustomImageWithTextButton(
                text: context.translate.medicalServiceProviders,
                imagePath: "assets/images/medical_service_providers.png",
                onTap: () {
                  context.pushNamed(Routes.signUpView);
                },
              ),
              verticalSpacing(40),
              CustomImageWithTextButton(
                text: context.translate.insuranceCompanies,
                imagePath: "assets/images/insurance_companies.png",
                onTap: () {
                  context.pushNamed(Routes.signUpView);
                },
              ),
              verticalSpacing(40),
              CustomImageWithTextButton(
                text: context.translate.supportingEntities,
                imagePath: "assets/images/supprting_entites.png",
                onTap: () {
                  context.pushNamed(Routes.signUpView);
                },
              ),
              verticalSpacing(40),
            ],
          ).paddingSymmetricHorizontal(
            16,
          ),
        ),
      ),
    );
  }
}

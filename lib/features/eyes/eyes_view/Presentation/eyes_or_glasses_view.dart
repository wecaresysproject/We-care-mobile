import 'package:flutter/material.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/eye_or_galsses_view.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/eye_part_procedures_and_symptoms_details_view.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/eye_parts_view.dart';

class EyesOrGlassesDataView extends StatelessWidget {
  const EyesOrGlassesDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return EyeOrGlassesView(
      onGlassesTapped: () {
        Navigator.pushNamed(
          context,
          Routes.glassesInformationView,
        );
      },
      onEyesTapped: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EyePartsView(
                      pageTitle: 'اضغط على جزء العين الذى تريد عرضه',
                      eyePartsImages: {
                        'الجفون': 'assets/images/eye_lid.png',
                        'القرنية': 'assets/images/cornea.png',
                        'الملتحمة': 'assets/images/conjunctiva.png',
                        'بياض العين': 'assets/images/sclera.png',
                        'الشبكية': 'assets/images/retina.png',
                        'العصب البصرى': 'assets/images/optic_nerve.png',
                        'القزحيه': 'assets/images/pupil.png',
                        'العدسة': 'assets/images/lens.png',
                        'الجسم الزجاجى': 'assets/images/vitreous.png',
                        'السائل المائى': 'assets/images/aqueous.png',
                      },
                      handleArrowTap: (partName) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EyePartProceduresAndSymptomsView(
                              eyePart: partName,
                            ),
                          ),
                        );
                      },
                    )));
      },
    );
  }
}

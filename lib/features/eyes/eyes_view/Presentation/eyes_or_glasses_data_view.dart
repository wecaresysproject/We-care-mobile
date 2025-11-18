import 'package:flutter/material.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/eye_part_view_data_entry.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/eye_or_galsses_view.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/eye_part_procedures_and_symptoms_view.dart';
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
      onEyesTapped:  () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EyePartsViewDataEntry(
                              pageTitle: 'اضغط على جزء العين الذى تريد عرضه',
                              handleArrowTap: (partName) async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => EyePartProceduresAndSymptomsView(
                                  eyePart: partName,
                                ),
                              ));
                              },
                            ),));
      },
    );
  }
}

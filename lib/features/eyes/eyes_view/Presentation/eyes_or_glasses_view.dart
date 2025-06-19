import 'package:flutter/material.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/eye_or_galsses_view.dart';

class EyesOrGlassesDataView extends StatelessWidget {
  const EyesOrGlassesDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return EyeOrGlassesView(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.glassesInformationView,
        );
      },
    );
  }
}
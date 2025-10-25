import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class GeneticDiseasesHomeScreen extends StatelessWidget {
  const GeneticDiseasesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBarWithCenteredTitle(
              title: 'الامراض الوراثية',
              showActionButtons: false,
            ),
            Spacer(),

            // Family Tree Button
            CustomButton(
              title: 'شجرة العائلة',
              image: 'assets/images/family_tree_icon.png',
              onTap: () {
                Navigator.pushNamed(context, Routes.familyTreeScreen);
              },
            ),

            // Genetic Diseases Button
            CustomButton(
              title: 'امراضي الوراثية',
              image: 'assets/images/dna_icon.png',
              onTap: () {
                Navigator.pushNamed(
                    context, Routes.personalGeneticDiseasesScreen);
              },
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });
  final String title;
  final String image;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        height: 140,
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue,
          borderRadius: BorderRadius.circular(88),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(
                  flex: 2,
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    image,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

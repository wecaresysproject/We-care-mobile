import 'package:flutter/material.dart';
import '../../logic/medical_report_export_logic.dart';
import '../widgets/medical_report_widget.dart';
import '../../../../core/global/theming/color_manager.dart';

class MedicalReportExportPage extends StatefulWidget {
  const MedicalReportExportPage({super.key});

  @override
  State<MedicalReportExportPage> createState() => _MedicalReportExportPageState();
}

class _MedicalReportExportPageState extends State<MedicalReportExportPage> {
  final MedicalReportExportLogic _logic = MedicalReportExportLogic();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Medical Report'),
        backgroundColor: AppColorsManager.mainDarkBlue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Preview (Landscape Mode)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              // Use FittedBox to scale the wide widget down to fit the screen width
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: const MedicalReportWidget(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isExporting ? null : _handleExport,
        backgroundColor: AppColorsManager.mainDarkBlue,
        icon: _isExporting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.share, color: Colors.white),
        label: Text(
          _isExporting ? 'Generating PDF...' : 'Export & Share',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _handleExport() async {
    setState(() {
      _isExporting = true;
    });

    await _logic.exportAndShareReport(context);

    if (mounted) {
      setState(() {
        _isExporting = false;
      });
    }
  }
}

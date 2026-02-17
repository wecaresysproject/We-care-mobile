import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';

/// Modern medical-grade card inspired by Sehhaty/Vezeeta design
/// Features: RTL support, soft colors, clean medical feel
class MedicineAlarmCard extends StatelessWidget {
  final MedicineAlarmModel medicineAlarm;
  final VoidCallback onStop;

  const MedicineAlarmCard({
    super.key,
    required this.medicineAlarm,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {}, // Subtle feedback
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Medicine icon (right side for RTL)
                _buildMedicineIcon(),
                const SizedBox(width: 16),

                // Medicine info (center-left)
                Expanded(child: _buildMedicineInfo()),

                const SizedBox(width: 12),

                // Stop button (left side for RTL)
                _buildStopButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Soft medical-grade icon container
  Widget _buildMedicineIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A90E2).withOpacity(0.1),
            const Color(0xFF357ABD).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.medication_rounded,
        color: Color(0xFF4A90E2), // Calm medical blue
        size: 28,
      ),
    );
  }

  /// Medicine name and alarm count
  Widget _buildMedicineInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Medicine name - primary text
        Text(
          medicineAlarm.medicineName,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50), // Dark medical text
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),

        // Alarm count - secondary text with icon
        Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              size: 16,
              color: const Color(0xFF7F8C8D).withOpacity(0.7),
            ),
            const SizedBox(width: 4),
            Text(
              '${medicineAlarm.alarmId.length} تنبيه',
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                fontSize: 13,
                color: const Color(0xFF7F8C8D), // Subtle grey
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Calm stop button (not aggressive red)
  Widget _buildStopButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5), // Very soft red background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE57373).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onStop,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 18,
                  color: const Color(0xFFE57373), // Soft coral red
                ),
                const SizedBox(width: 6),
                Text(
                  'إيقاف',
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE57373), // Matching coral red
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

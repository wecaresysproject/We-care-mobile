import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_images_with_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

/// صفحات الروشتة جوه التطبيق — بتتفتح من "عرض / تحميل الروشتة" فى تفاصيل
/// الكشف: سحب بين الصفحات مع تكبير، حفظ الصفحة الحالية فى معرض الصور،
/// ومشاركة كل الصفحات.
class BookingPrescriptionImagesView extends StatefulWidget {
  const BookingPrescriptionImagesView({super.key, required this.images});

  final List<String> images;

  @override
  State<BookingPrescriptionImagesView> createState() =>
      _BookingPrescriptionImagesViewState();
}

class _BookingPrescriptionImagesViewState
    extends State<BookingPrescriptionImagesView> {
  int _currentIndex = 0;
  bool _isSaving = false;
  bool _isSharing = false;

  Future<void> _saveCurrentPage() async {
    setState(() => _isSaving = true);
    try {
      if (!await Gal.hasAccess() && !await Gal.requestAccess()) {
        await showError("يجب السماح بالوصول إلى الصور لحفظ الروشتة");
        return;
      }
      final path = await downloadImage(
        widget.images[_currentIndex],
        await getTemporaryDirectory(),
        'prescription_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      if (path == null) {
        await showError("تعذر تحميل صفحة الروشتة");
        return;
      }
      await Gal.putImage(path);
      await showSuccess("تم حفظ الصفحة في الصور");
    } catch (e) {
      AppLogger.error("Failed to save prescription page: $e");
      await showError("تعذر حفظ صفحة الروشتة");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _shareAllPages() async {
    setState(() => _isSharing = true);
    await shareImages(context, widget.images, "الروشتة");
    if (mounted) setState(() => _isSharing = false);
  }

  @override
  Widget build(BuildContext context) {
    final pagesCount = widget.images.length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          pagesCount > 1
              ? "الروشتة (${_currentIndex + 1} / $pagesCount)"
              : "الروشتة",
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: PageView.builder(
        itemCount: pagesCount,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) => PhotoView(
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 4,
          imageProvider: NetworkImage(widget.images[index]),
          loadingBuilder: (_, __) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: pagesCount > 1 ? "حفظ الصفحة" : "حفظ في الصور",
                  icon: Icons.download_rounded,
                  isLoading: _isSaving,
                  onPressed: _isSaving ? null : _saveCurrentPage,
                ),
              ),
              horizontalSpacing(12),
              Expanded(
                child: _ActionButton(
                  label: "مشاركة",
                  icon: Icons.share_outlined,
                  isLoading: _isSharing,
                  onPressed: _isSharing ? null : _shareAllPages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      icon: isLoading
          ? SizedBox(
              width: 16.r,
              height: 16.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon, size: 18.sp),
      label: Text(
        label,
        style: AppTextStyles.font14blackWeight400.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

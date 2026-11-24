import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// "نسخة الروشتة": the pages of a saved prescription, page 1 first, each
/// zoomable; the top-bar button shares all pages.
class DoctorPrescriptionCopyView extends StatefulWidget {
  const DoctorPrescriptionCopyView({super.key, required this.images});

  final List<String> images;

  @override
  State<DoctorPrescriptionCopyView> createState() =>
      _DoctorPrescriptionCopyViewState();
}

class _DoctorPrescriptionCopyViewState
    extends State<DoctorPrescriptionCopyView> {
  bool _isSharing = false;

  /// Downloads every page at once, then opens the share sheet with all of
  /// them in page order. If any page fails, nothing is shared, so the
  /// recipient never gets a partial prescription.
  Future<void> _share(BuildContext buttonContext) async {
    // iPad needs the button's position to anchor the share popover.
    final box = buttonContext.findRenderObject() as RenderBox?;
    final origin =
        box == null ? null : box.localToGlobal(Offset.zero) & box.size;

    setState(() => _isSharing = true);
    try {
      final directory = await getTemporaryDirectory();
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final paths = await Future.wait([
        for (var i = 0; i < widget.images.length; i++)
          downloadFile(
            widget.images[i],
            directory,
            'prescription_${stamp}_page_${i + 1}.png',
          ),
      ]);
      if (paths.any((path) => path == null)) {
        await showError("تعذر تحميل صفحات الروشتة، حاول مرة أخرى");
        return;
      }
      await Share.shareXFiles(
        [for (final path in paths) XFile(path!, mimeType: 'image/png')],
        text: "الروشتة",
        sharePositionOrigin: origin,
      );
    } catch (_) {
      await showError("تعذر مشاركة الروشتة");
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.prescriptionScaffoldBackground,
      // Back on the left and share on the right, like the design — not
      // mirrored for Arabic.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 8),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AppBar(
            backgroundColor: AppColorsManager.prescriptionTitleColor,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            toolbarHeight: kToolbarHeight + 8,
            leadingWidth: 64,
            leading: Center(
              child: _AppBarCircleButton(
                tooltip: "رجوع",
                onPressed: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              "نسخة الروشتة",
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              Builder(
                builder: (buttonContext) => _AppBarCircleButton(
                  tooltip: "مشاركة",
                  onPressed: _isSharing ? null : () => _share(buttonContext),
                  child: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.ios_share_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        itemCount: widget.images.length,
        separatorBuilder: (_, __) => verticalSpacing(14),
        itemBuilder: (context, index) => _PrescriptionPage(
          url: widget.images[index],
        ),
      ),
    );
  }
}

class _PrescriptionPage extends StatelessWidget {
  const _PrescriptionPage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    Widget error(BuildContext _, Object __, StackTrace? ___) => AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: Text(
              "تعذر تحميل صفحة الروشتة",
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: AppColorsManager.prescriptionSubtitleColor,
              ),
            ),
          ),
        );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorsManager.prescriptionCardBorder),
        boxShadow: [
          BoxShadow(
            color:
                AppColorsManager.prescriptionTitleColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InteractiveViewer(
        maxScale: 4,
        child: Image.network(
          url,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : const AspectRatio(
                  aspectRatio: 1,
                  child: Center(child: CircularProgressIndicator()),
                ),
          errorBuilder: error,
        ),
      ),
    );
  }
}

/// A round, lightly filled button on the navy app bar, so the back and share
/// icons stand out from the background.
class _AppBarCircleButton extends StatelessWidget {
  const _AppBarCircleButton({
    required this.tooltip,
    required this.onPressed,
    required this.child,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.16),
        shape: CircleBorder(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.28)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

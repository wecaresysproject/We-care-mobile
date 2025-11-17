import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_details_model.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_lens_data_request_body_model.dart';
import 'package:we_care/features/eyes/data/repos/glasses_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'glasses_data_entry_state.dart';

class GlassesDataEntryCubit extends Cubit<GlassesDataEntryState> {
  GlassesDataEntryCubit(this._glassesDataEntryRepo, this.sharedRepo)
      : super(
          GlassesDataEntryState.initialState(),
        );
  final GlassesDataEntryRepo _glassesDataEntryRepo;
  final AppSharedRepo sharedRepo;

  final formKey = GlobalKey<FormState>();
  final TextEditingController storNameController = TextEditingController();
  // Controllers for Right Lens
  final TextEditingController rightShortSightController =
      TextEditingController(); // قصر النظر للعدسة اليمنى
  final TextEditingController rightLongSightController =
      TextEditingController(); // طول النظر للعدسة اليمنى
  final TextEditingController rightAstigmatismController =
      TextEditingController(); // الاستجماتزم للعدسة اليمنى
  final TextEditingController rightAstigmatismAxisController =
      TextEditingController(); // محور الاستجماتزم للعدسة اليمنى
  final TextEditingController rightFocalAdditionController =
      TextEditingController(); // الاضافة البؤرية للعدسة اليمنى
  final TextEditingController rightPupilDistanceController =
      TextEditingController(); // تباعد الحدقتين للعدسة اليمنى
  final TextEditingController rightRefractiveIndexController =
      TextEditingController(); // معامل الانكسار للعدسة اليمنى
  final TextEditingController rightLensDiameterController =
      TextEditingController(); // قطر العدسة للعدسة اليمنى
  final TextEditingController rightCenterController =
      TextEditingController(); // المركز للعدسة اليمنى
  final TextEditingController rightEdgesController =
      TextEditingController(); // الحواف للعدسة اليمنى
  final TextEditingController rightLensThicknessController =
      TextEditingController(); // سُمك العدسة للعدسة اليمنى

// Controllers for Left Lens
  final TextEditingController leftShortSightController =
      TextEditingController(); // قصر النظر للعدسة اليسرى
  final TextEditingController leftLongSightController =
      TextEditingController(); // طول النظر للعدسة اليسرى
  final TextEditingController leftAstigmatismController =
      TextEditingController(); // الاستجماتزم للعدسة اليسرى
  final TextEditingController leftAstigmatismAxisController =
      TextEditingController(); // محور الاستجماتزم للعدسة اليسرى
  final TextEditingController leftFocalAdditionController =
      TextEditingController(); // الاضافة البؤرية للعدسة اليسرى
  final TextEditingController leftPupilDistanceController =
      TextEditingController(); // تباعد الحدقتين للعدسة اليسرى
  final TextEditingController leftRefractiveIndexController =
      TextEditingController(); // معامل الانكسار للعدسة اليسرى
  final TextEditingController leftLensDiameterController =
      TextEditingController(); // قطر العدسة للعدسة اليسرى
  final TextEditingController leftCenterController =
      TextEditingController(); // المركز للعدسة اليسرى
  final TextEditingController leftEdgesController =
      TextEditingController(); // الحواف للعدسة اليسرى
  final TextEditingController leftLensThicknessController =
      TextEditingController(); // سُمك العدسة للعدسة اليسرى

  Future<void> loadPastGlassesDataForEditing({
    required String decoumentId,
    required EyeGlassesDetailsModel oldGlassesData,
    required S locale,
  }) async {
    emit(
      state.copyWith(
        examinationDateSelection: oldGlassesData.date,
        doctorName: oldGlassesData.doctorName,
        selectedHospitalCenter: oldGlassesData.hospitalName,
        glassesStore: oldGlassesData.storeName,
        antiReflection: oldGlassesData.antiReflection,
        isBlueLightProtection: oldGlassesData.blueLightProtection,
        isScratchResistance: oldGlassesData.scratchResistance,
        isAntiFingerprint: oldGlassesData.fingerprintResistance,
        isAntiFogCoating: oldGlassesData.antiFog,
        isUVProtection: oldGlassesData.uvProtection,
        isEditMode: true,
        decoumentId: decoumentId,
        rightlensSurfaceType: oldGlassesData.rightEye.lensSurfaceType,
        rightLensType: oldGlassesData.rightEye.lensType,
        leftLensSurfaceType: oldGlassesData.leftEye.lensSurfaceType,
        leftLensType: oldGlassesData.leftEye.lensType,
      ),
    );
    storNameController.text == locale.no_data_entered
        ? ''
        : oldGlassesData.storeName;

    intiliazeRightLensControllersWithOldData(oldGlassesData);
    intiliazeLeftLensControllersWithOldData(oldGlassesData);

    validateRequiredFields();
    await getInitialRequests();
  }

  void intiliazeRightLensControllersWithOldData(
      EyeGlassesDetailsModel oldGlassesData) {
    // قصر النظر للعدسة اليمنى
    rightShortSightController.text = oldGlassesData.rightEye.myopiaDegree;
    // طول النظر للعدسة اليمنى
    rightLongSightController.text = oldGlassesData.rightEye.hyperopiaDegree;
    // الاستجماتزم للعدسة اليمنى
    rightAstigmatismController.text =
        oldGlassesData.rightEye.astigmatismDegree == '--'
            ? ''
            : oldGlassesData.rightEye.astigmatismDegree;
    // محور الاستجماتزم للعدسة اليمنى
    rightAstigmatismAxisController.text =
        oldGlassesData.rightEye.astigmatismAxis == '--'
            ? ''
            : oldGlassesData.rightEye.astigmatismAxis;
    // الاضافة البؤرية للعدسة اليمنى
    rightFocalAdditionController.text =
        oldGlassesData.rightEye.nearAddition == '--'
            ? ''
            : oldGlassesData.rightEye.nearAddition;
    // تباعد الحدقتين للعدسة اليمنى
    rightPupilDistanceController.text =
        oldGlassesData.rightEye.pupillaryDistance == '--'
            ? ''
            : oldGlassesData.rightEye.pupillaryDistance;
    // معامل الانكسار للعدسة اليمنى
    rightRefractiveIndexController.text =
        oldGlassesData.rightEye.refractiveIndex == '--'
            ? ''
            : oldGlassesData.rightEye.refractiveIndex;
    // قطر العدسة للعدسة اليمنى
    rightLensDiameterController.text =
        oldGlassesData.rightEye.lensDiameter == '--'
            ? ''
            : oldGlassesData.rightEye.lensDiameter;
    // المركز للعدسة اليمنى
    rightCenterController.text = oldGlassesData.rightEye.lensCentering == '--'
        ? ''
        : oldGlassesData.rightEye.lensCentering;
    // الحواف للعدسة اليمنى
    rightEdgesController.text = oldGlassesData.rightEye.lensEdgeType == '--'
        ? ''
        : oldGlassesData.rightEye.lensEdgeType;
    // سُمك العدسة للعدسة اليمنى
    rightLensThicknessController.text =
        oldGlassesData.rightEye.lensThickness == '--'
            ? ''
            : oldGlassesData.rightEye.lensThickness;
  }

  void intiliazeLeftLensControllersWithOldData(
      EyeGlassesDetailsModel oldGlassesData) {
    leftShortSightController.text = oldGlassesData.leftEye.myopiaDegree;
    // طول النظر للعدسة
    leftLongSightController.text = oldGlassesData.leftEye.hyperopiaDegree;
    // الاستجماتزم للعدسة
    leftAstigmatismController.text =
        oldGlassesData.leftEye.astigmatismDegree == '--'
            ? ''
            : oldGlassesData.leftEye.astigmatismDegree;
    // محور الاستجماتزم للعدسة
    leftAstigmatismAxisController.text =
        oldGlassesData.leftEye.astigmatismAxis == '--'
            ? ''
            : oldGlassesData.leftEye.astigmatismAxis;
    // الاضافة البؤرية للعدسة
    leftFocalAdditionController.text =
        oldGlassesData.leftEye.nearAddition == '--'
            ? ''
            : oldGlassesData.leftEye.nearAddition;
    // تباعد الحدقتين للعدسة
    leftPupilDistanceController.text =
        oldGlassesData.leftEye.pupillaryDistance == '--'
            ? ''
            : oldGlassesData.leftEye.pupillaryDistance;
    // معامل الانكسار للعدسة
    leftRefractiveIndexController.text =
        oldGlassesData.leftEye.refractiveIndex == '--'
            ? ''
            : oldGlassesData.leftEye.refractiveIndex;
    // قطر العدسة للعدسة
    leftLensDiameterController.text =
        oldGlassesData.leftEye.lensDiameter == '--'
            ? ''
            : oldGlassesData.leftEye.lensDiameter;
    // المركز للعدسة
    leftCenterController.text = oldGlassesData.leftEye.lensCentering == '--'
        ? ''
        : oldGlassesData.leftEye.lensCentering;
    // الحواف للعدسة
    leftEdgesController.text = oldGlassesData.leftEye.lensEdgeType == '--'
        ? ''
        : oldGlassesData.leftEye.lensEdgeType;
    // سُمك العدسة للعدسة
    leftLensThicknessController.text =
        oldGlassesData.leftEye.lensThickness == '--'
            ? ''
            : oldGlassesData.leftEye.lensThickness;
  }

  /// Update Field Values
  void updateExaminationDate(String? date) {
    emit(state.copyWith(examinationDateSelection: date));
    validateRequiredFields();
  }

  void updateLeftLensType(String? val) {
    emit(state.copyWith(leftLensType: val));
  }

  void updateRightLensType(String? val) {
    emit(state.copyWith(rightLensType: val));
  }

  void updateRightlensSurfaceType(String? val) {
    emit(
      state.copyWith(rightlensSurfaceType: val),
    );
  }

  void updateLeftlensSurfaceType(String? val) {
    emit(
      state.copyWith(leftLensSurfaceType: val),
    );
  }

  void updateAntiReflection(bool? val) {
    emit(state.copyWith(antiReflection: val));
  }

  void updateSelectedDoctor(String? val) {
    emit(state.copyWith(doctorName: val));
  }

  void updateSelectedHospital(String? val) {
    emit(state.copyWith(selectedHospitalCenter: val));
  }

  void updateSelectedGlassesStore(String? val) {
    emit(state.copyWith(glassesStore: val));
  }

  void updateAntiBlueLight(bool? val) {
    emit(state.copyWith(isBlueLightProtection: val));
  }

  void updateScratchResistance(bool? val) {
    emit(state.copyWith(isScratchResistance: val));
  }

  void updateAntiFingerprint(bool? val) {
    emit(state.copyWith(isAntiFingerprint: val));
  }

  void updateAntiFogCoating(bool? val) {
    emit(state.copyWith(isAntiFogCoating: val));
  }

  void updateUVProtection(bool? val) {
    emit(state.copyWith(isUVProtection: val));
  }

  Future<void> getInitialRequests() async {
    Future.wait([
      emitDoctorNames(),
      emitGetAllLensTypes(),
      emitGetAllLensSurfacesTypes(),
      getHospitalNames(),
    ]);
  }

  Future<void> submitGlassesLensDataEntered({required S locale}) async {
    emit(
      state.copyWith(
        submitGlassesLensDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _glassesDataEntryRepo.postGlassesLensDataEntry(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: EyeGlassesLensDataRequestBodyModel(
        leftLens: LensData(
          myopiaDegree: leftShortSightController.text.isEmpty
              ? "--"
              : leftShortSightController.text,
          hyperopiaDegree: leftLongSightController.text.isEmpty
              ? "--"
              : leftLongSightController.text,
          astigmatismDegree: leftAstigmatismController.text.isEmpty
              ? "--"
              : leftAstigmatismController.text,
          astigmatismAxis: leftAstigmatismAxisController.text.isEmpty
              ? "--"
              : leftAstigmatismAxisController.text,
          nearAddition: leftFocalAdditionController.text.isEmpty
              ? "--"
              : leftFocalAdditionController.text,
          pupillaryDistance: leftPupilDistanceController.text.isEmpty
              ? "--"
              : leftPupilDistanceController.text,
          refractiveIndex: leftRefractiveIndexController.text.isEmpty
              ? "--"
              : leftRefractiveIndexController.text,
          lensDiameter: leftLensDiameterController.text.isEmpty
              ? "--"
              : leftLensDiameterController.text,
          lensCentering: leftCenterController.text.isEmpty
              ? "--"
              : leftCenterController.text,
          lensEdgeType: leftEdgesController.text.isEmpty
              ? "--"
              : leftEdgesController.text,
          lensSurfaceType: state.leftLensSurfaceType ?? "--",
          lensThickness: leftLensThicknessController.text.isEmpty
              ? "--"
              : leftLensThicknessController.text,
          lensType: state.leftLensType ?? "--",
        ),
        rightLens: LensData(
          myopiaDegree: rightShortSightController.text.isEmpty
              ? "--"
              : rightShortSightController.text,
          hyperopiaDegree: rightLongSightController.text.isEmpty
              ? "--"
              : rightLongSightController.text,
          astigmatismDegree: rightAstigmatismController.text.isEmpty
              ? "--"
              : rightAstigmatismController.text,
          astigmatismAxis: rightAstigmatismAxisController.text.isEmpty
              ? "--"
              : rightAstigmatismAxisController.text,
          nearAddition: rightFocalAdditionController.text.isEmpty
              ? "--"
              : rightFocalAdditionController.text,
          pupillaryDistance: rightPupilDistanceController.text.isEmpty
              ? "--"
              : rightPupilDistanceController.text,
          refractiveIndex: rightRefractiveIndexController.text.isEmpty
              ? "--"
              : rightRefractiveIndexController.text,
          lensDiameter: rightLensDiameterController.text.isEmpty
              ? "--"
              : rightLensDiameterController.text,
          lensCentering: rightCenterController.text.isEmpty
              ? "--"
              : rightCenterController.text,
          lensEdgeType: rightEdgesController.text.isEmpty
              ? "--"
              : rightEdgesController.text,
          lensSurfaceType: state.rightlensSurfaceType ?? "--",
          lensThickness: rightLensThicknessController.text.isEmpty
              ? "--"
              : rightLensThicknessController.text,
          lensType: state.rightLensType ?? "--",
        ),
        examinationDate: state.examinationDateSelection ?? "--",
        doctorName: state.doctorName ?? locale.no_data_entered,
        centerHospitalName:
            state.selectedHospitalCenter ?? locale.no_data_entered,
        glassesShop: state.glassesStore ?? locale.no_data_entered,
        antiReflection: state.antiReflection,
        blueLightProtection: state.isBlueLightProtection,
        scratchResistance: state.isScratchResistance,
        antiFingerprintCoating: state.isAntiFingerprint,
        antiFogCoating: state.isAntiFogCoating,
        uvProtection: state.isUVProtection,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            submitGlassesLensDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            submitGlassesLensDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitGetAllLensTypes() async {
    final response = await _glassesDataEntryRepo.getAllLensTypes(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            lensTypes: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitGetAllLensSurfacesTypes() async {
    final response = await _glassesDataEntryRepo.getAllLensSurfaces(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            lensSurfcacesTypes: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitDoctorNames() async {
    final response = await sharedRepo.getAllDoctors(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
      specialization: "طب العيون",
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            doctorNames: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> getHospitalNames() async {
    final response = await sharedRepo.getHospitalNames(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            hosptitalsNames: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.examinationDateSelection == null) {
      emit(
        state.copyWith(
          isFormValidated: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFormValidated: true,
        ),
      );
    }
  }

  // editGlassesDataEntered
  Future<void> submitEditGlassesDataEntered(
    S locale,
  ) async {
    emit(
      state.copyWith(
        submitGlassesLensDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _glassesDataEntryRepo.editGlassesDataEntered(
      id: state.decoumentId,
      requestBody: EyeGlassesLensDataRequestBodyModel(
        examinationDate: state.examinationDateSelection!,
        leftLens: LensData(
          myopiaDegree: leftShortSightController.text,
          hyperopiaDegree: leftLongSightController.text,
          astigmatismDegree: leftAstigmatismController.text,
          astigmatismAxis: leftAstigmatismAxisController.text,
          nearAddition: leftFocalAdditionController.text,
          pupillaryDistance: leftPupilDistanceController.text,
          refractiveIndex: leftRefractiveIndexController.text,
          lensDiameter: leftLensDiameterController.text,
          lensCentering: leftCenterController.text,
          lensEdgeType: leftEdgesController.text,
          lensSurfaceType: state.leftLensSurfaceType,
          lensThickness: leftLensThicknessController.text,
          lensType: state.leftLensType,
        ),
        rightLens: LensData(
          hyperopiaDegree: rightLongSightController.text,
          myopiaDegree: rightShortSightController.text,
          astigmatismDegree: rightAstigmatismController.text,
          astigmatismAxis: rightAstigmatismAxisController.text,
          nearAddition: rightFocalAdditionController.text,
          pupillaryDistance: rightPupilDistanceController.text,
          refractiveIndex: rightRefractiveIndexController.text,
          lensDiameter: rightLensDiameterController.text,
          lensCentering: rightCenterController.text,
          lensEdgeType: rightEdgesController.text,
          lensSurfaceType: state.rightlensSurfaceType,
          lensThickness: rightLensThicknessController.text,
          lensType: state.rightLensType,
        ),
        doctorName: state.doctorName!,
        centerHospitalName: state.selectedHospitalCenter!,
        glassesShop: state.glassesStore!,
        antiReflection: state.antiReflection,
        blueLightProtection: state.isBlueLightProtection,
        scratchResistance: state.isScratchResistance,
        antiFingerprintCoating: state.isAntiFingerprint,
        antiFogCoating: state.isAntiFogCoating,
        uvProtection: state.isUVProtection,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            submitGlassesLensDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            submitGlassesLensDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    rightShortSightController.dispose();
    rightLongSightController.dispose();
    rightAstigmatismController.dispose();
    rightAstigmatismAxisController.dispose();
    rightFocalAdditionController.dispose();
    rightPupilDistanceController.dispose();
    rightRefractiveIndexController.dispose();
    rightLensDiameterController.dispose();
    rightCenterController.dispose();
    rightEdgesController.dispose();
    rightLensThicknessController.dispose();

    leftShortSightController.dispose();
    leftLongSightController.dispose();
    leftAstigmatismController.dispose();
    leftAstigmatismAxisController.dispose();
    leftFocalAdditionController.dispose();
    leftPupilDistanceController.dispose();
    leftRefractiveIndexController.dispose();
    leftLensDiameterController.dispose();
    leftCenterController.dispose();
    leftEdgesController.dispose();
    leftLensThicknessController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}

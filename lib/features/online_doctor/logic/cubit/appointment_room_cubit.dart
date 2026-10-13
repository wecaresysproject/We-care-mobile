import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_room_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'appointment_room_state.dart';

class AppointmentRoomCubit extends Cubit<AppointmentRoomState> {
  AppointmentRoomCubit(this._onlineDoctorRepo)
      : super(const AppointmentRoomState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  /// الموعد اللى الغرفة مفتوحة عليه — طلبات الأسئلة بتتبعت عليه.
  String _bookingId = '';

  Future<void> getAppointmentRoom(String bookingId) async {
    _bookingId = bookingId;
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.getAppointmentRoom(
      bookingId: bookingId,
    );
    if (isClosed) return;

    result.when(
      success: (room) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            room: room,
            questions: room.questions,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            errorMessage: error.errors.first,
          ),
        );
      },
    );
  }

  /// السؤال الجديد بيتضاف فى آخر القايمة.
  Future<void> addQuestion(String text) async {
    if (!_startQuestionRequest()) return;

    final result = await _onlineDoctorRepo.addBookingQuestion(
      bookingId: _bookingId,
      text: text,
    );
    if (isClosed) return;

    result.when(
      success: (question) => _emitQuestions([...state.questions, question]),
      failure: (error) => _emitQuestionFailure(error.errors.first),
    );
  }

  /// السؤال المعدّل بيفضل فى نفس مكانه.
  Future<void> editQuestion({
    required RoomQuestionModel question,
    required String text,
  }) async {
    if (!_startQuestionRequest()) return;

    final result = await _onlineDoctorRepo.editBookingQuestion(
      bookingId: _bookingId,
      question: question,
      text: text,
    );
    if (isClosed) return;

    result.when(
      success: (editedQuestion) => _emitQuestions([
        for (final current in state.questions)
          identical(current, question) ? editedQuestion : current,
      ]),
      failure: (error) => _emitQuestionFailure(error.errors.first),
    );
  }

  Future<void> deleteQuestion(RoomQuestionModel question) async {
    if (!_startQuestionRequest()) return;

    final result = await _onlineDoctorRepo.deleteBookingQuestion(
      bookingId: _bookingId,
      questionId: question.questionId,
    );
    if (isClosed) return;

    result.when(
      success: (_) => _emitQuestions([
        for (final current in state.questions)
          if (!identical(current, question)) current,
      ]),
      failure: (error) => _emitQuestionFailure(error.errors.first),
    );
  }

  /// طلب واحد على الأسئلة فى المرة — بيرجّع `false` لو فيه طلب شغال.
  bool _startQuestionRequest() {
    if (state.questionRequestStatus == RequestStatus.loading) return false;
    emit(state.copyWith(questionRequestStatus: RequestStatus.loading));
    return true;
  }

  void _emitQuestions(List<RoomQuestionModel> questions) {
    emit(
      state.copyWith(
        questionRequestStatus: RequestStatus.success,
        questions: questions,
      ),
    );
  }

  void _emitQuestionFailure(String message) {
    emit(
      state.copyWith(
        questionRequestStatus: RequestStatus.failure,
        questionErrorMessage: message,
      ),
    );
  }
}

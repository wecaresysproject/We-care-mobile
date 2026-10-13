part of 'edit_booking_comment_cubit.dart';

class EditBookingCommentState extends Equatable {
  final RequestStatus saveStatus;

  /// رسالة فشل آخر طلب حفظ — بتتعرض كـ toast.
  final String errorMessage;

  /// الموعد بالتعليق الجديد بعد نجاح الحفظ — بيرجع لشاشة التفاصيل.
  final BookingHistoryModel? commentedBooking;

  const EditBookingCommentState({
    this.saveStatus = RequestStatus.initial,
    this.errorMessage = '',
    this.commentedBooking,
  });

  EditBookingCommentState copyWith({
    RequestStatus? saveStatus,
    String? errorMessage,
    BookingHistoryModel? commentedBooking,
  }) {
    return EditBookingCommentState(
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      commentedBooking: commentedBooking ?? this.commentedBooking,
    );
  }

  @override
  List<Object?> get props => [saveStatus, errorMessage, commentedBooking];
}

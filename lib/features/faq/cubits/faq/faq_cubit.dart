import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/features/faq/repositories/faq_repository.dart';
import 'faq_state.dart';

class FAQCubit extends Cubit<FAQState> {
  final FAQRepository _faqRepository;

  FAQCubit(this._faqRepository) : super(FAQInitial());

  Future<void> getFaq() async {
    emit(FAQLoading());
    final result = await _faqRepository.getFaq();

    result.when(
      success: (faqList) {
        emit(FAQLoaded(faqList));
      },
      failure: (error) {
        emit(FAQError(error.errors.first));
      },
    );
  }
}

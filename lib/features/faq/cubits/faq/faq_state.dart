import 'package:we_care/features/faq/models/faq_model.dart';

abstract class FAQState {}

class FAQInitial extends FAQState {}

class FAQLoading extends FAQState {}

class FAQLoaded extends FAQState {
  final List<FAQModel> faqList;

  FAQLoaded(this.faqList);
}

class FAQError extends FAQState {
  final String message;

  FAQError(this.message);
}

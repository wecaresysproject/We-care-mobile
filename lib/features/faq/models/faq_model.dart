class FAQModel {
  final String? id;
  final String? question;
  final String? answer;

  FAQModel({
    this.id,
    this.question,
    this.answer,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id'] as String?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }
}

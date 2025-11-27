class AssessmentAnswer {
  final int questionId;
  int? answerId;
  String? answerText;

  AssessmentAnswer({
    required this.questionId,
    this.answerId,
    this.answerText,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer_id': answerId,
      'answer_text': answerText,
    };
  }
}

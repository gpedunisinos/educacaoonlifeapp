class QuestionCorrection {
  final bool isCorrect;
  final int questionCompletionId;

  QuestionCorrection({
    required this.isCorrect,
    required this.questionCompletionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'is_correct': isCorrect,
      'question_completion_id': questionCompletionId,
    };
  }
}

class AssessmentCorrectionRequestModel {
  final int assessmentCompletionId;
  final String? correctionNotes;
  final List<QuestionCorrection> questions;
  final int teacherId;

  AssessmentCorrectionRequestModel({
    required this.assessmentCompletionId,
    this.correctionNotes,
    required this.questions,
    required this.teacherId,
  });

  Map<String, dynamic> toJson() {
    return {
      'assessment_completion_id': assessmentCompletionId,
      'correction_notes': correctionNotes,
      'questions': questions.map((q) => q.toJson()).toList(),
      'teacher_id': teacherId,
    };
  }
}

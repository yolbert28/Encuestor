import 'package:encuestor/domain/survey_option.dart';

class Survey {
  final int id;
  final String question;
  final int subjectId;
  final List<SurveyOption> options;

  Survey(
      {required this.id,
      required this.question,
      required this.subjectId,
      required this.options});
}

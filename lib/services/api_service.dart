// Class to handle requests to the remote question bank API
//
import 'dart:convert';

import 'package:quiz_app/models/question_model.dart';
import 'package:http/http.dart' as http;

class QuestionAPIService {
  QuestionAPIService(this.client);

  final http.Client client;
  final String baseURL =
      'https://stevecassidy.github.io/harry-potter-quiz-app/lib/data';

  Future<List<QuizQuestion>> getQuestions() async {
    final response = await client.get(Uri.parse('$baseURL/questions.json'));

    if (response.statusCode == 200) {
      final responseObject = jsonDecode(response.body) as Map<String,
          dynamic>; //dynamic means the type of the response will vary

      List<QuizQuestion> result = [];
      if (responseObject['questions'].length > 0) {
        for (final question in responseObject['questions']) {
          try {
            result.add(QuizQuestion.fromJson(question));
          } catch (e) {
            throw Exception('failed to get question data: $e');
          }
        }
        return result;
      }
    }
    throw Exception('failed to get question data');
  }
}

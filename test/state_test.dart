//This is a UNIT TEST
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/state.dart';
import 'package:test/test.dart';
import 'state_test.mocks.dart';
import 'questions.dart';

@GenerateMocks([http.Client])
void main() {
  //putting this code here will allow to use the mock http client with all the tests
  final client = MockClient();

  when(client.get(Uri.parse(
          'https://stevecassidy.github.io/harry-potter-quiz-app/lib/data/questions.json')))
      .thenAnswer((_) async => http.Response(jsonEncode(questionsJson), 200));

  test('State model returns quiz questions', () {
    // final client = MockClient();

    // when(client.get(Uri.parse(
    //         'https://stevecassidy.github.io/harry-potter-quiz-app/lib/data/questions.json')))
    //     .thenAnswer((_) async => http.Response(jsonEncode(questionsJson), 200));

    var testState = StateModel(client);

    testState.addListener(() {
      expect(testState.questions.length, 6);
      expect(testState.getCurrentQuestion().questionText, startsWith("What"));
    });
  });

  // test('State model can add a new answer', () {
  //   var testState = StateModel(client);

  //   //print("test new length $listLength");

  //   // var answer = testState.questions;
  //   // print(answer.first);

  //   testState.addListener(() {
  //     // var answersLength = testState.answers[0];
  //     // print(answersLength);

  //     //var test = testState.currentQuestionNumber;
  //     //List test = testState.answers;

  //     List<QuizQuestion> question = testState.questions;

  //     //testState.addAnswer(question[0].answersList[0]);

  //     // List summary = testState.getSummaryData();
  //     // print(summary);
  //     // List<String> test = testState.answers;

  //     // print("test: ${test[0]}");
  //     // if (testState.answers.isNotEmpty) {
  //     //   testState.addAnswer(answer);
  //     //   print(testState.answers.length);
  //     // }
  //     // print(testState.answers.length);
  //     // print(answer);
  //     //expect(testState.questions.length, 6);
  //     expect(testState.answers.length, 6);
  //     // expect(testState.getCurrentQuestion().questionText, startsWith("What"));
  //   });
  // });
}

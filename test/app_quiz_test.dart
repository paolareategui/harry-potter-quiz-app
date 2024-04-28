//This is a WIDGET TEST
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/app_quiz.dart';
import 'package:quiz_app/models/state.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:quiz_app/screens/questions_screen/app_answer_button.dart';
import 'questions.dart';
import 'state_test.mocks.dart';

void main() {
  final client = MockClient();

  when(client.get(Uri.parse(
          'https://stevecassidy.github.io/harry-potter-quiz-app/lib/data/questions.json')))
      .thenAnswer((_) async => http.Response(jsonEncode(questionsJson), 200));

  testWidgets('Main App interaction', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => StateModel(client),
      child: const Quiz(),
    ));

    // should start showing the home screen
    final titleFinder = find.text("Harry Potter Quiz App");
    final startFinder = find.text("Start the Quiz");

    expect(titleFinder, findsOneWidget);
    expect(startFinder, findsOneWidget);

    // tap the start button and we should move to the quiz
    await tester.tap(startFinder);

    await tester.pump(); //allows you to let the application update its state

    // verify we're on the question screen by text
    final questionFinder = find.text("Question 1");
    expect(questionFinder, findsOneWidget);

    // or by looking for a widget key
    final questionTextFinder = find.byKey(const Key('question-text'));
    expect(questionTextFinder, findsOneWidget);
  });

  testWidgets('Quiz progression', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => StateModel(client),
      child: const Quiz(),
    ));
    final BuildContext context = tester.element(find.byType(Quiz));

    //Save the data from provider
    var testState = Provider.of<StateModel>(context, listen: false);

    //Start the quiz by pressing the "start quiz" button
    final startFinder = find.text("Start the Quiz");
    expect(startFinder, findsOneWidget);

    // tap the start button and we should move to the quiz
    await tester.tap(startFinder);
    await tester.pump(); //allows you to let the application update its state

    print(" ");
    print("STARTING POINT: $startFinder");

    for (var question in testState.questions) {
      var firstAnswer = question.answersList.first;

      var answerButtonFinder = find.text(firstAnswer);
      expect(answerButtonFinder, findsOneWidget);
      await tester.pump();
      await tester.tap(answerButtonFinder);
      await tester.pump();
    }

    //Verify the final screen is shown by checking if the restart button is there
    final restartFinder = find.text("Restart Quiz");
    expect(restartFinder, findsOneWidget);
    // tap the start button and we should move back to the start
    //await tester.tap(restartFinder);
  });
}

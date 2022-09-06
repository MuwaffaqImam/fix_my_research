import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swp/utils/analysis_data.dart';
import 'package:swp/widgets/analyzed_text_widget.dart';

void main() {
  testWidgets("Test analyzed text widget for changing analysis",
      (WidgetTester tester) async {
    AnalyzedTextController controller = AnalyzedTextController();

    AnalyzedText analyzedText1 =
        AnalyzedText(rawText: "test", analyzedSentences: [
      AnalyzedSentence(
          match: "test", sentence: "test", label: "test", description: "test")
    ]);
    AnalyzedText analyzedText2 =
        AnalyzedText(rawText: "bla lol.", analyzedSentences: [
      AnalyzedSentence(
          match: "lol",
          sentence: "bla lol.",
          label: "test",
          description: "test")
    ]);

    Future<AnalyzedText> future1 = Future.value(analyzedText1);

    await tester.pumpWidget(MaterialApp(
        home: SizedBox(
      width: 100,
      height: 100,
      child: AnalyzedTextWidget(
        analysis: future1,
        controller: controller,
      ),
    )));

    expect(controller.currentAnalysis!.rawText, "test");
    controller.changeDirectCallback(analyzedText2);
    expect(controller.currentAnalysis!.rawText, "bla lol.");
  });
}

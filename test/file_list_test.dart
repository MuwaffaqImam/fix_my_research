import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swp/utils/analysis_data.dart';
import 'package:swp/widgets/file_list.dart';

void main() {
  testWidgets("Test file list widget for deleting/adding",
      (WidgetTester tester) async {
    FileListController controller = FileListController();
    await tester.pumpWidget(MaterialApp(
        home: SizedBox(
      width: 100,
      height: 100,
      child: FileListWidget(
        controller: controller,
        // ignore: prefer_const_literals_to_create_immutables
        sequentialRequests: [],
        onSelected: (text) {},
      ),
    )));

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
    Future<AnalyzedText> future2 = Future.value(analyzedText2);

    controller.addFiles([future1, future2]);
    expect(controller.allAnalyzes.length, 2);
  });
}

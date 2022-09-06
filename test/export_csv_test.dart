import 'package:flutter_test/flutter_test.dart';
import 'package:swp/utils/analysis_data.dart';

void main() {
  test("Check exporting analysis to CSV", () async {
    AnalyzedText text = AnalyzedText(
        rawText:
            "Bla bla\nla la. Test gets. Mama\n\nMia. Be aware; hehe. Or be super aware\n;hehe.",
        analyzedSentences: [
          AnalyzedSentence(
              match: "Bla",
              sentence: "Bla bla\nla la.",
              label: "test",
              description: "test"),
          AnalyzedSentence(
              match: "gets",
              sentence: "Test gets.",
              label: "test",
              description: "test"),
          AnalyzedSentence(
              match: "Mama",
              sentence: "Mama\n\nMia.",
              label: "test",
              description: "test"),
          AnalyzedSentence(
              match: "aware",
              sentence: "Be aware; hehe.",
              label: "test",
              description: "test"),
          AnalyzedSentence(
              match: "be",
              sentence: "Or be super aware\n;hehe.",
              label: "test",
              description: "test")
        ]);

    expect(text.convertToCSV(),
        '"1";"Match";"Sentence";"Label";"Description"\n"2";"Bla";"Bla bla la la.";"test";"test"\n"3";"gets";"Test gets.";"test";"test"\n"4";"Mama";"Mama  Mia.";"test";"test"\n"5";"aware";"Be aware; hehe.";"test";"test"\n"6";"be";"Or be super aware ;hehe.";"test";"test"');
  });
}

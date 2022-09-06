import 'package:flutter_test/flutter_test.dart';
import 'package:swp/utils/analysis_data.dart';
import 'package:swp/utils/api_interactions.dart';

void main() {
  test("Test if API (Mock or Real) is working.", () async {
    AnalyzedText text = await sendToIExtract("There are very problem", "test");
    expect(text.rawText, "There are very problem");
    expect(text.filename, "test");
    expect(text.analyzedSentences.length, greaterThan(0));
  });
}

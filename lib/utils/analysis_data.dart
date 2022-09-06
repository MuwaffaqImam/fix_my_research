import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swp/utils/web_file_creator.dart';

List<AnalyzedSentence> analyzedSentenceFromJson(String str) =>
    List<AnalyzedSentence>.from(
        json.decode(str).map((x) => AnalyzedSentence.fromJson(x)));

String analyzedSentenceToJson(List<AnalyzedSentence> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnalyzedSentence {
  AnalyzedSentence({
    required this.match,
    required this.sentence,
    required this.label,
    required this.description,
  });

  String match;
  String sentence;
  String label;
  String description;

  factory AnalyzedSentence.fromJson(Map<String, dynamic> json) =>
      AnalyzedSentence(
        match: json["match"],
        sentence: json["sentence"],
        label: json["label"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "match": match,
        "sentence": sentence,
        "label": label,
        "description": description,
      };

  List<String> splitOnThree() {
    String part1 = "";
    String part2 = "";
    String part3 = "";

    int beginPos = sentence.indexOf(match);
    int endPos = beginPos + match.length;
    for (int i = 0; i < sentence.length; i++) {
      if (i < beginPos) {
        part1 += sentence[i];
      } else if (i >= beginPos && i < endPos) {
        part2 += sentence[i];
      } else {
        part3 += sentence[i];
      }
    }

    return [part1, part2, part3];
  }
}

///  Contain dat from API with report about mistakes
class AnalyzedText {
  final String? filename;
  final String rawText;
  final List<AnalyzedSentence> analyzedSentences;

  AnalyzedText(
      {required this.rawText, required this.analyzedSentences, this.filename});

  String convertToCSV() {
    String fileContent = '"1";"Match";"Sentence";"Label";"Description"';
    int i = 2;
    for (AnalyzedSentence sentence in analyzedSentences) {
      fileContent +=
          '\n"$i";"${sentence.match}";"${sentence.sentence.replaceAll("\n", " ")}";"${sentence.label}";"${sentence.description}"';
      i++;
    }
    return fileContent;
  }

  void saveAsCSV() {
    if (filename == null) {
      downloadFile(convertToCSV(), "report.csv");
    } else {
      downloadFile(convertToCSV(), filename!.replaceAll(".pdf", ".csv"));
    }
  }
}

/// Add AnalyzedSentence instance to the DataBase
void addMistakeToFirestore(Map<String, dynamic> data) {
  var db = FirebaseFirestore.instance;
  db.collection('reports').add(data);
  //sendListToAPI();
}

/// Send list of false-positive mistakes to the API
void sendListToAPI() {
  // var db = FirebaseFirestore.instance;
  // db.collection('reports').get().then((value) {
  //   value.docs.cast()
  // });
}

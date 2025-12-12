import 'dart:io';

import 'package:path/path.dart';

class Score {
  int score;
  Score(this.score);

  void show() => print("점수: $score");
}

class StudentScore extends Score {
  String name;

  StudentScore(this.name, super.score);

  @override
  void show(){
    print("이름: $name, 점수: $score");
  }

  factory StudentScore.fromCsv(String line){
    final parts = line.split(',');
    if(parts.length != 2){
      throw FormatException("잘못된 데이터 형식: $line");
    }

    final name = parts[0].trim();
    final score = int.parse(parts[1].trim());

    return StudentScore(name, score);
  }
}

List<StudentScore> loadStudentData(String filePath){//학생 점수 읽는 함수
  try{
    final lines = File(filePath).readAsLinesSync();
    return lines.map((line) => StudentScore.fromCsv(line)).toList();
  } catch(e) {
    print("학생 데이터를 불러오는 데 실패했습니다");
    exit(1);
  }
}

StudentScore findBestStudent(List<StudentScore> students){ //우수생 찾는 함수
  return students.reduce(
    (best, current) => current.score > best.score ? current : best,
  );
}

double avg(List<StudentScore> students){ //평균 점수 계산 함수
  if(students.isEmpty) return 0;

  int total = students.fold(0, (sum, s) => sum + s.score);
  return total / students.length;
}

void printMenu(){
  print("1. 우수생 출력");
  print("2. 전체 평균 점수 출력");
  print("3. 종료");
  print("메뉴 번호를 입력하세요: ");
  print("");
}

void main() {
  final students = loadStudentData("../students.txt");//상대경로 students.txt

  while(true){
    printMenu();

    String? input = stdin.readLineSync();

    if(input == "1"){
      final best = findBestStudent(students);
      print("우수생: ${best.name}(평균 점수: ${best.score.toStringAsFixed(2)})");
    } else if(input == "2"){
      double avgCalculate = avg(students);
      print("전체 평수 점수: ${avgCalculate.toStringAsFixed(2)}");
    } else if(input == "3"){
      print("3. 종료");
      exit(1);
    } else {
      print("잘못된 입력입니다. 다시 입력해주세요.");
    }
  }
}
import 'dart:io';

class Score {
  int score;

  Score(this.score);

  void showInfo() {
    print("점수: $score");
  }
}

class StudentScore extends Score {
  String name;

  StudentScore(this.name, int score) : super(score);

  @override
  void showInfo() {
    print("이름: $name, 점수: $score");
  }
}


List<StudentScore> loadStudentData(String filePath) {
  List<StudentScore> students = [];//이름: , 점수:

  try {
    final file = File(filePath);
    final lines = file.readAsLinesSync();

    for (var line in lines) {
      final parts = line.split(',');
      if (parts.length != 2) {
        throw FormatException("잘못된 데이터 형식: $line");
      }

      String name = parts[0].trim();
      int score = int.parse(parts[1].trim());

      students.add(StudentScore(name, score));
    }
  } catch (e) {
    print("학생 데이터를 불러오는 데 실패했습니다: $e"); //오류 발생 시 프로그램 종료
    exit(1);
  }

  return students;
}


StudentScore getStudentFromUser(List<StudentScore> students) {
  while (true) {
    print("어떤 학생의 통계를 확인하시겠습니까? (예: 1: 홍길동, 2: 김철수)"); //인코딩 문제로 한글 입력이 아닌 정수 입력으로 대체 하였습니다.

    String? input = stdin.readLineSync();

    if (input == null || input.isEmpty) { //입력값이 있을 때 까지 반복
      print("입력값이 비어 있습니다. 다시 입력해주세요."); 
      
      continue;
    }

    for (var student in students) {
      if (student.name == input.trim()) {
        return student;
      }
    }
    
    print("잘못된 학생 이름을 입력하셨습니다. 다시 입력해주세요.");
  }
}

double avgScore(List<StudentScore> students){
  if(students.isEmpty) return 0; //평균 점수가 0점이면 0점 반환

  int total = students.fold(0, (sum, nIndex) =>
    sum + nIndex.score);
    return total/students.length;
}

void saveResult(String filePath, String content) {
  try {
    final file = File(filePath);
    file.writeAsStringSync(content);
    print("저장이 완료되었습니다.");
  } catch (e) {
    print("저장에 실패했습니다: $e");
  }
}

void main() {
  List<StudentScore> students = loadStudentData("../students.txt");
  StudentScore selectedStudent = getStudentFromUser(students);

  selectedStudent.showInfo();
  // double avg = avgScore(students);
  // print("평균점수: $avg");

  String resultText = "이름: ${selectedStudent.name}, 점수: ${selectedStudent.score}";
  saveResult("result.txt", resultText);
}

abstract class User {
  int id;
  String name;
  String gmail;

  User(this.id, this.name, this.gmail);
}

class Student extends User {
  int academicYear;
  Student(super.id, super.name, super.gmail, this.academicYear);

  takeExam() {}
}

class Professor extends User {
  Professor(super.id, super.name, super.gmail);

  addUpdateExam() {}
}

abstract class Question {
  String questionText;
  double score;

  Question(this.questionText, this.score);

  bool checkAnswer(String userAnswer);
}

class MCQQuestion extends Question {
  List<String> options;
  int correctOption;

  MCQQuestion(
    super.questionText,
    super.score,
    this.options,
    this.correctOption,
  );

  @override
  bool checkAnswer(String userAnswer) =>
      options.indexOf(userAnswer) == correctOption;
}

class TrueFalseQuestion extends Question {
  bool correctAnswer;
  TrueFalseQuestion(super.questionText, super.score, this.correctAnswer);

  @override
  bool checkAnswer(String userAnswer) {
    if (userAnswer == "true") {
      return correctAnswer;
    } else {
      return !correctAnswer;
    }
  }
}

abstract class ExamGenerator {
  List generateExam(Student student, int numberOfQuestions);
}

abstract class GradingSystem {
  double calculateFinalScore(
    List<Question> examQuestions,
    List<String> studentAnswers,
  );
}

class OnlineExamManager implements ExamGenerator, GradingSystem {
  List<Question> questionBank = [];

  OnlineExamManager() {
    questionBank.add(
      MCQQuestion("What is the capital of France?", 5.0, [
        "Paris",
        "London",
        "Berlin",
        "Madrid",
      ], 0),
    );
    questionBank.add(
      MCQQuestion("What is the largest planet in our solar system?", 5.0, [
        "Earth",
        "Mars",
        "Jupiter",
        "Saturn",
      ], 2),
    );
    questionBank.add(
      TrueFalseQuestion(
        "The Great Wall of China is visible from space.",
        3.0,
        true,
      ),
    );
  }
  @override
  List<Question> generateExam(Student student, int numberofQuestion) {
    List<Question> questions = [];

    List<Question> mcqQuestions = [];

    List<Question> trueFalseQuestions = [];

    if (student.academicYear == 3) {
      for (Question question in questionBank) {
        if (question is MCQQuestion) {
          mcqQuestions.add(question);
        }
      }
      if (mcqQuestions.length < numberofQuestion) {
        throw Exception("Not enough MCQ questions");
      }
      for (int i = 0; i < numberofQuestion; i++) {
        questions.add(mcqQuestions[i]);
      }
    } else if (student.academicYear == 4) {
      for (Question question in questionBank) {
        if (question is MCQQuestion) {
          mcqQuestions.add(question);
        }
      }
      for (Question question in questionBank) {
        if (question is TrueFalseQuestion) {
          trueFalseQuestions.add(question);
        }
      }
    }
    return questions;
  }

  @override
  double calculateFinalScore(
    List<Question> examQuestions,
    List<String> studentAnswers,
  ) {
    double score = 0;
    for (int i = 0; i < examQuestions.length; i++) {
      if (examQuestions[i].checkAnswer(studentAnswers[i])) {
        score += examQuestions[i].score;
      }
    }
    return score;
  }
}

import 'dart:io';

class Student {
  String firstName;
  String lastName;
  Map<String, int> grades = {};

  Student(this.firstName, this.lastName);

  String fullName() => '$firstName $lastName';

  void addGrade(String subject, int grade) {
    grades[subject] = grade;
  }
}

void main() {
  List<Student> students = [];
  List<String> subjects = ['Математика', 'Физика', 'Информатика', 'История'];

  fillData(students, subjects);

  while (true) {
    print('\nМЕНЮ:');
    print('1. Таблица');
    print('2. Найти студента');
    print('3. Все оценки');
    print('4. Макс и мин');
    print('5. Одна двойка');
    print('6. Лучшие предметы');
    print('7. Категории');
    print('0. Выход');
    stdout.write('Выбери: ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        showTable(students, subjects);
        break;
      case '2':
        findStudent(students, subjects);
        break;
      case '3':
        showAllGrades(students);
        break;
      case '4':
        showMinMax(students, subjects);
        break;
      case '5':
        showOneTwo(students);
        break;
      case '6':
        showBestSubjects(students, subjects);
        break;
      case '7':
        showCategories(students, subjects);
        break;
      case '0':
        print('Пока');
        return;
      default:
        print('Нет такого');
    }
  }
}

void fillData(List<Student> students, List<String> subjects) {
  students.add(Student('Ivan', 'Ivanov'));
  students.add(Student('Petr', 'Petrov'));
  students.add(Student('Maria', 'Sidorova'));
  students.add(Student('Anna', 'Smirnova'));
  students.add(Student('Oleg', 'Orlov'));

  students[0].addGrade('Математика', 5);
  students[0].addGrade('Физика', 4);
  students[0].addGrade('Информатика', 5);
  students[0].addGrade('История', 4);

  students[1].addGrade('Математика', 3);
  students[1].addGrade('Физика', 2);
  students[1].addGrade('Информатика', 3);
  students[1].addGrade('История', 4);

  students[2].addGrade('Математика', 5);
  students[2].addGrade('Физика', 5);
  students[2].addGrade('Информатика', 5);
  students[2].addGrade('История', 5);

  students[3].addGrade('Математика', 4);
  students[3].addGrade('Физика', 4);
  students[3].addGrade('Информатика', 4);
  students[3].addGrade('История', 4);

  students[4].addGrade('Математика', 2);
  students[4].addGrade('Физика', 3);
  students[4].addGrade('Информатика', 3);
  students[4].addGrade('История', 3);
}

void showTable(List<Student> students, List<String> subjects) {
  print('\nСВОДНАЯ ТАБЛИЦА');

  stdout.write('Студент');
  for (var s in subjects) {
    stdout.write('\t$s');
  }
  print('\tСреднее');

  for (var st in students) {
    stdout.write(st.fullName());
    double sum = 0;

    for (var s in subjects) {
      int g = st.grades[s] ?? 0;
      stdout.write('\t$g');
      sum += g;
    }

    double avg = sum / subjects.length;
    print('\t${avg.toStringAsFixed(2)}');
  }

  stdout.write('Среднее по');
  for (var s in subjects) {
    double sum = 0;
    for (var st in students) {
      sum += st.grades[s] ?? 0;
    }
    double avg = sum / students.length;
    stdout.write('\t${avg.toStringAsFixed(2)}');
  }
  print('');
}

void findStudent(List<Student> students, List<String> subjects) {
  print('\nПОИСК');
  stdout.write('Имя или фамилия: ');

  String? name = stdin.readLineSync();

  if (name == null || name.isEmpty) {
    print('Ничего не ввели');
    return;
  }

  // Проходим по всем студентам
  for (var st in students) {
    // Если имя или фамилия совпадают (без учёта регистра)
    if (st.firstName.toLowerCase() == name.toLowerCase() ||
        st.lastName.toLowerCase() == name.toLowerCase()) {
      print('\nСтудент: ${st.fullName()}');
      print('Оценки:');

      double sum = 0;
      for (var s in subjects) {
        int grade = st.grades[s] ?? 0;
        print('  $s: $grade');
        sum += grade;
      }

      double avg = sum / subjects.length;
      print('Средний балл: ${avg.toStringAsFixed(2)}');

      // Категория
      if (avg == 5.0) {
        print('Категория: Отличник');
      } else if (avg >= 4.0) {
        print('Категория: Хорошист');
      } else {
        print('Категория: Остальные');
      }

      return; // Нашли - выходим
    }
  }

  // Если не нашли
  print('Студент "$name" не найден');
}

void showAllGrades(List<Student> students) {
  print('\nВСЕ ОЦЕНКИ');

  Set<int> grades = {};
  for (var st in students) {
    grades.addAll(st.grades.values);
  }

  List<int> sorted = grades.toList();
  sorted.sort();

  print('Оценки: $sorted');
}

void showMinMax(List<Student> students, List<String> subjects) {
  print('\nМИН И МАКС');

  for (var s in subjects) {
    int max = -1;
    int min = 6;
    List<String> maxList = [];
    List<String> minList = [];

    for (var st in students) {
      int g = st.grades[s] ?? 0;

      if (g > max) {
        max = g;
        maxList = [st.fullName()];
      } else if (g == max) {
        maxList.add(st.fullName());
      }

      if (g < min) {
        min = g;
        minList = [st.fullName()];
      } else if (g == min) {
        minList.add(st.fullName());
      }
    }

    print('\n$s:');
    print('  Макс $max (${maxList.join(', ')})');
    print('  Мин $min (${minList.join(', ')})');
  }
}

void showOneTwo(List<Student> students) {
  print('\nОДНА ДВОЙКА');

  bool found = false;
  for (var st in students) {
    int count = 0;
    String? badSubject;

    for (var e in st.grades.entries) {
      if (e.value == 2) {
        count++;
        badSubject = e.key;
      }
    }

    if (count == 1) {
      found = true;
      print('${st.fullName()} — $badSubject');
    }
  }

  if (!found) {
    print('Нет таких');
  }
}

void showBestSubjects(List<Student> students, List<String> subjects) {
  print('\nЛУЧШИЕ ПРЕДМЕТЫ');

  double allSum = 0;
  int allCount = 0;

  for (var st in students) {
    for (var g in st.grades.values) {
      allSum += g;
      allCount++;
    }
  }

  double allAvg = allSum / allCount;
  print('Общий средний: ${allAvg.toStringAsFixed(2)}');

  print('Выше среднего:');
  bool found = false;

  for (var s in subjects) {
    double sum = 0;
    for (var st in students) {
      sum += st.grades[s] ?? 0;
    }
    double avg = sum / students.length;

    if (avg > allAvg) {
      found = true;
      print('  $s: ${avg.toStringAsFixed(2)}');
    }
  }

  if (!found) {
    print('  Нет');
  }
}

void showCategories(List<Student> students, List<String> subjects) {
  print('\nКАТЕГОРИИ');

  int exc = 0;
  int good = 0;
  int other = 0;

  for (var st in students) {
    double sum = 0;
    for (var s in subjects) {
      sum += st.grades[s] ?? 0;
    }
    double avg = sum / subjects.length;

    if (avg == 5.0) {
      exc++;
    } else if (avg >= 4.0) {
      good++;
    } else {
      other++;
    }
  }

  print('Отличники: $exc');
  print('Хорошисты: $good');
  print('Остальные: $other');
}

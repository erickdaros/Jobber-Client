class User {
  final String id;
  final String name;
  final String email;
  final DateTime birthDate;
  final String cellphone;
  final List<String> skills;

  User({this.id, this.name, this.email, this.birthDate, this.cellphone, this.skills});

  factory User.fromJson(Map<String, dynamic> json) {
    String dateTimeString = json['birthDate'];
    int dateTimeYear = int.parse(dateTimeString.split("-")[0]);
    int dateTimeMonth = int.parse(dateTimeString.split("-")[1]);
    int dateTimeDay = int.parse(dateTimeString.split("-")[2]);

    List<String> skills;
    skills = json['skills'].cast<String>();

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      birthDate: new DateTime(dateTimeYear,dateTimeMonth,dateTimeDay),
      cellphone: json['cellphone'],
      skills: skills,
    );
  }
}
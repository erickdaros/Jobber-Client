import 'package:jobber/models/skill_model.dart';

class User {
  final String id;
  final String name;
  final String email;
//  final DateTime birthDate;
  final String cellphone;
  final List<Skill> skills;
  final String description;
  final int rating;
  final int freelancesQuantity;

  User({this.id, this.name, this.email, this.cellphone, this.skills, this.description, this.rating, this.freelancesQuantity});

  factory User.fromJson(Map<String, dynamic> json) {
//    String dateTimeString = json['birthDate'];
//    int dateTimeYear = int.parse(dateTimeString.split("-")[0]);
//    int dateTimeMonth = int.parse(dateTimeString.split("-")[1]);
//    int dateTimeDay = int.parse(dateTimeString.split("-")[2]);

    List<Skill> skills = new List<Skill>();
    List<dynamic> parsedJson = json['skills'];
    for(int i=0; i<parsedJson.length; i++){
      skills.add(
          Skill.fromJson(parsedJson[i])
      );
    }

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
//      birthDate: new DateTime(dateTimeYear,dateTimeMonth,dateTimeDay),
      cellphone: json['cellphone'],
      skills: skills,
      description: json['description'],
      rating: json['rating'],
      freelancesQuantity: json['freelances_quantity'],
    );
  }
}
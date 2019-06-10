class Skill{

  final String id;
  final String name;

  Skill({this.id, this.name,});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'id': id,
    'name': name,
  };
}

class SkillList {
  final List<Skill> skills;

  SkillList({
    this.skills,
  });

  factory SkillList.fromJson(List<dynamic> parsedJson) {

    List<Skill> skills = new List<Skill>();

    return new SkillList(
      skills: skills,
    );
  }

}
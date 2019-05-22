class Proposal{
  String title;
  String description;
  String authorName;
  List<String> skills;

  Proposal(
      String title,
      String description,
      String authorName,
      List<String> skills,
      ){
    this.title = title;
    this.description = description;
    this.authorName = authorName;
    this.skills = skills;
  }
}
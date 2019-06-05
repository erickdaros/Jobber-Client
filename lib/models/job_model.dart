class Job{
  String title;
  String description;
  String maxDate;
  String authorName;
  List<String> skills;

  Job(
      String title,
      String description,
      String maxDate,
      List<String> skills,
      ){
    this.title = title;
    this.description = description;
    this.maxDate = maxDate;
    this.skills = skills;
  }

  @override
  String toString(){
    return "Title: "+title+"\nDescription: "+description+"\nMaxDate: "+maxDate+"\nSkills: "+skills.toString();
  }
}
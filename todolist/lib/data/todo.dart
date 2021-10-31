class Todo {
  String title;
  String memo;
  String category;
  int color;
  int done;
  int date;
  int? id;

  Todo(
      {this.id,
      this.title = "",
      this.memo = "",
      this.category = "",
      this.color = 1,
      this.done = 0,
      this.date = 00000000});
}

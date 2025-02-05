class Task {
   String id;
   String title;
   String? description;
   DateTime due;
   bool isDone;

  Task({ required this.id,required this.title,this.description, required this.due, required this.isDone,});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
      id: json['_id'],
      title: json['title'],
      description: json['description']??"",
      due: DateTime.parse(json['due']),
      isDone: json['isDone'],
    );
}
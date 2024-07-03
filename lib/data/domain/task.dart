class Task{
  int? id;
  String name;
  String desc;
  int isCompleted=0;

  Task({required this.id, required this.name, required this.desc, required this.isCompleted});

  Task.withoutId(this.name,this.desc);
  Task.updateTask(this.id,this.name,this.desc);


  factory Task.fromJson(Map<String,dynamic> json) => Task(
    id: json['id'] as int,
    name: json['name'],
    desc: json['desc'],
    isCompleted: json['isCompleted']
  );

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> json=<String,dynamic>{};
   json['id']=id;
   json['name']=name;
   json['desc']=desc;
   json['isCompleted']= isCompleted;

   return json;
  }

  Map<String,dynamic> toJsonUpdate(){
    final Map<String,dynamic> json=<String,dynamic>{};
    json['name']=name;
    json['desc']=desc;
    json['isCompleted']= isCompleted;

    return json;
  }

  Map<String,dynamic> toJsonUpdateIsCompleted(){
    final Map<String,dynamic> json=<String,dynamic>{};
    json['isCompleted']= isCompleted;
    return json;
  }


  @override
  String toString() {
    return 'Task{id: $id, name: $name, desc: $desc, isCompleted: $isCompleted}';
  }
}
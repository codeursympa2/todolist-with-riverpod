class Task{
  int? id;
  String name;
  String desc;
  bool isCompleted=false;

  Task({required this.id, required this.name, required this.desc, required isCompleted});

  Task.withoutId(this.name,this.desc);
  Task.updateTask(this.name,this.desc,this.isCompleted);


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
   json['isCompleted']= this._getValue(isCompleted);

   return json;
  }

  Map<String,dynamic> toJsonUpdate(){
    final Map<String,dynamic> json=<String,dynamic>{};
    json['name']=name;
    json['desc']=desc;
    json['isCompleted']= this._getValue(isCompleted);

    return json;
  }

  int _getValue(bool value){
    //1:True 0:False
    return value ? 1 : 0;
  }

}
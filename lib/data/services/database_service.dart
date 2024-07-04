import 'package:sqflite/sqflite.dart';
import 'package:todolist_with_riverpod/data/domain/task.dart';

class DatabaseService{

    Database? _db;

    String _tableName="tasks";

    DatabaseService._defaultConstructor();

    //Pour acceder à mon service
    static final DatabaseService instance = DatabaseService._defaultConstructor();


    Future<Database> get db async{
      if (_db != null) return _db!;
      this._db=await _database();
      return this._db!;
    }


    Future<void> _createTables(Database database) async{
    await database.execute(
        """
        CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        desc TEXT,
        isCompleted INTEGER
        )
        """
    );
    }

    Future<Database> _database() async{
      return openDatabase(
          "todos.db", //nom db
          version: 1,
          onCreate: (Database database,int version) async{
              //on ajoute les tables
              await _createTables(database);
          }
      );
    }

    //Pour ajouter une task
    Future<int> addTask(Task task) async{
      final db=await instance.db;

      //Insertion
      final id=await db.insert(this._tableName, task.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);

      return id;
    }

    // La liste des taches
    Future<List<Task>> getAllTasks() async {
      final db = await instance.db;

      final maps = await db.query(_tableName, orderBy: "id DESC");
      return List.generate(maps.length, (i) {
        return Task.fromJson(maps[i]);
      });
    }

    // Récupération d'une tâche spécifique
    Future<Task?> getTask(int id) async {
      final db = await instance.db;

      final maps = await db.query(
        _tableName,
        where: "id=?",
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Task.fromJson(maps.first);
      } else {
        return null;
      }
    }


    //Mise à jour d'une tâche
    Future<int> updateTask( int id,Map<String, Object?> values) async{
      final db = await instance.db;
      final result=await db.update(
          _tableName,
          values,
          where: 'id=?',
          whereArgs: [id]
      );
      return result;
    }

    //Suppression d'une tâche
    Future<int> deleteTask(Task task) async{
      final db = await instance.db;

      final result=await db.delete(_tableName,where: "id=?",whereArgs: [task.id]);

      return result;
    }


    Future<int>getTotalTasks() async{
      final db = await instance.db;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');

      // Extraire le nombre total à partir du résultat de la requête
      int totalCount = Sqflite.firstIntValue(result) ?? 0;

      return totalCount;
    }
    
    //Fermeturee de la connexion
    Future<void> closeConnexion() async{
      final db = await instance.db;
       db.close();
    }

}
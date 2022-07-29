import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/models/task_model.dart';

class DBHelper {
  static const String databaseName = 'todo.db';
  static const String tasksTableName = 'tasks_todo';
  static const String categoriesTableName = 'categories_todo';
  static const String sharedPrefsTableName = 'sharedpref_todo';

  static Future createDatabase() async {
    final databasePath = await getDatabasesPath();
    var database = openDatabase(
      path.join(databasePath, databaseName),
      onCreate: (db, version) {
        //ToDo: note =>
        //what inside onCreate methode called only once, so you can insert initial records as you need !
        final createdTable = _crateTables(db);
        _insertDefaultCategories(db);
        _insertNotificationId(db);
        return createdTable;
      },
      version: 1,
    );

    print('open "creation" finished successfully');
    return database;
  }

  static _crateTables(Database db) {
    // Run the CREATE TABLE statement on the database.
    db.execute(
      'CREATE TABLE $tasksTableName (id TEXT, notificationId TEXT, title TEXT, details TEXT, category TEXT, isDone TEXT, time TEXT, date TEXT)',
    );
    db.execute(
      'CREATE TABLE $categoriesTableName (id TEXT, categoryName TEXT)',
    );
    db.execute(
      'CREATE TABLE $sharedPrefsTableName (key TEXT, value TEXT)',
    );
  }

  static _insertDefaultCategories(Database db) {
    List defaultCategories = CategoryModel.getDefaultCategories();
    defaultCategories.forEach((category) {
      db.insert(categoriesTableName, category.toMap());
    });
  }

  static _insertNotificationId(Database db) {
    db.insert(
      sharedPrefsTableName,
      {'key': 'notificationId', 'value': '1'},
    );
  }

  static Future<void> insertValue(table, data) async {
    final Database db = await DBHelper.createDatabase();
    await db.insert(
      table,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('insertion finished successfully');
  }

  //you must provide the complete data model with id to search with it
  static Future<void> updateValue(table, newData) async {
    final Database db = await DBHelper.createDatabase();
    await db.update(
      table,
      newData.toMap(),
      where: 'id = ?',
      whereArgs: ['${newData.id}'],
    );
    print('updating finished successfully');
  }

  static Future<void> deleteValueById(table, String id) async {
    final Database db = await DBHelper.createDatabase();
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: ['$id'],
    );
    print('deleting finished successfully');
  }

  static Future<void> deleteCategoryTasks(table, String categoryName) async {
    final Database db = await DBHelper.createDatabase();
    await db.delete(
      table,
      where: 'category = ?',
      whereArgs: ['$categoryName'],
    );
    print('deleting category tasks finished successfully');
  }

  //return List of TaskModel 'completed and not completed'
  static Future<List<TaskModel>> getAllTasks() async {
    final Database db = await DBHelper.createDatabase();

    final List<Map<String, dynamic>> maps = await db.query(tasksTableName);

    return List.generate(
      maps.length,
      (i) => TaskModel.fromMap(maps[i]),
    );
  }

  //return List of TaskModel 'Not completed tasks only'
  static Future<List<TaskModel>> getTasks() async {
    final Database db = await DBHelper.createDatabase();

    //final List<Map<String, dynamic>> maps = await db.query(tasksTableName);

    final List<Map<String, dynamic>> maps = await db.query(
      tasksTableName,
      columns: [
        'id',
        'notificationId',
        'title',
        'details',
        'category',
        'isDone',
        'time',
        'date',
      ],
      where: 'isDone = ?',
      whereArgs: ['false'],
    );
    /* or ......it also works !
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM $tasksTableName WHERE isDone = "false" ');
   */
    return List.generate(
      maps.length,
      (i) => TaskModel.fromMap(maps[i]),
    );
  }

  //return List of TaskModel 'completed tasks only'
  static Future<List<TaskModel>> getCompletedTasks() async {
    final Database db = await DBHelper.createDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      tasksTableName,
      columns: [
        'id',
        'notificationId',
        'title',
        'details',
        'category',
        'isDone',
        'time',
        'date',
      ],
      where: 'isDone = ?',
      whereArgs: ['true'],
    );

    return List.generate(
      maps.length,
      (i) => TaskModel.fromMap(maps[i]),
    );
  }

  //return List of TaskModel 'Not completed tasks only'
  static Future<List<TaskModel>> getCategoryTasks(String categoryName) async {
    final Database db = await DBHelper.createDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      tasksTableName,
      columns: [
        'id',
        'notificationId',
        'title',
        'details',
        'category',
        'isDone',
        'time',
        'date',
      ],
      where: 'category = ? and isDone = ?',
      whereArgs: ['$categoryName', 'false'],
    );

    return List.generate(
      maps.length,
      (i) => TaskModel.fromMap(maps[i]),
    );
  }

  //return List of CategoryModel
  static Future<List<CategoryModel>> getCategories() async {
    final Database db = await DBHelper.createDatabase();

    final List<Map<String, dynamic>> maps = await db.query(categoriesTableName);

    return List.generate(
      maps.length,
      (i) => CategoryModel.fromMap(maps[i]),
    );
  }

//--------------------* Shared preferences *---------------------------------------------

  // we have a table called sharedpref_todo with two columns called key & value
  // but we also will use shared preferences plugin

  static Future<void> insertSharedValue(
      String sharedKey, String sharedValue) async {
    final Database db = await DBHelper.createDatabase();

    await db.insert(
      DBHelper.sharedPrefsTableName,
      {
        'key': sharedKey,
        'value': sharedValue,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateSharedValue(
      String sharedKey, String sharedValue) async {
    final Database db = await DBHelper.createDatabase();

    await db.update(
      DBHelper.sharedPrefsTableName,
      {
        'key': sharedKey,
        'value': sharedValue,
      },
    );
  }

  static Future<String> getSharedValue(String sharedKey) async {
    final Database db = await DBHelper.createDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      DBHelper.sharedPrefsTableName,
      columns: ['value'],
      where: 'key = ?',
      whereArgs: ['$sharedKey'],
    );
    //print('*******${maps[0]['value']}');

    return maps[0]['value'];

    /* or.....it also works !!!

    final List<Map<String, dynamic>> maps = await db.query(DBHelper.sharedPrefsTableName);

    return List.generate(
      maps.length,
      (i) => SharedPrefModel.fromMap(maps[i]),
    )[0]
        .value; */
  }

  //we can use shared preferences also to handle generation of integer id
  // but we have already used database for such thing, so we will not delete
  // that code and convert it to shared preferences !
  static Future<int> getNotificationId() async {
    //get the current id
    final String notificationId =
        await DBHelper.getSharedValue('notificationId');
    //convert id to int
    int intId = int.parse(notificationId);
    //add one to its value
    final int newIntId = intId + 1;
    //update its value in the database
    await DBHelper.updateSharedValue('notificationId', '$newIntId');
    return newIntId;
    //
  }
}

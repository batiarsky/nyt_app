import 'package:nyt_app/model/post_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider _db = DBProvider._();

  factory DBProvider() => _db;
  Database _database;

  static const String _postTable = 'Posts';
  static const String _columnTitle = 'title';
  static const String _columnUrl = 'url';

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'Posts.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(final Database db, final int version) async {
    await db.execute(
        'CREATE TABLE $_postTable($_columnTitle TEXT PRIMARY KEY, $_columnUrl TEXT)');
  }

  Future<List<PostEntity>> getPosts() async {
    final Database db = await this.database;
    final List<Map<String, dynamic>> postsMapList = await db.query(_postTable);
    final postsList =
        postsMapList.map((postMap) => PostEntity.fromMap(postMap)).toList();
    return postsList;
  }

  Future<int> clearPosts() async {
    final Database db = await this.database;
    try {
      return await db.delete(_postTable);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> insertPosts(final List<PostEntity> posts) async {
    final Database db = await this.database;
    final batch = db.batch();
    posts.forEach((element) {
      batch.insert(_postTable, element.toMap());
    });
    try {
      return await batch.commit();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

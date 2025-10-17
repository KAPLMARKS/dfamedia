import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dfamedia/features/home/domain/models/banner.dart';
import 'package:dfamedia/features/home/domain/models/good.dart';
import 'package:dfamedia/features/home/domain/models/story.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dfamedia.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Таблица для историй
    await db.execute('''
      CREATE TABLE stories(
        id TEXT PRIMARY KEY,
        preview_image TEXT,
        viewed INTEGER,
        title TEXT,
        cached_at INTEGER
      )
    ''');

    // Таблица для баннеров
    await db.execute('''
      CREATE TABLE banners(
        id TEXT PRIMARY KEY,
        image TEXT,
        cached_at INTEGER
      )
    ''');

    // Таблица для товаров
    await db.execute('''
      CREATE TABLE goods(
        id TEXT PRIMARY KEY,
        title TEXT,
        image TEXT,
        price REAL,
        unit_text TEXT,
        cached_at INTEGER
      )
    ''');

    // Таблица для синхронизации
    await db.execute('''
      CREATE TABLE sync_status(
        table_name TEXT PRIMARY KEY,
        last_sync INTEGER,
        is_synced INTEGER
      )
    ''');
  }

  // Методы для работы с историями
  Future<void> cacheStories(List<StoryData> stories) async {
    final db = await database;
    final batch = db.batch();
    
    for (final story in stories) {
      batch.insert(
        'stories',
        {
          'id': story.id,
          'preview_image': story.previewImage,
          'viewed': story.viewed ? 1 : 0,
          'title': story.title,
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
    await updateSyncStatus('stories', true);
  }

  Future<List<StoryData>> getCachedStories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('stories');
    
    return maps.map((map) => StoryData.fromJson({
      'id': map['id'],
      'preview_image': map['preview_image'],
      'viewed': map['viewed'] == 1,
      'title': map['title'],
    })).toList();
  }

  // Методы для работы с баннерами
  Future<void> cacheBanners(List<BannerData> banners) async {
    final db = await database;
    final batch = db.batch();
    
    for (final banner in banners) {
      batch.insert(
        'banners',
        {
          'id': banner.id,
          'image': banner.image,
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
    await updateSyncStatus('banners', true);
  }

  Future<List<BannerData>> getCachedBanners() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('banners');
    
    return maps.map((map) => BannerData.fromJson({
      'id': map['id'],
      'image': map['image'],
    })).toList();
  }

  // Методы для работы с товарами
  Future<void> cacheGoods(List<GoodData> goods) async {
    final db = await database;
    final batch = db.batch();
    
    for (final good in goods) {
      batch.insert(
        'goods',
        {
          'id': good.id,
          'title': good.title,
          'image': good.image,
          'price': good.price,
          'unit_text': good.unitText,
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
    await updateSyncStatus('goods', true);
  }

  Future<List<GoodData>> getCachedGoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('goods');
    
    return maps.map((map) => GoodData.fromJson({
      'id': map['id'],
      'title': map['title'],
      'image': map['image'],
      'price': map['price'],
      'unit_text': map['unit_text'],
    })).toList();
  }

  // Методы для управления синхронизацией
  Future<void> updateSyncStatus(String tableName, bool isSynced) async {
    final db = await database;
    await db.insert(
      'sync_status',
      {
        'table_name': tableName,
        'last_sync': DateTime.now().millisecondsSinceEpoch,
        'is_synced': isSynced ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isDataCached(String tableName) async {
    final db = await database;
    final result = await db.query(
      'sync_status',
      where: 'table_name = ?',
      whereArgs: [tableName],
    );
    
    if (result.isEmpty) return false;
    return result.first['is_synced'] == 1;
  }

  Future<DateTime?> getLastSyncTime(String tableName) async {
    final db = await database;
    final result = await db.query(
      'sync_status',
      where: 'table_name = ?',
      whereArgs: [tableName],
    );
    
    if (result.isEmpty) return null;
    final timestamp = result.first['last_sync'] as int?;
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  // Проверка актуальности кэша (например, данные старше 1 часа считаются устаревшими)
  Future<bool> isCacheValid(String tableName, {Duration maxAge = const Duration(hours: 1)}) async {
    final lastSync = await getLastSyncTime(tableName);
    if (lastSync == null) return false;
    
    return DateTime.now().difference(lastSync) < maxAge;
  }

  // Очистка кэша
  Future<void> clearCache() async {
    final db = await database;
    await db.delete('stories');
    await db.delete('banners');
    await db.delete('goods');
    await db.delete('sync_status');
  }

  // Очистка конкретной таблицы
  Future<void> clearTable(String tableName) async {
    final db = await database;
    await db.delete(tableName);
    await updateSyncStatus(tableName, false);
  }

  // Получение размера кэша
  Future<Map<String, int>> getCacheSize() async {
    final db = await database;
    
    final storiesCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM stories')) ?? 0;
    final bannersCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM banners')) ?? 0;
    final goodsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM goods')) ?? 0;
    
    return {
      'stories': storiesCount,
      'banners': bannersCount,
      'goods': goodsCount,
    };
  }

  // Закрытие базы данных
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

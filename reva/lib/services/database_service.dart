// lib/services/database_service.dart
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  static final String uri = "mongodb+srv://bossutkarsh30:YOCczedaElKny6Dd@cluster0.gixba.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
  static final String dbName = "alzheimers_db";
  static final String userCollection = "patient";
  
  static Db? _db;
  
  // Initialize database connection
  static Future<Db> get database async {
    if (_db != null) return _db!;
    
    try {
      _db = await Db.create(uri);
      await _db!.open();
      print("Connected to MongoDB!");
      return _db!;
    } catch (e) {
      print("Error connecting to MongoDB: $e");
      throw e;
    }
  }
  
  // Save user to MongoDB
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      final db = await database;
      final collection = db.collection(userCollection);
      
      // Check if user already exists
      final existingUser = await collection.findOne({"userId": userData["userId"]});
      
      if (existingUser != null) {
        // Update existing user
        await collection.update(
          where.eq("userId", userData["userId"]),
          userData
        );
      } else {
        // Insert new user
        await collection.insert(userData);
      }
      
      print("User saved to MongoDB successfully");
    } catch (e) {
      print("Error saving user to MongoDB: $e");
      throw e;
    }
  }
  
  // Get user from MongoDB
  static Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final db = await database;
      final collection = db.collection(userCollection);
      
      final user = await collection.findOne({"userId": userId});
      return user;
    } catch (e) {
      print("Error getting user from MongoDB: $e");
      throw e;
    }
  }
  
  // Close database connection
  static Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
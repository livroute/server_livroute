import 'package:onenizam/headers.dart';

import '../setup/mongo_config.dart';

class MongoDbFunc {
  static Db? _db;
  static DbCollection? chat;
  static DbCollection? profile;
  static DbCollection? comments;
  static DbCollection? credential;
  static DbCollection? following;
  static DbCollection? likes;
  static DbCollection? message;
  static DbCollection? service;
  static DbCollection? post;
  static DbCollection? user;

  static bool isConnected = false;
  static _unLoadDb() {
    isConnected = false;
    chat = null;
    chat = profile;
    comments = null;
    credential = null;
    following = null;
    likes = null;
    message = null;
    service = null;
    post = null;
    user = null;
  }

  static _loadDb() {
    credential = _db!.collection(MongoConfig.credentialColl);
    likes = _db!.collection(MongoConfig.likeColl);
    message = _db!.collection(MongoConfig.messageColl);

    isConnected = true;
  }

  static Future<void> connectToMongoDB() async {
    while (true) {
      try {
        // Connect to MongoDB
        _db = await Db.create(MongoConfig.connUrl);
        await _db!.open();

        _loadDb();

        print('Connected to MongoDB: ${MongoConfig.connUrl}');

        // Monitor connection status
        monitorConnection();
        break; // If the connection is closed, exit the loop
      } catch (e) {
        _unLoadDb();
        print('Failed to connect to MongoDB: ${MongoConfig.connUrl}');
        print('Error: $e');
        await Future.delayed(
            Duration(seconds: 5)); // Wait for 5 seconds before retrying
      }
    }
  }

  static Future<void> monitorConnection() async {
    while (true) {
      await Future.delayed(
          Duration(minutes: 1)); // Check connection status every minute

      try {
        // Ping the server to check the connection status
        await _db!.collection('connection').find().toList();

        // If the connection is still active, continue monitoring
        continue;
      } catch (_) {
        _unLoadDb();
        print('Lost connection to MongoDB. Reconnecting...');
        print('The Error was $_');
        _db!.close(); // Close the existing connection

        // Attempt reconnection
        await connectToMongoDB();
        return; // Exit the monitoring loop and resume normal operations
      }
    }
  }
}

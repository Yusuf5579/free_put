import 'package:appwrite/appwrite.dart';
class AppwriteClient {
  static final appwriteEndpoint = 'https://fra.cloud.appwrite.io/v1';
  static final appwriteProjectId = 'test-ai-app';
  static final bucketId = "6aad546c003cc7b9a3b2";
  static final appwriteProjectName = 'Test AI App';
  static late final Client appwriteClient;
  static late final Storage storage;

  static void init() async {
    appwriteClient = Client()
      ..setEndpoint(appwriteEndpoint)
      ..setProject(appwriteProjectId);
    storage = Storage(appwriteClient);
  }

  static Future<void> testConnection() async {
    try {
      final response = await appwriteClient.ping();
      print("Appwrite Connected Successfully: $response");
    } catch (e) {
      print("Connection Failed: $e");
    }
  }
}

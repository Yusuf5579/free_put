import 'package:appwrite/appwrite.dart';
class AppwriteClient {
  static final appwriteEndpoint = 'https://fra.cloud.appwrite.io/v1';
  static final appwriteProjectId = '6aa8029d0024bc57095d';
  static final bucketId = "6aa80afa002224d2e334";
  static final appwriteProjectName = 'storage app';
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

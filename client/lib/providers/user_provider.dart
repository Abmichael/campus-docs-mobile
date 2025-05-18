import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/user_service.dart';

final userServiceProvider = Provider((ref) => UserService());

final usersProvider = FutureProvider<List<User>>((ref) async {
  final service = ref.watch(userServiceProvider);
  return service.getUsers();
});

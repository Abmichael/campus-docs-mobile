import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/request.dart';
import '../services/request_service.dart';

final requestServiceProvider = Provider((ref) => RequestService());

final requestsProvider = FutureProvider<List<Request>>((ref) async {
  final requestService = ref.watch(requestServiceProvider);
  return requestService.getRequests();
});

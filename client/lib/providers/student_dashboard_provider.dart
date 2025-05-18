import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/request.dart';
import '../services/request_service.dart';

final recentRequestsProvider = FutureProvider<List<Request>>((ref) async {
  final requestService = ref.watch(Provider((ref) => RequestService()));
  final requests = await requestService.getRequests();
  
  // Sort by createdAt date and take the most recent ones
  requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  
  // Return at most 5 most recent requests
  return requests.take(5).toList();
});

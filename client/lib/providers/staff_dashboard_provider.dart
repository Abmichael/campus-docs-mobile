import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/request.dart';
import '../services/request_service.dart';

final pendingRequestsProvider = FutureProvider<List<Request>>((ref) async {
  final requestService = ref.watch(Provider((ref) => RequestService()));
  final requests = await requestService.getRequests();
  
  // Filter only pending requests and sort by createdAt date (newest first)
  final pendingRequests = requests
      .where((request) => request.status == RequestStatus.pending)
      .toList();
  
  pendingRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  
  return pendingRequests;
});

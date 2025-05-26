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

// State class for managing approved requests with pagination
class ApprovedRequestsState {
  final List<Request> requests;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;

  ApprovedRequestsState({
    this.requests = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  ApprovedRequestsState copyWith({
    List<Request>? requests,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return ApprovedRequestsState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error ?? this.error,
    );
  }
}

// StateNotifier for managing approved requests
class ApprovedRequestsNotifier extends StateNotifier<ApprovedRequestsState> {
  final RequestService _requestService;

  ApprovedRequestsNotifier(this._requestService) : super(ApprovedRequestsState()) {
    loadApprovedRequests();
  }

  Future<void> loadApprovedRequests({bool isRefresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final page = isRefresh ? 1 : state.currentPage;
      
      // Get both approved and rejected requests
      final approvedResponse = await _requestService.getRequestsPaginated(
        page: page,
        limit: 10,
        status: 'approved',
      );
      
      final rejectedResponse = await _requestService.getRequestsPaginated(
        page: page,
        limit: 10,
        status: 'rejected',
      );

      // Combine and sort all requests by updated date
      final allRequests = [
        ...approvedResponse.requests,
        ...rejectedResponse.requests,
      ];
      
      allRequests.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      if (isRefresh) {
        state = state.copyWith(
          requests: allRequests,
          currentPage: 2,
          hasMore: approvedResponse.pagination.hasMore || rejectedResponse.pagination.hasMore,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          requests: [...state.requests, ...allRequests],
          currentPage: state.currentPage + 1,
          hasMore: approvedResponse.pagination.hasMore || rejectedResponse.pagination.hasMore,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadApprovedRequests(isRefresh: true);
  }

  void loadMore() {
    if (state.hasMore && !state.isLoading) {
      loadApprovedRequests();
    }
  }
}

final approvedRequestsProvider = StateNotifierProvider<ApprovedRequestsNotifier, ApprovedRequestsState>((ref) {
  final requestService = ref.watch(Provider((ref) => RequestService()));
  return ApprovedRequestsNotifier(requestService);
});

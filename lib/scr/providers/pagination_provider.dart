

// Pagination controller provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paginationControllerProvider = StateNotifierProvider<PaginationController, PaginationState>((ref) {
  return PaginationController();
});

// Pagination state
class PaginationState {
  final int currentPage;
  final int itemsPerPage;
  final int totalPages;

  PaginationState({
    required this.currentPage,
    required this.itemsPerPage,
    this.totalPages = 1,
  });

  PaginationState copyWith({
    int? currentPage,
    int? itemsPerPage,
    int? totalPages,
  }) {
    return PaginationState(
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

// Pagination controller
class PaginationController extends StateNotifier<PaginationState> {
  PaginationController()
      : super(PaginationState(
          currentPage: 1,
          itemsPerPage: 20,
        ));

  void setTotalItems(int totalItems) {
    final totalPages = (totalItems / state.itemsPerPage).ceil();
    state = state.copyWith(totalPages: totalPages);
  }

  void goToPage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      state = state.copyWith(currentPage: page);
    }
  }

  void nextPage() {
    if (state.currentPage < state.totalPages) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 1) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void setItemsPerPage(int count) {
    state = state.copyWith(itemsPerPage: count, currentPage: 1);
  }
}
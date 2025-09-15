import 'dart:math' as Math;

import 'package:admin_panel/model/rating/rating_model.dart';
import 'package:admin_panel/network_connection/apis.dart';
import 'package:admin_panel/provider/rate_provider/rate_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int _currentPage = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      RateProvider rateProvider =
          Provider.of<RateProvider>(context, listen: false);
      rateProvider.getAllRatings(page: _currentPage, limit: _pageSize);
    });
  }

  void _loadPage(int page) {
    setState(() {
      _currentPage = page;
    });
    Provider.of<RateProvider>(context, listen: false)
        .getAllRatings(page: page, limit: _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Ratings'),
        leading: Container(),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Consumer<RateProvider>(
        builder: (context, rateProvider, child) {
          if (rateProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (rateProvider.ratingList.isEmpty) {
            return const Center(child: Text('No ratings available'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rateProvider.ratingList.length,
                  itemBuilder: (context, index) {
                    final rating = rateProvider.ratingList[index];
                    return RatingCard(rating: rating);
                  },
                ),
              ),
              if (rateProvider.paginationData != null)
                PaginationControls(
                  currentPage: _currentPage,
                  totalPages: rateProvider.paginationData!.totalPages,
                  onPageChanged: _loadPage,
                ),
            ],
          );
        },
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final RatingModel rating;

  const RatingCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    // Format date
    final dateFormat = DateFormat('MMM dd, yyyy');
    final date = DateTime.parse(rating.createdAt);
    final formattedDate = dateFormat.format(date);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: rating.user.profileImage != null
                      ? NetworkImage("${Apis.BASE_URL_IMAGE}${rating.user.profileImage}")
                      : null,
                  child: rating.user.profileImage == null
                      ? Text(
                          rating.user.fName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 20),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rating.user.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        rating.user.email,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      rating.rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    _buildRatingStars(rating.rating),
                  ],
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        Icon icon;
        if (index < rating.floor()) {
          icon = const Icon(Icons.star, color: Colors.amber, size: 18);
        } else if (index < rating) {
          icon = const Icon(Icons.star_half, color: Colors.amber, size: 18);
        } else {
          icon = Icon(Icons.star_border, color: Colors.grey.shade400, size: 18);
        }
        return icon;
      }),
    );
  }
}

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous page',
          ),
          const SizedBox(width: 8),
          _buildPageButtons(),
          const SizedBox(width: 8),
          IconButton(
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next page',
          ),
        ],
      ),
    );
  }

  Widget _buildPageButtons() {
    const maxVisibleButtons = 5;

    if (totalPages <= maxVisibleButtons) {
      // Show all page buttons
      return Row(
        children: List.generate(
          totalPages,
          (index) => _buildPageButton(index + 1),
        ),
      );
    }

    // Calculate start and end page numbers to display
    int startPage = currentPage - 2;
    int endPage = currentPage + 2;

    // Adjust start and end if they're out of bounds
    if (startPage < 1) {
      startPage = 1;
      endPage = Math.min(startPage + maxVisibleButtons - 1, totalPages);
    }

    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = Math.max(endPage - maxVisibleButtons + 1, 1);
    }

    List<Widget> pageButtons = [];

    // First page
    if (startPage > 1) {
      pageButtons.add(_buildPageButton(1));
      if (startPage > 2) {
        pageButtons.add(const Text('...', style: TextStyle(fontSize: 16)));
      }
    }

    // Page range
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_buildPageButton(i));
    }

    // Last page
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageButtons.add(const Text('...', style: TextStyle(fontSize: 16)));
      }
      pageButtons.add(_buildPageButton(totalPages));
    }

    return Row(children: pageButtons);
  }

  Widget _buildPageButton(int page) {
    final isCurrentPage = page == currentPage;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        color: isCurrentPage ? Colors.blue : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: isCurrentPage ? null : () => onPageChanged(page),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: Text(
              page.toString(),
              style: TextStyle(
                fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                color: isCurrentPage ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

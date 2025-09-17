import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/main.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:abstrak/widgets/animation_card.dart';
import 'package:abstrak/widgets/artwork_detail_dialog.dart';
import 'package:abstrak/widgets/custom_staggered_grid.dart';
import 'package:abstrak/helper/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ArtWerk extends StatefulWidget {
  const ArtWerk({super.key});

  @override
  State<ArtWerk> createState() => _ArtWerkState();
}

class _ArtWerkState extends State<ArtWerk> {
  final ArtwerkNotifier _artWerk = ArtwerkNotifier();
  int _currentPage = 1;

  @override
  void initState() {
    _artWerk.getArtwerk(status: 1, page: _currentPage);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadPage(int page) async {
    setState(() {
      _currentPage = page;
    });
    await _artWerk.getArtwerk(status: 1, page: page);
  }

  Widget _buildPaginationControls(Data paginationData) {
    final currentPage = paginationData.currentPage ?? 1;
    final lastPage = paginationData.lastPage ?? 1;
    final total = paginationData.total ?? 0;
    final perPage = paginationData.perPage ?? 10;
    final isFirst = paginationData.isFirst ?? true;
    final isLast = paginationData.isLast ?? true;
    final hasMore = paginationData.hasMore ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Page info with more details
          Text(
            'Showing ${((currentPage - 1) * perPage) + 1}-${(currentPage * perPage > total) ? total : currentPage * perPage} of $total items (Page $currentPage of $lastPage)',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          if (!hasMore && isLast)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'You\'ve reached the end',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 16),
          
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First page - use isFirst property
              IconButton(
                onPressed: !isFirst ? () => _loadPage(1) : null,
                icon: Icon(
                  Icons.first_page,
                  color: !isFirst ? Colors.white : Colors.grey,
                ),
                tooltip: 'First page',
              ),
              
              // Previous page - use isFirst property
              IconButton(
                onPressed: !isFirst ? () => _loadPage(currentPage - 1) : null,
                icon: Icon(
                  Icons.chevron_left,
                  color: !isFirst ? Colors.white : Colors.grey,
                ),
                tooltip: 'Previous page',
              ),
              
              const SizedBox(width: 16),
              
              // Page numbers (show current page and surrounding pages)
              ...List.generate(
                (lastPage > 5) ? 5 : lastPage,
                (index) {
                  int pageNumber;
                  if (lastPage <= 5) {
                    pageNumber = index + 1;
                  } else {
                    // Show current page and 2 pages before and after
                    int start = (currentPage - 2).clamp(1, lastPage - 4);
                    pageNumber = start + index;
                  }
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: TextButton(
                      onPressed: pageNumber == currentPage ? null : () => _loadPage(pageNumber),
                      style: TextButton.styleFrom(
                        backgroundColor: pageNumber == currentPage 
                            ? Theme.of(context).primaryColor 
                            : Colors.transparent,
                        foregroundColor: pageNumber == currentPage 
                            ? Colors.white 
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('$pageNumber'),
                    ),
                  );
                },
              ),
              
              const SizedBox(width: 16),
              
              // Next page - use hasMore property for additional validation
              IconButton(
                onPressed: (!isLast && hasMore) ? () => _loadPage(currentPage + 1) : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: (!isLast && hasMore) ? Colors.white : Colors.grey,
                ),
                tooltip: hasMore ? 'Next page' : 'No more pages',
              ),
              
              // Last page - use hasMore property for additional validation
              IconButton(
                onPressed: (!isLast && hasMore) ? () => _loadPage(lastPage) : null,
                icon: Icon(
                  Icons.last_page,
                  color: (!isLast && hasMore) ? Colors.white : Colors.grey,
                ),
                tooltip: hasMore ? 'Last page' : 'No more pages',
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .1,
            ),
      child: ValueListenableBuilder(
        valueListenable: _artWerk.data,
        builder: (context, value, child) {
          // Handle loading state for first page
          if (value.status == ApiStatus.loading && _currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (value.status == ApiStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading artwerks',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value.error ?? 'Unknown error occurred',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _loadPage(1),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          var data = value.data?.data?.result ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No artwerks yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'There are no artwerks available. Be the first to upload one!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final paginationData = value.data?.data;
          final isLoadingPagination = value.status == ApiStatus.loading && _currentPage > 1;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Social media style upload container for mobile/tablet
              ValueListenableBuilder(
                valueListenable: authNotifier.auth,
                builder: (context, authValue, child) {
                  if (authValue.status != ApiStatus.success) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: _showUploadDialog,
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Share your artwerk...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.image,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
                
              
              const SizedBox(height: 24),
              
              // Grid Content
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP) ? 8 : 0,
                      right: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP) ? 8 : 0,
                      bottom: 16,
                    ),
                    child: CustomStaggeredGrid(
                      crossAxisCount: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP) ? 2 : 4,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      children: data.map((item) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AnimationCard(
                            imageUrl: item.image ?? '',
                            authorName: item.creatorName ?? '',
                            imageName: item.name ?? '',
                            onTap: () => _showArtwerkDetail(item),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Loading overlay for pagination
                  if (isLoadingPagination)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Pagination Controls
              if (paginationData != null) _buildPaginationControls(paginationData),
            ],
          );
        },
      ),
    );
  }

  void _showArtwerkDetail(Result artwerk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ArtwerkDetailDialog(artwerk: artwerk);
      },
    );
  }

  void _showUploadDialog() {
    DialogHelpers.showUploadDialog(
      context,
      artwerkNotifier: _artWerk,
      onUploadSuccess: () {
        // Refresh the artworks list after successful upload
        _loadPage(1);
      },
    );
  }
}

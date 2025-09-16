import 'package:abstrak/main.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:abstrak/widgets/animation_card.dart';
import 'package:abstrak/widgets/artwork_detail_dialog.dart';
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
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    _artWerk.getArtwerk(status: 1);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      // Use a debounced approach to prevent multiple calls
      if (!_isLoadingMore && !_artWerk.isLoading.value) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadMoreData() async {
    final data = _artWerk.data.value?.data;
    if (data?.hasMore == true && !_isLoadingMore && !_artWerk.isLoading.value) {
      setState(() {
        _isLoadingMore = true;
      });
      
      try {
        _currentPage = data?.currentPage ?? 1;
        
        // Add a small delay to prevent rapid fire requests
        await Future.delayed(const Duration(milliseconds: 100));
        
        await _artWerk.getArtwerk(page: _currentPage + 1, status: 1);
      } catch (e) {
        // Handle error gracefully
        debugPrint('Error loading more data: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? const EdgeInsets.all(0)
            : EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .1,
              ),
        child: ValueListenableBuilder(
          valueListenable: _artWerk.data,
          builder: (context, value, child) {
            var data = value?.data?.result ?? [];

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
                      'No artworks yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'There are no artworks available. Be the first to upload one!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ScrollbarTheme(
              data: const ScrollbarThemeData(
                thumbVisibility: WidgetStatePropertyAll(false),
                trackVisibility: WidgetStatePropertyAll(false),
              ),
              child: ListView.builder(
                controller: _scrollController,
                primary: false,
                padding: EdgeInsets.only(
                  left: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP) ? 8 : 0,
                  right: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP) ? 8 : 0,
                  bottom: 80, // Space for FAB
                ),
                itemCount: (data.length / 2).ceil() + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  // Loading indicator at the end
                  if (index >= (data.length / 2).ceil()) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  // Calculate items for this row
                  final leftIndex = index * 2;
                  final rightIndex = leftIndex + 1;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column item
                        Expanded(
                          child: leftIndex < data.length
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AnimationCard(
                                    imageUrl: data[leftIndex].image ?? '',
                                    authorName: data[leftIndex].creatorName ?? '',
                                    imageName: data[leftIndex].name ?? '',
                                    onTap: () => _showArtwerkDetail(data[leftIndex]),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(width: 8),
                        // Right column item
                        Expanded(
                          child: rightIndex < data.length
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AnimationCard(
                                    imageUrl: data[rightIndex].image ?? '',
                                    authorName: data[rightIndex].creatorName ?? '',
                                    imageName: data[rightIndex].name ?? '',
                                    onTap: () => _showArtwerkDetail(data[rightIndex]),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: authNotifier.auth,
        builder: (context, value, child) {
          if (value == null) {
            return const SizedBox.shrink();
          }
          
          return FloatingActionButton.extended(
            onPressed: _showUploadDialog,
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Upload Artwork'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          );
        },
      ),
      floatingActionButtonLocation: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
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
        _artWerk.getArtwerk(status: 1);
      },
    );
  }
}

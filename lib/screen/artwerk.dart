import 'dart:typed_data';
import 'package:abstrak/main.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:abstrak/widgets/animation_card.dart';
import 'package:abstrak/widgets/artwork_detail_dialog.dart';
import 'package:abstrak/widgets/upload_artwerk_component.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    _artWerk.getArtwerk();
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
        
        await _artWerk.getArtwerk(page: _currentPage + 1);
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

            return ListView.builder(
              controller: _scrollController,
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1a1a1a), // Match your app's background
          insetPadding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? const EdgeInsets.all(16)
              : EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * .2,
                  vertical: 40,
                ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 700),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a), // Dark background
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2a2a2a), // Darker background to match your theme
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upload New Artwork',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Ensure white text
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white70), // Subtle white icon
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),
                // Upload Component
                Flexible(
                  child: SingleChildScrollView(
                    child: UploadArtwerkComponent(
                      onArtwerkUploaded: _handleArtworkUpload,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleArtworkUpload(String title, String description, Uint8List? imageData, String? fileName) async {
    // Close the dialog first
    context.pop();
    
    // Validate required data
    if (imageData == null || fileName == null || title.trim().isEmpty || description.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Please provide all required information'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Uploading artwork...'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 30), // Long duration for upload
      ),
    );
    
    try {
      // Upload the artwork
      final success = await _artWerk.uploadArtwerk(
        name: title.trim(),
        description: description.trim(),
        imageData: imageData,
        fileName: fileName,
      );
      
      // Hide loading snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      if (success) {
        // Show success message with review notice
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Artwork "$title" submitted successfully!'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your artwork is under review and will be published after admin approval.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Failed to upload artwork. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _showUploadDialog(),
            ),
          ),
        );
      }
    } catch (e) {
      // Hide loading snackbar and show error
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Upload failed: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _showUploadDialog(),
          ),
        ),
      );
    }
    
    // Log the upload data for debugging
    debugPrint('=== Artwork Upload Data ===');
    debugPrint('Title: $title');
    debugPrint('Description: $description');
    debugPrint('File Name: $fileName');
    debugPrint('Image Size: ${imageData.length} bytes');
  }
}

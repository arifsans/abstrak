import 'dart:typed_data';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:abstrak/widgets/animation_card.dart';
import 'package:abstrak/widgets/upload_artwerk_component.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ArtWerk extends StatefulWidget {
  const ArtWerk({super.key});

  @override
  State<ArtWerk> createState() => _ArtWerkState();
}

class _ArtWerkState extends State<ArtWerk> {
  final ArtwerkNotifier _artWerk = ArtwerkNotifier();

  @override
  void initState() {
    _artWerk.getArtwerk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? const EdgeInsets.all(0)
            : EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .3,
              ),
        child: ValueListenableBuilder(
          valueListenable: _artWerk.data,
          builder: (context, value, child) {
            var data = value?.data?.result ?? [];
            final List<Result> leftColumnImages = [];
            final List<Result> rightColumnImages = [];

            for (int i = 0; i < data.length; i++) {
              if (i % 2 == 0) {
                leftColumnImages.add(data[i]);
              } else {
                rightColumnImages.add(data[i]);
              }
            }

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

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    children: leftColumnImages.map(
                      (res) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AnimationCard(
                              imageUrl: res.image ?? '',
                              authorName: res.creatorName ?? '',
                              imageName: res.name ?? '',
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(width: 8), // Spacing between columns

                // Right column
                Expanded(
                  child: Column(
                    children: rightColumnImages.map(
                      (res) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AnimationCard(
                              imageUrl: res.image ?? '',
                              authorName: res.creatorName ?? '',
                              imageName: res.name ?? '',
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadDialog,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Upload Artwork'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
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

  void _handleArtworkUpload(String title, String description, Uint8List? imageData, String? fileName) {
    // Close the dialog first
    Navigator.of(context).pop();
    
    // TODO: Implement the actual upload logic here
    // This is where you would:
    // 1. Upload the image to your server/cloud storage
    // 2. Send the artwork data to your API
    // 3. Add the new artwork to your backend
    
    // For now, show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Artwork "$title" uploaded successfully!'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Refresh',
          textColor: Colors.white,
          onPressed: () {
            // Refresh the artwork list
            _artWerk.getArtwerk();
          },
        ),
      ),
    );
    
    // Optionally refresh the artwork list automatically
    // _artWerk.getArtwerk();
    
    // Log the upload data for debugging
    debugPrint('=== Artwork Upload Data ===');
    debugPrint('Title: $title');
    debugPrint('Description: $description');
    debugPrint('File Name: $fileName');
    debugPrint('Image Size: ${imageData?.length ?? 0} bytes');
  }
}

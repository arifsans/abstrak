import 'dart:typed_data';
import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:abstrak/widgets/upload_artwerk_component.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DialogHelpers {
  /// Shows the upload artwork dialog that can be reused across different screens
  static void showUploadDialog(
    BuildContext context, {
    ArtwerkNotifier? artwerkNotifier,
    VoidCallback? onUploadSuccess,
  }) {
    final artWerk = artwerkNotifier ?? ArtwerkNotifier();
    
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
                      onArtwerkUploaded: (title, description, imageData, fileName) => 
                          _handleArtworkUpload(context, artWerk, title, description, imageData, fileName, onUploadSuccess),
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

  /// Handles the artwork upload process with proper error handling and feedback
  static void _handleArtworkUpload(
    BuildContext context,
    ArtwerkNotifier artWerk,
    String title,
    String description,
    Uint8List? imageData,
    String? fileName,
    VoidCallback? onUploadSuccess,
  ) async {
    // Store the parent context before popping the dialog
    final parentContext = Navigator.of(context, rootNavigator: true).context;
    
    // Close the dialog first
    context.pop();
    
    // Validate required data
    if (imageData == null || fileName == null || title.trim().isEmpty || description.trim().isEmpty) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
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
    ScaffoldMessenger.of(parentContext).showSnackBar(
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
      final success = await artWerk.uploadArtwerk(
        name: title.trim(),
        description: description.trim(),
        imageData: imageData,
        fileName: fileName,
      );
      
      // Hide loading snackbar
      ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();
      
      if (success) {
        // Show success message with review notice
        ScaffoldMessenger.of(parentContext).showSnackBar(
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
                ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();
              },
            ),
          ),
        );
        
        // Call the success callback if provided
        onUploadSuccess?.call();
      } else {
        // Show error message
        ScaffoldMessenger.of(parentContext).showSnackBar(
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
              onPressed: () => showUploadDialog(parentContext, artwerkNotifier: artWerk, onUploadSuccess: onUploadSuccess),
            ),
          ),
        );
      }
    } catch (e) {
      // Hide loading snackbar and show error
      ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();
      
      ScaffoldMessenger.of(parentContext).showSnackBar(
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
            onPressed: () => showUploadDialog(parentContext, artwerkNotifier: artWerk, onUploadSuccess: onUploadSuccess),
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
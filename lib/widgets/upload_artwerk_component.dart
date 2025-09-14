import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:file_picker/file_picker.dart';

class UploadArtwerkComponent extends StatefulWidget {
  final Function(String title, String description, Uint8List? imageData, String? fileName)? onArtwerkUploaded;
  
  const UploadArtwerkComponent({
    super.key,
    this.onArtwerkUploaded,
  });

  @override
  State<UploadArtwerkComponent> createState() => _UploadArtwerkComponentState();
}

class _UploadArtwerkComponentState extends State<UploadArtwerkComponent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  late DropzoneViewController _dropzoneController;
  Uint8List? _imageData;
  String? _fileName;
  bool _isHighlighted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Input validation and sanitization methods
  String _sanitizeInput(String input) {
    // Remove potential script tags and dangerous characters
    String sanitized = input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML/XML tags
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('"', '')
        .replaceAll("'", '')
        .replaceAll('`', '')
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '') // Remove javascript: protocol
        .replaceAll(RegExp(r'data:', caseSensitive: false), '') // Remove data: protocol
        .replaceAll(RegExp(r'vbscript:', caseSensitive: false), '') // Remove vbscript: protocol
        .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '') // Remove event handlers like onclick=
        .replaceAll(RegExp(r'eval\s*\(', caseSensitive: false), '') // Remove eval()
        .replaceAll(RegExp(r'alert\s*\(', caseSensitive: false), '') // Remove alert()
        .replaceAll(RegExp(r'confirm\s*\(', caseSensitive: false), '') // Remove confirm()
        .replaceAll(RegExp(r'prompt\s*\(', caseSensitive: false), '') // Remove prompt()
        .replaceAll(RegExp(r'document\.', caseSensitive: false), '') // Remove document access
        .replaceAll(RegExp(r'window\.', caseSensitive: false), '') // Remove window access
        .replaceAll(RegExp(r'console\.', caseSensitive: false), '') // Remove console access
        .trim();
    
    return sanitized;
  }

  bool _isValidInput(String input) {
    // Check for common script injection patterns
    final dangerousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'data:', caseSensitive: false),
      RegExp(r'vbscript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'eval\s*\(', caseSensitive: false),
      RegExp(r'<iframe', caseSensitive: false),
      RegExp(r'<object', caseSensitive: false),
      RegExp(r'<embed', caseSensitive: false),
      RegExp(r'<link', caseSensitive: false),
      RegExp(r'<meta', caseSensitive: false),
      RegExp(r'<form', caseSensitive: false),
      RegExp(r'<input', caseSensitive: false),
      RegExp(r'<textarea', caseSensitive: false),
      RegExp(r'<button', caseSensitive: false),
    ];

    for (final pattern in dangerousPatterns) {
      if (pattern.hasMatch(input)) {
        return false;
      }
    }

    return true;
  }

  String? _validateTitle(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter artwerk title';
    }
    
    if (!_isValidInput(value)) {
      return 'Title contains invalid characters or potential security risks';
    }
    
    if (value.length > 100) {
      return 'Title must be less than 100 characters';
    }
    
    // Check for only whitespace or special characters
    if (RegExp(r'^[\s\W]*$').hasMatch(value)) {
      return 'Title must contain at least one alphanumeric character';
    }
    
    return null;
  }

  String? _validateDescription(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter artwerk description';
    }
    
    if (!_isValidInput(value)) {
      return 'Description contains invalid characters or potential security risks';
    }
    
    if (value.length > 500) {
      return 'Description must be less than 500 characters';
    }
    
    // Check for only whitespace or special characters
    if (RegExp(r'^[\s\W]*$').hasMatch(value)) {
      return 'Description must contain at least one alphanumeric character';
    }
    
    return null;
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    
    // Validate title
    final titleError = _validateTitle(title);
    if (titleError != null) {
      _showSnackBar(titleError);
      return;
    }
    
    // Validate description
    final descriptionError = _validateDescription(description);
    if (descriptionError != null) {
      _showSnackBar(descriptionError);
      return;
    }
    
    if (_imageData == null) {
      _showSnackBar('Please upload an image');
      return;
    }

    // Sanitize inputs before processing
    final sanitizedTitle = _sanitizeInput(title);
    final sanitizedDescription = _sanitizeInput(description);

    widget.onArtwerkUploaded?.call(
      sanitizedTitle,
      sanitizedDescription,
      _imageData,
      _fileName,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearImage() {
    setState(() {
      _imageData = null;
      _fileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: const Color(0xFF2a2a2a), // Dark card background
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'Upload New Artwerk',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Title Input
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white), // White text input
              decoration: const InputDecoration(
                labelText: 'Artwerk Title',
                labelStyle: TextStyle(color: Colors.white70), // Light gray label
                hintText: 'Enter artwerk title',
                hintStyle: TextStyle(color: Colors.white54), // Subtle hint text
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30), // Light border
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30), // Light border when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2), // White border when focused
                ),
                prefixIcon: Icon(Icons.title, color: Colors.white70), // Light gray icon
              ),
              maxLength: 100,
              onChanged: (value) {
                // Real-time validation
                if (!_isValidInput(value)) {
                  _showSnackBar('Invalid characters detected in title');
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[<>]')), // Prevent angle brackets
                FilteringTextInputFormatter.deny(RegExp(r'"')), // Prevent double quotes
                FilteringTextInputFormatter.deny(RegExp(r"'")), // Prevent single quotes
                FilteringTextInputFormatter.deny(RegExp(r'[`{}]')), // Prevent backticks and braces
              ],
            ),
            const SizedBox(height: 16),

            // Description Input
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white), // White text input
              decoration: const InputDecoration(
                labelText: 'Artwerk Description',
                labelStyle: TextStyle(color: Colors.white70), // Light gray label
                hintText: 'Enter artwerk description',
                hintStyle: TextStyle(color: Colors.white54), // Subtle hint text
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30), // Light border
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30), // Light border when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2), // White border when focused
                ),
                prefixIcon: Icon(Icons.description, color: Colors.white70), // Light gray icon
              ),
              maxLines: 3,
              maxLength: 500,
              onChanged: (value) {
                // Real-time validation
                if (!_isValidInput(value)) {
                  _showSnackBar('Invalid characters detected in description');
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[<>]')), // Prevent angle brackets
                FilteringTextInputFormatter.deny(RegExp(r'"')), // Prevent double quotes
                FilteringTextInputFormatter.deny(RegExp(r"'")), // Prevent single quotes
                FilteringTextInputFormatter.deny(RegExp(r'[`{}]')), // Prevent backticks and braces
              ],
            ),
            const SizedBox(height: 24),

            // Image Upload Section
            const Text(
              'Artwerk Image',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 8),

            // Dropzone Area
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isHighlighted ? Colors.blue : Colors.white30,
                  width: _isHighlighted ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: _isHighlighted ? Colors.blue.withValues(alpha: 0.2) : const Color(0xFF333333),
              ),
              child: _imageData != null ? _buildImagePreview() : _buildDropzone(),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Blue background
                foregroundColor: Colors.white, // White text
                disabledBackgroundColor: Colors.grey[700], // Dark gray when disabled
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Upload Artwerk',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropzone() {
    return Stack(
      children: [
        DropzoneView(
          operation: DragOperation.copy,
          cursor: CursorType.grab,
          onCreated: (controller) => _dropzoneController = controller,
          onLoaded: () => debugPrint('Dropzone loaded'),
          onError: (error) => debugPrint('Dropzone error: $error'),
          onHover: () {
            setState(() => _isHighlighted = true);
          },
          onLeave: () {
            setState(() => _isHighlighted = false);
          },
          onDropFile: (value) {
            // In flutter_dropzone 4.2.1, the event is already a DropzoneFileInterface
            final file = value;
            _dropzoneController.getFilename(file).then((name) async {
              setState(() {
                _isHighlighted = false;
                _isLoading = true;
              });

              try {
                // Check if it's an image file
                if (_isImageFile(name)) {
                  final bytes = await _dropzoneController.getFileData(file);
                  setState(() {
                    _imageData = bytes;
                    _fileName = name;
                  });
                } else {
                  _showSnackBar('Please upload an image file (PNG, JPG, JPEG)');
                }
              } catch (e) {
                _showSnackBar('Error uploading file: $e');
              } finally {
                setState(() => _isLoading = false);
              }
            });
          },
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 64,
                color: _isHighlighted ? Colors.blue : Colors.white54, // Light gray when not highlighted
              ),
              const SizedBox(height: 16),
              Text(
                'Drop your artwerk image here',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _isHighlighted ? Colors.blue : Colors.white70, // Light gray text
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'or click to browse',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54, // Subtle gray text
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _pickFile(),
                icon: const Icon(Icons.folder_open, color: Colors.white),
                label: const Text('Browse Files', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue background
                  foregroundColor: Colors.white, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: MemoryImage(_imageData!),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: _clearImage,
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Remove image',
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _fileName ?? 'Unknown file',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void _pickFile() async {
    try {
      setState(() => _isLoading = true);
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        if (file.bytes != null) {
          // Check if it's an image file
          if (_isImageFile(file.name)) {
            setState(() {
              _imageData = file.bytes!;
              _fileName = file.name;
            });
          } else {
            _showSnackBar('Please upload an image file (PNG, JPG, JPEG)');
          }
        } else {
          _showSnackBar('Error reading file data');
        }
      }
    } catch (e) {
      _showSnackBar('Error picking file: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _isImageFile(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return ['png', 'jpg', 'jpeg'].contains(extension);
  }
}
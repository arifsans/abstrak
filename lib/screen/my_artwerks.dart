import 'package:abstrak/main.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:abstrak/helper/dialog_helpers.dart';
import 'package:abstrak/helper/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyArtwerks extends StatefulWidget {
  const MyArtwerks({super.key});

  @override
  State<MyArtwerks> createState() => _MyArtwerksState();
}

class _MyArtwerksState extends State<MyArtwerks> {
  final ArtwerkNotifier _artWerk = ArtwerkNotifier();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  late String userId;
  late SharedPreferences prefs;

  Future<void> initializeData() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? '';
    _artWerk.getArtwerk(userId: userId.isEmpty ? null : int.tryParse(userId));
  }

  @override
  void initState() {
    initializeData();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
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

        await _artWerk.getArtwerk(page: _currentPage + 1, userId: userId.isEmpty ? null : int.tryParse(userId));
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'MY ARTWERKS',
          style: customTextTheme.titleLarge?.copyWith(
            fontFamily: 'Kenzo',
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF1a1a1a),
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
                      'There are no artworks available. Upload to get started!',
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
                left: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                    ? 8
                    : 0,
                right: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                    ? 8
                    : 0,
                bottom: 80, // Space for FAB
              ),
              itemCount: data.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading indicator at the end
                if (index >= data.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final artwerk = data[index];
                return _buildArtwerkListItem(artwerk);
              },
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
      floatingActionButtonLocation:
          ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? FloatingActionButtonLocation.centerFloat
              : FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildArtwerkListItem(Result artwerk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: artwerk.status == '1' 
              ? Colors.greenAccent.withValues(alpha: 0.3)
              : artwerk.status == '2'
                  ? Colors.redAccent.withValues(alpha: 0.3)
                  : Colors.orangeAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              artwerk.image ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[700],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          
          // Artwerk details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        artwerk.name ?? 'Untitled',
                        style: customTextTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(artwerk.status),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  artwerk.description ?? 'No description',
                  style: customTextTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Creator and date
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      artwerk.creatorName ?? 'Unknown',
                      style: customTextTheme.bodySmall?.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatterHelper.formatDate(artwerk.createdAt ?? ''),
                      style: customTextTheme.bodySmall?.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Action buttons
                _buildActionButtons(artwerk),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color color;
    String label;
    IconData icon;
    
    switch (status) {
      case '1':
        color = Colors.greenAccent;
        label = 'Approved';
        icon = Icons.check_circle;
        break;
      case '2':
        color = Colors.redAccent;
        label = 'Rejected';
        icon = Icons.cancel;
        break;
      default:
        color = Colors.orangeAccent;
        label = 'Pending';
        icon = Icons.pending;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: customTextTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Result artwerk) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    if (isMobile) {
      // Mobile view - icon buttons only
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Edit button
          IconButton(
            onPressed: () => _showEditDialog(artwerk),
            icon: const Icon(Icons.edit),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF00bcd5),
              foregroundColor: Colors.black,
            ),
            tooltip: 'Edit',
          ),
          const SizedBox(width: 4),
          // View button
          IconButton(
            onPressed: () => _showViewDialog(artwerk),
            icon: const Icon(Icons.visibility),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            tooltip: 'View',
          ),
          const SizedBox(width: 4),
          // Delete button
          IconButton(
            onPressed: () => _showDeleteConfirmation(artwerk),
            icon: const Icon(Icons.delete),
            style: IconButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            tooltip: 'Delete',
          ),
        ],
      );
    } else {
      // Desktop view - full buttons with text
      return Row(
        children: [
          // Edit button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showEditDialog(artwerk),
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00bcd5),
                foregroundColor: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // View button
          ElevatedButton.icon(
            onPressed: () => _showViewDialog(artwerk),
            icon: const Icon(Icons.visibility),
            label: const Text('View'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          // Delete button
          ElevatedButton.icon(
            onPressed: () => _showDeleteConfirmation(artwerk),
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    }
  }

  void _showEditDialog(Result artwerk) {
    final nameController = TextEditingController(text: artwerk.name ?? '');
    final descriptionController = TextEditingController(text: artwerk.description ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit Artwork',
            style: customTextTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image preview (read-only)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: artwerk.image != null && artwerk.image!.isNotEmpty
                        ? Image.network(
                            artwerk.image!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                color: Colors.grey[700],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white54,
                                  size: 48,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: double.infinity,
                            color: Colors.grey[700],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                              size: 48,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title field
                  Text(
                    'Title',
                    style: customTextTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    style: customTextTheme.bodyMedium?.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter artwork title',
                      hintStyle: customTextTheme.bodyMedium?.copyWith(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description field
                  Text(
                    'Description',
                    style: customTextTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    style: customTextTheme.bodyMedium?.copyWith(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter artwork description',
                      hintStyle: customTextTheme.bodyMedium?.copyWith(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: customTextTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement update functionality
                // For now, just show a message and close dialog
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit functionality will be implemented'),
                    backgroundColor: Color(0xFF00bcd5),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00bcd5),
                foregroundColor: Colors.black,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showViewDialog(Result artwerk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            artwerk.name ?? 'Artwork Details',
            style: customTextTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: artwerk.image != null && artwerk.image!.isNotEmpty
                      ? Image.network(
                          artwerk.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[700],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white54,
                                size: 48,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[700],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                            size: 48,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Details
                _buildDetailRow('Name', artwerk.name ?? 'Untitled'),
                _buildDetailRow('Description', artwerk.description ?? 'No description'),
                _buildDetailRow('Creator', artwerk.creatorName ?? 'Unknown'),
                _buildDetailRow('Created At', DateFormatterHelper.formatDate(artwerk.createdAt ?? '')),
                _buildDetailRow('Updated At', DateFormatterHelper.formatDate(artwerk.updatedAt ?? '')),
                _buildDetailRow('Status', _getStatusText(artwerk.status)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: customTextTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF00bcd5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(dynamic artwerk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2a2a2a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Artwork',
            style: customTextTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this artwork?',
                style: customTextTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        artwerk.image ?? '',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[600],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artwerk.name ?? 'Untitled',
                            style: customTextTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            artwerk.description ?? 'No description',
                            style: customTextTheme.bodySmall?.copyWith(
                              color: Colors.grey[400],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This action cannot be undone.',
                style: customTextTheme.bodySmall?.copyWith(
                  color: Colors.redAccent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: customTextTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement delete functionality
                // For now, just show a message and close dialog
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Delete functionality will be implemented'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: customTextTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: customTextTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case '1':
        return 'Approved';
      case '2':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  void _showUploadDialog() {
    DialogHelpers.showUploadDialog(
      context,
      artwerkNotifier: _artWerk,
      onUploadSuccess: () {
        // Refresh the artworks list after successful upload
        _artWerk.getArtwerk(status: 1, userId: userId.isEmpty ? null : int.tryParse(userId));
      },
    );
  }
  
}

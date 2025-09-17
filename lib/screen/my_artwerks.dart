import 'package:abstrak/base/api_state.dart';
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
  String? _selectedStatus; // null means all, '0' = pending, '1' = approved, '2' = rejected

  Future<void> initializeData() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? '';
    _artWerk.getArtwerk(userId: userId.isEmpty ? null : int.tryParse(userId));
  }

  void _filterByStatus(String? status) {
    // Only proceed if we have a valid userId
    if (userId.isEmpty) {
      debugPrint('Cannot filter - no userId available');
      return;
    }
    
    setState(() {
      _selectedStatus = status;
      _currentPage = 1;
    });
    
    // Convert status string to int for API call
    int? statusInt;
    if (status != null) {
      statusInt = int.tryParse(status);
    }
    
    debugPrint('Filtering artwerks for userId: $userId, status: $statusInt');
    
    _artWerk.getArtwerk(
      status: statusInt, 
      userId: int.tryParse(userId)!, // Force non-null since we checked above
      page: 1,
    );
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      // Use a debounced approach to prevent multiple calls
      if (!_isLoadingMore && _artWerk.data.value.status != ApiStatus.loading) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadMoreData() async {
    // Only proceed if we have a valid userId
    if (userId.isEmpty) {
      debugPrint('Cannot load more data - no userId available');
      return;
    }
    
    final data = _artWerk.data.value.data?.data;
    if (data?.hasMore == true && !_isLoadingMore && _artWerk.data.value.status != ApiStatus.loading) {
      setState(() {
        _isLoadingMore = true;
      });

      try {
        _currentPage = data?.currentPage ?? 1;

        // Add a small delay to prevent rapid fire requests
        await Future.delayed(const Duration(milliseconds: 100));

        // Convert status string to int for API call
        int? statusInt;
        if (_selectedStatus != null) {
          statusInt = int.tryParse(_selectedStatus!);
        }

        await _artWerk.getArtwerk(
          page: _currentPage + 1, 
          userId: int.tryParse(userId)!, // Force non-null since we checked above
          status: statusInt,
        );
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
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    'Filter: ',
                    style: customTextTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip('All', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', '0'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Approved', '1'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Rejected', '2'),
                ],
              ),
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                  ? const EdgeInsets.all(0)
                  : EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * .1,
                    ),
              child: ValueListenableBuilder(
                valueListenable: _artWerk.data,
                builder: (context, value, child) {
                  var data = value.data?.data?.result ?? [];

                  if (data.isEmpty) {
                    return Center(
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
                            _getEmptyStateTitle(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _getEmptyStateSubtitle(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadDialog,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Upload Artwerk'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation:
          ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? FloatingActionButtonLocation.centerFloat
              : FloatingActionButtonLocation.endFloat,
    );
  }

  String _getEmptyStateTitle() {
    switch (_selectedStatus) {
      case '0':
        return 'No pending artwerks';
      case '1':
        return 'No approved artwerks';
      case '2':
        return 'No rejected artwerks';
      default:
        return 'No artwerks yet';
    }
  }

  String _getEmptyStateSubtitle() {
    switch (_selectedStatus) {
      case '0':
        return 'You don\'t have any artwerks waiting for approval. Upload new artwerk to get started!';
      case '1':
        return 'You don\'t have any approved artwerks yet. Keep creating and uploading your amazing art!';
      case '2':
        return 'You don\'t have any rejected artwerks. That\'s great! Keep up the excellent work!';
      default:
        return 'There are no artwerks available. Upload to get started!';
    }
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        _filterByStatus(selected ? value : null);
      },
      backgroundColor: const Color(0xFF2a2a2a),
      selectedColor: _getChipColor(value),
      labelStyle: customTextTheme.bodySmall?.copyWith(
        color: isSelected ? Colors.black : Colors.white,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? _getChipColor(value) : Colors.white.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  Color _getChipColor(String? status) {
    switch (status) {
      case '1':
        return Colors.greenAccent;
      case '2':
        return Colors.redAccent;
      case '0':
        return Colors.orangeAccent;
      default:
        return const Color(0xFF00bcd5);
    }
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
            'Edit Artwerk',
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
                      hintText: 'Enter artwerk title',
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
                      hintText: 'Enter artwerk description',
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
            artwerk.name ?? 'Artwerk Details',
            style: customTextTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            child: SingleChildScrollView(
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
            'Delete Artwerk',
            style: customTextTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this artwerk?',
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
    // Only allow upload if user is logged in
    if (userId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to upload artwerks'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    debugPrint('Before upload dialog - userId: "$userId"');

    DialogHelpers.showUploadDialog(
      context,
      artwerkNotifier: _artWerk,
      onUploadSuccess: () async {
        final freshPrefs = await SharedPreferences.getInstance();
        final freshUserId = freshPrefs.getString('user_id') ?? '';

        // Reset pagination and refresh the artworks list after successful upload
        if (mounted) {
          setState(() {
            _currentPage = 1;
          });
        }

        _artWerk.getArtwerk(
          userId: int.tryParse(freshUserId),
          page: 1,
        );
      },
    );
  }
  
}

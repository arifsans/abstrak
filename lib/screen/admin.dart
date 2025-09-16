import 'dart:async';
import 'package:abstrak/main.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/admin_notifier.dart';
import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:abstrak/helper/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AdminNotifier _admin = AdminNotifier();
  final ArtwerkNotifier _artwerkNotifier = ArtwerkNotifier();
  final _searchController = TextEditingController();
  String? _selectedCreator;
  bool _isDropdownOpen = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _admin.getArtwerk();
  }

  void _searchUsers(String query) {
    // Cancel the previous timer if it exists
    _debounceTimer?.cancel();
    
    // Create a new timer with 500ms delay
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.length >= 3) {
        await _artwerkNotifier.filterUserByName(name: query);
        if (mounted) {
          setState(() {
            _isDropdownOpen = true;
          });
        }
      } else {
        _artwerkNotifier.users.value = null;
        if (mounted) {
          setState(() {
            _isDropdownOpen = false;
          });
        }
      }
    });
  }

  void _closeDropdown() {
    setState(() {
      _isDropdownOpen = false;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'CONTENT MANAGEMENT',
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
                horizontal: MediaQuery.sizeOf(context).width * .3,
              ),
        child: GestureDetector(
          onTap: () => _closeDropdown(),
          child: Column(
            spacing: 16,
            children: [
              // Dropdown Search Widget
              GestureDetector(
                onTap: () {}, // Prevent propagation
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                  ),
                  child: Column(
                    children: [
                      // Search Input
                      TextFormField(
                        controller: _searchController,
                        style: courierText.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Search Creator Name',
                          hintStyle: courierText.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isDropdownOpen = !_isDropdownOpen;
                              });
                            },
                            icon: Icon(
                              _isDropdownOpen 
                                  ? Icons.keyboard_arrow_up 
                                  : Icons.keyboard_arrow_down,
                              color: const Color(0xFF00bcd5),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _searchUsers(value);
                        },
                        onTap: () {
                          if (_searchController.text.length >= 2) {
                            setState(() {
                              _isDropdownOpen = true;
                            });
                          }
                        },
                      ),
                      
                      // Dropdown Options
                      if (_isDropdownOpen)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.white, width: 0.5),
                            ),
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: _artwerkNotifier.users,
                            builder: (context, usersData, child) {
                              final users = usersData?.data ?? [];
                              
                              if (_artwerkNotifier.isLoading.value) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00bcd5),
                                    ),
                                  ),
                                );
                              }
                              
                              if (users.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'No users found',
                                    style: courierText.bodyMedium?.copyWith(
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  final userName = user.name ?? 'Unknown User';
                                  final isSelected = _selectedCreator == userName;
                                  
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedCreator = userName;
                                        _searchController.text = userName;
                                        _isDropdownOpen = false;
                                      });
                                      if (user.id != null) {
                                        _admin.getArtwerk(userId: int.tryParse(user.id!));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected 
                                            ? const Color(0xFF00bcd5).withValues(alpha: 0.2)
                                            : Colors.transparent,
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: const Color(0xFF00bcd5),
                                            backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                                                ? NetworkImage(user.avatar!)
                                                : null,
                                            child: user.avatar == null || user.avatar!.isEmpty
                                                ? Text(
                                                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                                    style: courierText.bodySmall?.copyWith(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userName,
                                                  style: courierText.bodyMedium?.copyWith(
                                                    color: isSelected 
                                                        ? const Color(0xFF00bcd5)
                                                        : Colors.white,
                                                  ),
                                                ),
                                                if (user.email != null && user.email!.isNotEmpty)
                                                  Text(
                                                    user.email!,
                                                    style: courierText.bodySmall?.copyWith(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check,
                                              color: Color(0xFF00bcd5),
                                              size: 18,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Selected Creator Info
              if (_selectedCreator != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00bcd5)),
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF00bcd5).withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color(0xFF00bcd5),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Selected Creator: $_selectedCreator',
                          style: courierText.bodyMedium?.copyWith(
                            color: const Color(0xFF00bcd5),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedCreator = null;
                            _searchController.clear();
                            _isDropdownOpen = false;
                          });
                          _artwerkNotifier.users.value = null;
                           _admin.getArtwerk();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Color(0xFF00bcd5),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Artwerks List
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _admin.data,
                  builder: (context, value, child) {
                    var data = value?.data?.result ?? [];

                    if (data.isEmpty) {
                      return const Center(
                        child: Text(
                          'No artwerks found',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final artwerk = data[index];
                        return _buildArtwerkListItem(artwerk);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
                        style: courierText.titleMedium?.copyWith(
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
                  style: courierText.bodyMedium?.copyWith(
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
                      style: courierText.bodySmall?.copyWith(
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
                      style: courierText.bodySmall?.copyWith(
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
            style: courierText.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Result artwerk) {
    if (artwerk.status == '1' || artwerk.status == '2') {
      // Already processed
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showArtwerkDetails(artwerk),
              icon: const Icon(Icons.visibility),
              label: const Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00bcd5),
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      );
    }
    
    // Pending - show accept/reject buttons
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showArtwerkDetails(artwerk),
            icon: const Icon(Icons.visibility),
            label: const Text('Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00bcd5),
              foregroundColor: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => _acceptArtwerk(artwerk),
          icon: const Icon(Icons.check),
          label: const Text('Accept'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => _rejectArtwerk(artwerk),
          icon: const Icon(Icons.close),
          label: const Text('Reject'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showArtwerkDetails(Result artwerk) {
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
            style: courierText.titleLarge?.copyWith(color: Colors.white),
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
                  _buildDetailRow('Creator Email', artwerk.creatorEmail ?? 'N/A'),
                  _buildDetailRow('Created At', DateFormatterHelper.formatDate(artwerk.createdAt ?? '')),
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
                style: courierText.bodyMedium?.copyWith(
                  color: const Color(0xFF00bcd5),
                ),
              ),
            ),
            if (artwerk.status != '1' && artwerk.status != '2') ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _acceptArtwerk(artwerk);
                },
                child: Text(
                  'Accept',
                  style: courierText.bodyMedium?.copyWith(
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _rejectArtwerk(artwerk);
                },
                child: Text(
                  'Reject',
                  style: courierText.bodyMedium?.copyWith(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
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
            width: 200,
            child: Text(
              '$label:',
              style: courierText.bodyMedium?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: courierText.bodyMedium?.copyWith(
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

  Future<void> _acceptArtwerk(Result artwerk) async {
    print('hahaha');
    if (artwerk.id == null) return;
    
    final success = await _admin.acceptArtwerk(artwerk.id!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Artwerk "${artwerk.name}" has been accepted'),
          backgroundColor: Colors.greenAccent,
        ),
      );
      _admin.refreshArtwerkList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to accept artwerk'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _rejectArtwerk(Result artwerk) async {
    if (artwerk.id == null) return;
    
    final success = await _admin.rejectArtwerk(artwerk.id!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Artwerk "${artwerk.name}" has been rejected'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      _admin.refreshArtwerkList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to reject artwerk'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

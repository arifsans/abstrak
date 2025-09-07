import 'dart:async';
import 'package:abstrak/main.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/admin_notifier.dart';
import 'package:abstrak/notifier/user_notifier.dart';
import 'package:abstrak/widgets/animation_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AdminNotifier _admin = AdminNotifier();
  final UserNotifier _userNotifier = UserNotifier();
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
        await _userNotifier.getUsersByName(name: query);
        if (mounted) {
          setState(() {
            _isDropdownOpen = true;
          });
        }
      } else {
        _userNotifier.users.value = null;
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
                            valueListenable: _userNotifier.users,
                            builder: (context, usersData, child) {
                              final users = usersData?.data ?? [];
                              
                              if (_userNotifier.isLoading.value) {
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
                                            ? const Color(0xFF00bcd5).withOpacity(0.2)
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
                    color: const Color(0xFF00bcd5).withOpacity(0.1),
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
                          _userNotifier.users.value = null;
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
              
              // Artworks Grid
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _admin.data,
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
                      return Container();
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
                                    child: Stack(
                                      children: [
                                        AnimationCard(
                                          imageUrl: res.image ?? '',
                                          authorName: res.creatorName ?? '',
                                          imageName: res.name ?? '',
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: Icon(
                                            res.status == '1'
                                                ? Icons.check_circle
                                                : Icons.pending_actions_rounded,
                                            color: res.status == '1'
                                                ? Colors.greenAccent
                                                : Colors.orangeAccent,
                                          ),
                                        )
                                      ],
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
                                    child: Stack(
                                      children: [
                                        AnimationCard(
                                          imageUrl: res.image ?? '',
                                          authorName: res.creatorName ?? '',
                                          imageName: res.name ?? '',
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: Icon(
                                            res.status == '1'
                                                ? Icons.check_circle
                                                : Icons.pending_actions_rounded,
                                            color: res.status == '1'
                                                ? Colors.greenAccent
                                                : Colors.orangeAccent,
                                          ),
                                        )
                                      ],
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/model/comment_model.dart';
import 'package:abstrak/repository/artwerk_repo.dart';
import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/main.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EnhancedArtwerkDetailDialog extends StatefulWidget {
  final Result artwerk;

  const EnhancedArtwerkDetailDialog({
    super.key,
    required this.artwerk,
  });

  @override
  State<EnhancedArtwerkDetailDialog> createState() => _EnhancedArtwerkDetailDialogState();
}

class _EnhancedArtwerkDetailDialogState extends State<EnhancedArtwerkDetailDialog>
    with TickerProviderStateMixin {
  final ArtwerkRepo _artwerkRepo = ArtwerkRepo();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late TabController _tabController;
  
  // State management
  Map<String, int> _interactionCounts = {};
  Map<String, bool> _userInteractions = {};
  List<CommentData> _comments = [];
  bool _isLoadingInteractions = false;
  bool _isLoadingComments = false;
  bool _isSubmittingComment = false;
  int _commentsPage = 1;
  bool _hasMoreComments = true;
  bool _hasTrackedView = false; // Flag to ensure view is tracked only once

  // Interaction type IDs based on your database seeder
  static const int LIKE_ID = 1;
  static const int SHARE_ID = 2;
  static const int VIEW_ID = 3;
  static const int SEEN_ID = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // IMPORTANT: Track view interaction immediately when dialog opens
    // This will increment the view count for this artwork every time
    // a user opens the detail dialog
    _trackView();
    
    // Then load interaction data and comments
    _loadInteractionData();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _trackView() async {
    // Ensure view is tracked only once per dialog session
    if (_hasTrackedView) return;
    
    // Automatically track view interaction every time artwork detail is opened
    try {
      print('Tracking view for artwork: ${widget.artwerk.id}');
      
      bool success = await _artwerkRepo.toggleArtwerkInteraction(
        artwerkId: int.parse(widget.artwerk.id.toString()),
        interactionId: VIEW_ID,
      );
      
      if (success) {
        print('View tracked successfully');
        _hasTrackedView = true; // Mark as tracked
        
        // Reload interaction data after tracking view to get updated counts
        await _loadInteractionData();
      } else {
        print('Failed to track view');
      }
    } catch (e) {
      // Log but don't show error to user for view tracking
      print('Failed to track view for artwork ${widget.artwerk.id}: $e');
    }
  }

  Future<void> _loadInteractionData() async {
    if (mounted) {
      setState(() => _isLoadingInteractions = true);
    }
    
    try {
      // Load interaction counts
      final countsResponse = await _artwerkRepo.getArtwerkInteractionCounts(
        artwerkId: widget.artwerk.id.toString(),
      );
      
      // Load user interactions
      final userInteractionsResponse = await _artwerkRepo.getUserInteractions(
        artwerkId: widget.artwerk.id.toString(),
      );

      if (mounted) {
        setState(() {
          if (countsResponse?.data != null) {
            _interactionCounts = {
              'likes': countsResponse!.data!.likesCount ?? 0,
              'shares': countsResponse.data!.sharesCount ?? 0,
              'views': countsResponse.data!.viewsCount ?? 0,
              'seen': countsResponse.data!.seenCount ?? 0,
            };
          }
          
          if (userInteractionsResponse != null) {
            _userInteractions = userInteractionsResponse;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to load interactions: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingInteractions = false);
      }
    }
  }

  Future<void> _loadComments({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _comments.clear();
        _commentsPage = 1;
        _hasMoreComments = true;
      });
    }

    if (!_hasMoreComments) return;

    setState(() => _isLoadingComments = true);
    try {
      final response = await _artwerkRepo.getArtwerkComments(
        artwerkId: widget.artwerk.id.toString(),
        page: _commentsPage,
        totalData: 10,
      );
      
      if (response?.data != null && mounted) {
        setState(() {
          if (isRefresh) {
            _comments = response!.data!.result ?? [];
          } else {
            _comments.addAll(response!.data!.result ?? []);
          }
          _hasMoreComments = response.data!.hasMore ?? false;
          _commentsPage++;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to load comments: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingComments = false);
      }
    }
  }

  Future<void> _toggleInteraction(int interactionId, String interactionType) async {
    try {
      bool success = await _artwerkRepo.toggleArtwerkInteraction(
        artwerkId: int.parse(widget.artwerk.id.toString()),
        interactionId: interactionId,
      );
      
      if (success) {
        // Provide haptic feedback
        HapticFeedback.lightImpact();
        
        // Reload interaction data
        await _loadInteractionData();
      } else {
        _showSnackBar('Failed to $interactionType artwork');
      }
    } catch (e) {
      _showSnackBar('Failed to $interactionType artwork: $e');
    }
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isSubmittingComment = true);
    try {
      await _artwerkRepo.createComment(
        artwerkId: widget.artwerk.id.toString(),
        content: _commentController.text.trim(),
      );
      
      _commentController.clear();
      await _loadComments(isRefresh: true);
      _showSnackBar('Comment posted successfully!');
    } catch (e) {
      _showSnackBar('Failed to post comment: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmittingComment = false);
      }
    }
  }

  Future<void> _toggleCommentLike(String commentId) async {
    try {
      bool success = await _artwerkRepo.toggleCommentInteraction(
        commentId: commentId,
        interactionId: LIKE_ID,
      );
      
      if (success) {
        HapticFeedback.lightImpact();
        await _loadComments(isRefresh: true);
      } else {
        _showSnackBar('Failed to like comment');
      }
    } catch (e) {
      _showSnackBar('Failed to like comment: $e');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatTime(String? dateString) {
    if (dateString == null) return 'Just now';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 900,
          maxHeight: 700,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a1a), // Match your app's primary dark color
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildImageView(),
                  _buildCommentsView(),
                ],
              ),
            ),
            _buildInteractionBar(),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: widget.artwerk.creatorAvatar != null
                ? CachedNetworkImageProvider(widget.artwerk.creatorAvatar!)
                : null,
            child: widget.artwerk.creatorAvatar == null
                ? Text(widget.artwerk.creatorName?.substring(0, 1).toUpperCase() ?? 'U')
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.artwerk.creatorName ?? 'Unknown Artist',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatTime(widget.artwerk.createdAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: 'Artwork'),
              Tab(text: 'Comments'),
            ],
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildImageView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Artwork Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: widget.artwerk.image ?? '',
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 300,
                color: const Color(0xFF2a2a2a),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 300,
                color: const Color(0xFF2a2a2a),
                child: const Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Artwork Title
          Text(
            widget.artwerk.name ?? 'Untitled',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Artwork Description
          if (widget.artwerk.description?.isNotEmpty == true) ...[
            Text(
              widget.artwerk.description!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentsView() {
    return Column(
      children: [
        Expanded(
          child: _comments.isEmpty && !_isLoadingComments
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No comments yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Be the first to comment!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _comments.length + (_isLoadingComments ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _comments.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      );
                    }

                    final comment = _comments[index];
                    return _buildCommentItem(comment);
                  },
                ),
        ),
        
        if (_hasMoreComments && !_isLoadingComments)
          TextButton(
            onPressed: () => _loadComments(),
            child: const Text('Load more comments'),
          ),
      ],
    );
  }

  Widget _buildCommentItem(CommentData comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: comment.userAvatar != null
                ? CachedNetworkImageProvider(comment.userAvatar!)
                : null,
            child: comment.userAvatar == null
                ? Text(comment.userName?.substring(0, 1).toUpperCase() ?? 'U')
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName ?? 'Unknown User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(comment.createdAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleCommentLike(comment.id.toString()),
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: comment.isLiked == true
                                ? Colors.red
                                : Colors.white.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment.likesCount ?? 0}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionBar() {
    if (_isLoadingInteractions) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          _buildInteractionButton(
            icon: (_userInteractions['like'] == true || _userInteractions['Like'] == true)
                ? Icons.favorite
                : Icons.favorite_border,
            label: '${_interactionCounts['likes'] ?? _interactionCounts['Like'] ?? 0}',
            isActive: (_userInteractions['like'] == true || _userInteractions['Like'] == true),
            activeColor: Colors.red,
            onTap: () => _toggleInteraction(LIKE_ID, 'like'),
          ),
          const SizedBox(width: 24),
          _buildInteractionButton(
            icon: (_userInteractions['share'] == true || _userInteractions['Share'] == true)
                ? Icons.share
                : Icons.share_outlined,
            label: '${_interactionCounts['shares'] ?? _interactionCounts['Share'] ?? 0}',
            isActive: (_userInteractions['share'] == true || _userInteractions['Share'] == true),
            activeColor: Colors.blue,
            onTap: () => _toggleInteraction(SHARE_ID, 'share'),
          ),
          const SizedBox(width: 24),
          _buildInteractionButton(
            icon: Icons.visibility,
            label: '${_interactionCounts['views'] ?? _interactionCounts['View'] ?? 0}',
            isActive: false,
            activeColor: Colors.white.withOpacity(0.7),
            onTap: () {}, // View count is display-only, not interactive
          ),
          const Spacer(),
          _buildInteractionButton(
            icon: Icons.comment_outlined,
            label: '${_comments.length}',
            isActive: false,
            onTap: () => _tabController.animateTo(1),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    Color? activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive && activeColor != null 
                  ? activeColor 
                  : Colors.white.withOpacity(0.7),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isActive && activeColor != null 
                    ? activeColor 
                    : Colors.white.withOpacity(0.7),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return ValueListenableBuilder(
      valueListenable: authNotifier.auth,
      builder: (context, authValue, child) {
        if (authValue.status != ApiStatus.success) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Please login to comment',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submitComment(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isSubmittingComment ? null : _submitComment,
                icon: _isSubmittingComment
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
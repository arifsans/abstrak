class CommentModel {
  bool? status;
  String? message;
  CommentData? data;

  CommentModel({this.status, this.message, this.data});

  CommentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CommentData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CommentsListModel {
  bool? status;
  String? message;
  CommentsListData? data;

  CommentsListModel({this.status, this.message, this.data});

  CommentsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CommentsListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CommentsListData {
  List<CommentData>? result;
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  bool? isFirst;
  bool? isLast;
  bool? hasMore;

  CommentsListData({
    this.result,
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
    this.isFirst,
    this.isLast,
    this.hasMore,
  });

  CommentsListData.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <CommentData>[];
      json['result'].forEach((v) {
        result!.add(CommentData.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
    isFirst = json['is_first'];
    isLast = json['is_last'];
    hasMore = json['has_more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['last_page'] = lastPage;
    data['is_first'] = isFirst;
    data['is_last'] = isLast;
    data['has_more'] = hasMore;
    return data;
  }
}

class CommentData {
  int? id;
  int? artwerkId;
  int? userId;
  int? parentId; // For nested replies
  String? content;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  
  // User information
  String? userName;
  String? userEmail;
  String? userAvatar;
  
  // Reply information
  List<CommentData>? replies;
  int? repliesCount;
  
  // Interaction counts
  int? likesCount;
  bool? isLiked;

  CommentData({
    this.id,
    this.artwerkId,
    this.userId,
    this.parentId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.replies,
    this.repliesCount,
    this.likesCount,
    this.isLiked,
  });

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    artwerkId = json['artwerk_id'];
    userId = json['user_id'];
    parentId = json['parent_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userAvatar = json['user_avatar'];
    repliesCount = json['replies_count'];
    likesCount = json['likes_count'];
    isLiked = json['is_liked'];
    
    if (json['replies'] != null) {
      replies = <CommentData>[];
      json['replies'].forEach((v) {
        replies!.add(CommentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['artwerk_id'] = artwerkId;
    data['user_id'] = userId;
    data['parent_id'] = parentId;
    data['content'] = content;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_avatar'] = userAvatar;
    data['replies_count'] = repliesCount;
    data['likes_count'] = likesCount;
    data['is_liked'] = isLiked;
    
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    
    return data;
  }
}
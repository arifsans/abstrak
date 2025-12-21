class InteractionModel {
  bool? status;
  String? message;
  InteractionData? data;

  InteractionModel({this.status, this.message, this.data});

  InteractionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? InteractionData.fromJson(json['data']) : null;
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

class InteractionData {
  int? id;
  int? userId;
  String? artwerkId;
  String? type; // 'like', 'favorite', 'bookmark', etc.
  String? createdAt;
  String? updatedAt;

  InteractionData({
    this.id,
    this.userId,
    this.artwerkId,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  InteractionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    artwerkId = json['artwerk_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['artwerk_id'] = artwerkId;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class InteractionStatsModel {
  bool? status;
  String? message;
  InteractionStats? data;

  InteractionStatsModel({this.status, this.message, this.data});

  InteractionStatsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? InteractionStats.fromJson(json['data']) : null;
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

class InteractionStats {
  int? likesCount;
  int? sharesCount;
  int? viewsCount;
  int? seenCount;
  bool? isLiked;
  bool? isShared;
  bool? isViewed;
  bool? isSeen;

  InteractionStats({
    this.likesCount,
    this.sharesCount,
    this.viewsCount,
    this.seenCount,
    this.isLiked,
    this.isShared,
    this.isViewed,
    this.isSeen,
  });

  InteractionStats.fromJson(Map<String, dynamic> json) {
    likesCount = json['likes_count'];
    sharesCount = json['shares_count'];
    viewsCount = json['views_count'];
    seenCount = json['seen_count'];
    isLiked = json['is_liked'];
    isShared = json['is_shared'];
    isViewed = json['is_viewed'];
    isSeen = json['is_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['likes_count'] = likesCount;
    data['shares_count'] = sharesCount;
    data['views_count'] = viewsCount;
    data['seen_count'] = seenCount;
    data['is_liked'] = isLiked;
    data['is_shared'] = isShared;
    data['is_viewed'] = isViewed;
    data['is_seen'] = isSeen;
    return data;
  }
}
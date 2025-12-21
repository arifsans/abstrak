class ArtwerksModel {
  bool? status;
  String? message;
  Data? data;

  ArtwerksModel({this.status, this.message, this.data});

  ArtwerksModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Result>? result;
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  bool? isFirst;
  bool? isLast;
  bool? hasMore;

  Data(
      {this.result,
      this.currentPage,
      this.perPage,
      this.total,
      this.lastPage,
      this.isFirst,
      this.isLast,
      this.hasMore});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['is_first'] = this.isFirst;
    data['is_last'] = this.isLast;
    data['has_more'] = this.hasMore;
    return data;
  }
}

class Result {
  String? id;
  String? name;
  String? image;
  String? description;
  String? creatorId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? creatorName;
  String? creatorEmail;
  String? creatorPhone;
  String? creatorAvatar;
  
  // Interaction counts and user status
  int? likesCount;
  int? sharesCount;
  int? viewsCount;
  int? seenCount;
  int? commentsCount;
  bool? isLiked;
  bool? isShared;
  bool? isViewed;
  bool? isSeen;

  Result(
      {this.id,
      this.name,
      this.image,
      this.description,
      this.creatorId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.creatorName,
      this.creatorEmail,
      this.creatorPhone,
      this.creatorAvatar,
      this.likesCount,
      this.sharesCount,
      this.viewsCount,
      this.seenCount,
      this.commentsCount,
      this.isLiked,
      this.isShared,
      this.isViewed,
      this.isSeen});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    creatorId = json['creator_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    creatorName = json['creator_name'];
    creatorEmail = json['creator_email'];
    creatorPhone = json['creator_phone'];
    creatorAvatar = json['creator_avatar'];
    likesCount = json['likes_count'];
    sharesCount = json['shares_count'];
    viewsCount = json['views_count'];
    seenCount = json['seen_count'];
    commentsCount = json['comments_count'];
    isLiked = json['is_liked'];
    isShared = json['is_shared'];
    isViewed = json['is_viewed'];
    isSeen = json['is_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['creator_id'] = this.creatorId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['creator_name'] = this.creatorName;
    data['creator_email'] = this.creatorEmail;
    data['creator_phone'] = this.creatorPhone;
    data['creator_avatar'] = this.creatorAvatar;
    data['likes_count'] = this.likesCount;
    data['shares_count'] = this.sharesCount;
    data['views_count'] = this.viewsCount;
    data['seen_count'] = this.seenCount;
    data['comments_count'] = this.commentsCount;
    data['is_liked'] = this.isLiked;
    data['is_shared'] = this.isShared;
    data['is_viewed'] = this.isViewed;
    data['is_seen'] = this.isSeen;
    return data;
  }
}

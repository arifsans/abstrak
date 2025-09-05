class AuthModel {
  bool? status;
  String? message;
  Token? token;

  AuthModel({this.status, this.message, this.token});

  AuthModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.token != null) {
      data['token'] = this.token!.toJson();
    }
    return data;
  }
}

class Token {
  String? accessToken;
  String? refreshToken;
  String? expiresIn;

  Token({this.accessToken, this.refreshToken, this.expiresIn});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['expires_in'] = this.expiresIn;
    return data;
  }
}

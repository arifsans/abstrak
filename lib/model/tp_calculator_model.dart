class TPCalculatorModel {
  bool? status;
  String? message;
  String? additionalMessage;
  List<Data>? data;
  String? credit;

  TPCalculatorModel({
    this.status,
    this.message,
    this.additionalMessage,
    this.data,
    this.credit,
  });

  TPCalculatorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    additionalMessage = json['additional_message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['additional_message'] = this.additionalMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['credit'] = this.credit;
    return data;
  }
}

class Data {
  int? dailyGain;
  Legend? legend;
  Legend? nonLegend;
  int? acsNeeded;
  int? spinNeeded;

  Data(
      {this.dailyGain,
      this.legend,
      this.nonLegend,
      this.acsNeeded,
      this.spinNeeded});

  Data.fromJson(Map<String, dynamic> json) {
    dailyGain = json['daily_gain'];
    legend =
        json['legend'] != null ? new Legend.fromJson(json['legend']) : null;
    nonLegend = json['non_legend'] != null
        ? new Legend.fromJson(json['non_legend'])
        : null;
    acsNeeded = json['acs_needed'];
    spinNeeded = json['spin_needed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['daily_gain'] = this.dailyGain;
    if (this.legend != null) {
      data['legend'] = this.legend!.toJson();
    }
    if (this.nonLegend != null) {
      data['non_legend'] = this.nonLegend!.toJson();
    }
    data['acs_needed'] = this.acsNeeded;
    data['spin_needed'] = this.spinNeeded;
    return data;
  }
}

class Legend {
  int? days;
  String? date;

  Legend({this.days, this.date});

  Legend.fromJson(Map<String, dynamic> json) {
    days = json['days'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.days;
    data['date'] = this.date;
    return data;
  }
}

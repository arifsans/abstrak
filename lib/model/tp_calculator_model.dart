class TPCalculatorModel {
  bool? status;
  String? message;
  Data? data;

  TPCalculatorModel({this.status, this.message, this.data});

  TPCalculatorModel.fromJson(Map<String, dynamic> json) {
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
  List<Calculations>? calculations;
  String? additionalMessage;
  String? credit;

  Data({this.calculations, this.additionalMessage, this.credit});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['calculations'] != null) {
      calculations = <Calculations>[];
      json['calculations'].forEach((v) {
        calculations!.add(new Calculations.fromJson(v));
      });
    }
    additionalMessage = json['additional_message'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.calculations != null) {
      data['calculations'] = this.calculations!.map((v) => v.toJson()).toList();
    }
    data['additional_message'] = this.additionalMessage;
    data['credit'] = this.credit;
    return data;
  }
}

class Calculations {
  int? dailyGain;
  Legend? legend;
  Legend? nonLegend;
  int? acsNeeded;
  int? spinNeeded;

  Calculations(
      {this.dailyGain,
      this.legend,
      this.nonLegend,
      this.acsNeeded,
      this.spinNeeded});

  Calculations.fromJson(Map<String, dynamic> json) {
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

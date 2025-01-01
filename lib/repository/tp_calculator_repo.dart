import 'dart:convert';

import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/tp_calculator_model.dart';

class TPCalculatorRepo {
  Future<TPCalculatorModel?> getTp({
    required String username,
  }) async {
    var res = await ApiConnection().apiCall(
      method: ApiMethod.GET,
      path: 'tp_calculator/$username',
    );

    if (res != null) {
      var data = res.body;
      return TPCalculatorModel.fromJson(jsonDecode(data));
    }

    return TPCalculatorModel(
      status: false,
      message: "Terjadi Kesalahan",
    );
  }
}

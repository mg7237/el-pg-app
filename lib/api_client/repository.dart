import 'package:el_pg_app/api_client/api_client.dart';
import 'package:el_pg_app/config/config.dart';
import 'package:el_pg_app/model/add_tenant_request_model.dart';
import 'package:el_pg_app/model/add_tenant_response.dart';
import 'package:el_pg_app/model/exit_tenant_request_model.dart';
import 'package:el_pg_app/model/exit_tenant_response.dart';
import 'package:el_pg_app/model/forgot_pass_init_request.dart';
import 'package:el_pg_app/model/forgot_pass_init_response.dart';
import 'package:el_pg_app/model/forgot_pass_request.dart';
import 'package:el_pg_app/model/forgot_pass_response.dart';
import 'package:el_pg_app/model/get_pg_tenant_response_model.dart';
import 'package:el_pg_app/model/get_pg_tenanta_request_model.dart';
import 'package:el_pg_app/model/login_request_model.dart';
import 'package:el_pg_app/model/login_response.dart';
import 'package:el_pg_app/model/otp_request_model.dart';
import 'package:el_pg_app/model/otp_response.dart';
import 'package:el_pg_app/model/payment_modes_response.dart';
import 'package:el_pg_app/model/pg_list_response.dart';
import 'package:el_pg_app/model/proof_type_response.dart';
import 'package:el_pg_app/model/receive_payment_model.dart';
import 'package:el_pg_app/model/state_list_response.dart';
import 'package:el_pg_app/model/update_tenant_request_model.dart';
import 'package:el_pg_app/model/view_tenant_request_model.dart';
import 'package:el_pg_app/model/view_tenant_response.dart';
import 'package:el_pg_app/util/preference_connector.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:async/async.dart';

class Repository {
  ApiClient _apiClient = ApiClient();
  static Repository _instance;

  factory Repository() => _instance ??= Repository._();

  Repository._();

  // common get request
  Future<String> getRequest(String method) async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    http.Response response = await _apiClient.getMethod(
      ApiClient.BASE_URL + method,
      {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": deviceId,
        "Content-Type": "application/json",
        "x-api-key": x_api_key,
      },
    );
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common post request
  Future<String> postRequest(String method, var body) async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    http.Response response = await _apiClient.postMethod(
      method,
      body.toMap(),
      {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": deviceId,
        "Content-Type": "application/json",
        "x-api-key": x_api_key,
      },
    );
    print(response.body.toString());
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common patch multipart request
  Future<String> postRequestMultipart(var request) async {
    http.Response response = await _apiClient.postMethodMultipart(request);
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common patch request
  Future<String> patchRequest(String method, var body) async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    http.Response response = await _apiClient.patchMethod(
      method,
      body.toMap(),
      {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": deviceId,
        "Content-Type": "application/json",
        "x-api-key": x_api_key,
      },
    );
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common patch multipart request
  Future<String> patchRequestMultipart(var editProfileRequest) async {
    http.Response response =
        await _apiClient.patchMethodMultipart(editProfileRequest);
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  // common get request
  Future<String> deleteRequest(String method) async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    http.Response response = await _apiClient.deleteMethod(
      ApiClient.BASE_URL + method,
      {
        "APPID": Config.APP_ID,
        "Platform": ApiClient.DEVICE_TYPE,
        "DeviceID": deviceId,
        "Content-Type": "application/json",
        "x-api-key": x_api_key,
      },
    );
    if (response != null && response.statusCode == 200) {
      print(response.body.toString());
      return response.body.toString();
    } else {
      return '';
    }
  }

  Future<LoginResponse> login(LoginRequestModel model) async {
    String response = await postRequest("/users/login", model);
    if (response != null && response.isNotEmpty) {
      return loginResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<OtpResponse> generateOtp(OtpRequestModel model) async {
    String response = await postRequest("/users/generateotp", model);
    if (response != null && response.isNotEmpty) {
      return otpResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ForgotPassInitResponse> forgotPasswordInit(
      ForgotPasswordInitRequest model) async {
    String response = await postRequest("/users/changepasswordinit", model);
    if (response != null && response.isNotEmpty) {
      return forgotPassInitResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ForgotPassResponse> forgotPassword(ForgotPasswordRequest model) async {
    String response = await patchRequest("/users/changepassword", model);
    if (response != null && response.isNotEmpty) {
      return forgotPassResponseFromJson(response);
    } else {
      return null;
    }
  }

  addTenant(AddTenantRequestModel _data) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse(ApiClient.BASE_URL + "/tenant/onboard"));

    MediaType mediaTypeImage = MediaType.parse("image/png");
    //request.fields['userId'] = _data.userId;
    request.fields['full_name'] = _data.fullName;
    request.fields['address_line_1'] = _data.address1;
    request.fields['address_line_2'] = _data.address2;
    request.fields['city_name'] = _data.city;
    request.fields['state_code'] = _data.state;
    request.fields['pin_code'] = _data.pinCode;
    request.fields['email'] = _data.email;
    request.fields['mobile'] = _data.phoneNumber;
    request.fields['rent'] = _data.rent;
    request.fields['maintenance'] = _data.maintenance;
    request.fields['deposit'] = _data.deposit;
    request.fields['check_in_date'] = _data.joinDate;
    request.fields['property_id'] = _data.pgId;
    request.fields['room_no'] = _data.roomNumber;
    request.fields['emergency_contact_name'] = _data.emContactName;
    request.fields['emergency_contact_number'] = _data.emContactNumber;
    request.fields['emergency_contact_email'] = _data.emContactEmail;
    request.fields['employer_name'] = _data.employeeName;
    request.fields['exit_date'] = _data.exitDate;
    request.fields['id_document_type_1'] = _data.idType1;

    if (_data.profileImg != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_data.profileImg.openRead()));
      var length = await _data.profileImg.length();
      var multipartFile = new http.MultipartFile('photo', stream, length,
          filename: basename(_data.profileImg.path),
          contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }

    if (_data.idDoc1 != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_data.idDoc1.openRead()));
      var length = await _data.idDoc1.length();
      var multipartFile = new http.MultipartFile(
          'id_document_1', stream, length,
          filename: basename(_data.idDoc1.path), contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }

    if (_data.idDoc2 != null) {
      request.fields['id_document_type_2'] = _data.idType2;
      var stream =
          new http.ByteStream(DelegatingStream.typed(_data.idDoc2.openRead()));
      var length = await _data.idDoc2.length();
      var multipartFile = new http.MultipartFile(
          'id_document_2', stream, length,
          filename: basename(_data.idDoc2.path), contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }

    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "x-api-key": x_api_key,
    });

    String response = await postRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      return addTenantResponseFromJson(response);
    } else {
      return null;
    }
    print(response);
  }

  receivePayment(ReceivePaymentModel _data) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse(ApiClient.BASE_URL + "/tenant/tenantpaymentreceipt"));

    MediaType mediaTypeImage = MediaType.parse("image/png");
    //request.fields['userId'] = _data.userId;
    request.fields['tenant_id'] = _data.tenantId;
    request.fields['property_id'] = _data.propertyId;
    request.fields['amount_paid'] = _data.amountPaid;
    request.fields['payment_mode'] = _data.paymentMode;
    request.fields['remarks'] = _data.remark;
    request.fields['transaction_reference'] = _data.transactionReference;

    if (_data.paymentProofImg != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_data.paymentProofImg.openRead()));
      var length = await _data.paymentProofImg.length();
      var multipartFile = new http.MultipartFile(
          'payment_proof', stream, length,
          filename: basename(_data.paymentProofImg.path),
          contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }

    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "x-api-key": x_api_key,
    });

    String response = await postRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      return addTenantResponseFromJson(response);
    } else {
      return null;
    }
    print(response);
  }

  updateTenant(UpdateTenantRequestModel _data) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse(ApiClient.BASE_URL + "/tenant/pgtenantupdate"));

    MediaType mediaTypeImage = MediaType.parse("image/png");
    //request.fields['userId'] = _data.userId;
    request.fields['tenant_id'] = _data.tenantId;
    request.fields['full_name'] = _data.fullName;
    request.fields['address_line_1'] = _data.address1;
    request.fields['address_line_2'] = _data.address2;
    request.fields['city_name'] = _data.city;
    request.fields['state_code'] = _data.state;
    request.fields['pin_code'] = _data.pinCode;
    request.fields['email'] = _data.email;
    request.fields['mobile'] = _data.phoneNumber;
    request.fields['rent'] = _data.rent;
    request.fields['maintenance'] = _data.maintenance;
    request.fields['deposit'] = _data.deposit;
    request.fields['check_in_date'] = _data.joinDate;
    request.fields['property_id'] = _data.pgId;
    request.fields['room_no'] = _data.roomNumber;
    request.fields['emergency_contact_name'] = _data.emContactName;
    request.fields['emergency_contact_number'] = _data.emContactNumber;
    request.fields['emergency_contact_email'] = _data.emContactEmail;
    request.fields['employer_name'] = _data.employeeName;
    request.fields['exit_date'] = _data.exitDate;
    request.fields['id_document_type_1'] = _data.idType1;
    request.fields['id_document_type_2'] = _data.idType2;
    request.fields['document1_del'] = _data.document1_del;
    request.fields['document2_del'] = _data.document2_del;

    if (_data.profileImg != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_data.profileImg.openRead()));
      var length = await _data.profileImg.length();
      var multipartFile = new http.MultipartFile('photo', stream, length,
          filename: basename(_data.profileImg.path),
          contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }

    if (_data.idDoc1 != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_data.idDoc1.openRead()));
      var length = await _data.idDoc1.length();
      var multipartFile = new http.MultipartFile(
          'id_document_1', stream, length,
          filename: basename(_data.idDoc1.path), contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }

    if (_data.idDoc2 != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_data.idDoc2.openRead()));
      var length = await _data.idDoc2.length();
      var multipartFile = new http.MultipartFile(
          'id_document_2', stream, length,
          filename: basename(_data.idDoc2.path), contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }

    /*if (_data.employeeId != null) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_data.profileImg.openRead()));
      var length = await _data.profileImg.length();
      var multipartFile = new http.MultipartFile('profilePic', stream, length,
          filename: basename(_data.profileImg.path),
          contentType: mediaTypeImage);

      request.files.add(multipartFile);
    }*/

    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    String x_api_key =
        await PreferenceConnector().getString(PreferenceConnector.X_API_KEY);
    request.headers.addAll({
      "APPID": Config.APP_ID,
      "Platform": ApiClient.DEVICE_TYPE,
      "DeviceID": deviceId,
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "x-api-key": x_api_key,
    });

    String response = await postRequestMultipart(request);
    if (response != null && response.isNotEmpty) {
      return addTenantResponseFromJson(response);
    } else {
      return null;
    }
    print(response);
  }

  Future<PgListResponse> getPGList() async {
    String response = await getRequest("/tenant/pglist");
    if (response != null && response.isNotEmpty) {
      return pgListResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<PgTenantListResponse> getPGTenantList(
      GetPGTenantRequestModel requestModel) async {
    String response = await postRequest("/tenant/pgtenantlist", requestModel);
    if (response != null && response.isNotEmpty) {
      return pgTenantListResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ProofTypeResponse> getProofTypes() async {
    String response = await getRequest("/reference/prooftypes");
    if (response != null && response.isNotEmpty) {
      return proofTypeResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<StateListResponse> getStateList() async {
    String response = await getRequest("/reference/statelist");
    if (response != null && response.isNotEmpty) {
      return stateListResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ViewTenantResponse> getTenantDetails(
      ViewTenantRequestModel body) async {
    String response = await postRequest("/tenant/pgtenantdetails", body);
    if (response != null && response.isNotEmpty) {
      return viewTenantResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<ExitTenantResponse> exitTenant(ExitTenantRequestModel body) async {
    String response = await postRequest("/tenant/exittenant", body);
    if (response != null && response.isNotEmpty) {
      return exitTenantResponseFromJson(response);
    } else {
      return null;
    }
  }

  Future<PaymentModesListResponse> getPaymentMethodList() async {
    String response = await getRequest("/reference/paymentmodes");
    if (response != null && response.isNotEmpty) {
      return paymentModesListResponseFromJson(response);
    } else {
      return null;
    }
  }
}

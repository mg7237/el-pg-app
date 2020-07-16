import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:el_pg_app/api_client/repository.dart';
import 'package:el_pg_app/config/config.dart';
import 'package:el_pg_app/model/forgot_pass_init_request.dart';
import 'package:el_pg_app/model/forgot_pass_init_response.dart';
import 'package:el_pg_app/model/login_request_model.dart';
import 'package:el_pg_app/model/login_response.dart';
import 'package:el_pg_app/model/otp_request_model.dart';
import 'package:el_pg_app/model/otp_response.dart';
import 'package:el_pg_app/screen/forgot_password_page.dart';
import 'package:el_pg_app/util/preference_connector.dart';
import 'package:el_pg_app/util/route_setting.dart';
import 'package:el_pg_app/util/utility.dart';
import 'package:el_pg_app/widget/EnsureVisibleWhenFocused.dart';
import 'package:el_pg_app/widget/button.dart';
import 'package:el_pg_app/widget/common_loader.dart';
import 'package:el_pg_app/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_count_down/otp_count_down.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeNumber = new FocusNode();
  FocusNode _focusNodeOtp = new FocusNode();

  OTPCountDown _otpCountDown; // create instance
  final int _otpTimeInMS = 1000 * 1 * 60; // time in milliseconds for count down
  String countDownTime = '';
  bool timeEnd = false;
  int pageState = 1; // 1 = show tab, 2 = show otp view

  static final TextEditingController _emailController =
      new TextEditingController();
  static final TextEditingController _passwordController =
      new TextEditingController();
  static final TextEditingController _numberController =
      new TextEditingController();
  static final TextEditingController _otpController =
      new TextEditingController();

  LoginRequestModel _loginRequestModel = LoginRequestModel();
  bool showLoader = false, rememberMe = false;
  OtpResponse otpResponse;

  _openForgotPassword() {
    Navigator.of(context).pushNamed(FORGOT_PASSWORD_INIT);
  }

  _openHomePage() {
    Navigator.of(context).pushReplacementNamed(HOME_PAGE);
  }

  _validateAndSubmitForm() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        showLoader = true;
      });
      _formKey.currentState.save();
      LoginResponse response = await Repository().login(_loginRequestModel);
      setState(() {
        showLoader = false;
      });
      if (response == null) {
        Utility.showErrorSnackBar(_scaffoldKey, Config.SERVER_ERROR);
      } else if (response.forceChangePassword) {
        setState(() {
          showLoader = true;
        });
        ForgotPasswordInitRequest _request = ForgotPasswordInitRequest();
        _request.email = _loginRequestModel.email;
        ForgotPassInitResponse response =
            await Repository().forgotPasswordInit(_request);
        setState(() {
          showLoader = false;
        });
        if (response == null) {
          Utility.showErrorSnackBar(_scaffoldKey, Config.SERVER_ERROR);
        } else if (response.initStatus) {
          ForgotPasswordPageBundle bundle =
              ForgotPasswordPageBundle(email: _request.email, showMsg: true);
          Navigator.of(context).pushNamed(FORGOT_PASSWORD, arguments: bundle);
        } else {
          Utility.showErrorSnackBar(_scaffoldKey, response.message);
        }
      } else if (response.authResult) {
        _saveDateTime();
        PreferenceConnector()
            .setString(PreferenceConnector.USER_ID, response.userId);
        PreferenceConnector()
            .setString(PreferenceConnector.USER_TYPE, response.userType);
        PreferenceConnector()
            .setString(PreferenceConnector.X_API_KEY, response.x_api_key);
        PreferenceConnector()
            .setBool(PreferenceConnector.REMEMBER_ME, rememberMe);
        PreferenceConnector()
            .setBool(PreferenceConnector.REMEMBER_ME_STATUS, rememberMe);
        PreferenceConnector()
            .setString(PreferenceConnector.EMAIL, _emailController.text);
        PreferenceConnector()
            .setString(PreferenceConnector.PASSWORD, _passwordController.text);
        _openHomePage();
      } else {
        Utility.showErrorSnackBar(_scaffoldKey, response.message);
      }
    }
  }

  _validateAndSubmitFormForOtp() async {
    String number = _numberController.text;
    if (number.isNotEmpty) {
      if (number.length < 10) {
        Utility.showErrorSnackBar(_scaffoldKey, 'Invalid number.');
        return;
      }
      setState(() {
        showLoader = true;
      });
      OtpRequestModel requestModel = OtpRequestModel();
      requestModel.phoneNumber = number;
      setState(() {});
      otpResponse = await Repository().generateOtp(requestModel);
      setState(() {
        showLoader = false;
      });
      if (otpResponse != null) {
        if (otpResponse.status) {
          setState(() {
            pageState = 2;
          });
          startCountDownTimer();
          Utility.showSuccessSnackBar(_scaffoldKey, otpResponse.message);
        } else {
          Utility.showErrorSnackBar(_scaffoldKey, otpResponse.message);
        }
      } else {
        Utility.showErrorSnackBar(_scaffoldKey, 'Something went wrong.');
      }
    } else {
      Utility.showErrorSnackBar(_scaffoldKey, 'Enter your number.');
    }
  }

  startCountDownTimer() {
    timeEnd = false;
    _otpCountDown = OTPCountDown.startOTPTimer(
      timeInMS: _otpTimeInMS, // time in milliseconds
      currentCountDown: (String countDown) {
        setState(() {
          countDownTime = countDown;
        });
        print("Count down : $countDown"); // shows current count down time
      },
      onFinish: () {
        setState(() {
          timeEnd = true;
        });
        print("Count down finished!"); // called when the count down finishes.
      },
    );
  }

  _verifyOtp() async {
    String otp = _otpController.text;
    if (otp.isEmpty) {
      Utility.showErrorSnackBar(_scaffoldKey, 'Enter OTP.');
      return;
    }
    if (otpResponse.otp == otp) {
      Utility.showSuccessSnackBar(_scaffoldKey, 'OTP matched.');
      _saveDateTime();
      PreferenceConnector().setString(
          PreferenceConnector.USER_ID, otpResponse.userId.toString());
      PreferenceConnector()
          .setString(PreferenceConnector.USER_TYPE, otpResponse.userType);
      PreferenceConnector()
          .setString(PreferenceConnector.X_API_KEY, otpResponse.xApiKey);
      PreferenceConnector()
          .setBool(PreferenceConnector.REMEMBER_ME, rememberMe);
      PreferenceConnector()
          .setBool(PreferenceConnector.REMEMBER_ME_STATUS, rememberMe);
      /*PreferenceConnector()
          .setString(PreferenceConnector.EMAIL, _emailController.text);
      PreferenceConnector()
          .setString(PreferenceConnector.PASSWORD, _passwordController.text);*/
      _openHomePage();
      _otpCountDown.cancelTimer();
    } else {
      Utility.showErrorSnackBar(_scaffoldKey, 'Invalid OTP.');
    }
  }

  _saveDateTime() {
    var now = new DateTime.now();
    PreferenceConnector()
        .setString(PreferenceConnector.LOGIN_DATE_TIME, now.toIso8601String());
  }

  getDeviceInfo() async {
    String deviceId =
        await PreferenceConnector().getString(PreferenceConnector.DEVICE_ID);
    if (deviceId.isEmpty) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.androidId;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      PreferenceConnector().setString(PreferenceConnector.DEVICE_ID, deviceId);
    }
  }

  _checkRememberMe() async {
    rememberMe =
        await PreferenceConnector().getBool(PreferenceConnector.REMEMBER_ME);
    _emailController.text =
        await PreferenceConnector().getString(PreferenceConnector.EMAIL);
    _passwordController.text =
        await PreferenceConnector().getString(PreferenceConnector.PASSWORD);
    setState(() {});
  }

  @override
  void initState() {
    getDeviceInfo();
    super.initState();
    _checkRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage("assets/icon/background_image.png"))),
                ),
                pageState == 2
                    ? Expanded(
                        child: otpView(),
                      )
                    : Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0, 4),
                              blurRadius: 5)
                        ]),
                        child: Material(
                          color: Colors.blue,
                          shadowColor: Colors.red,
                          child: TabBar(
                            indicatorWeight: 8,
                            indicatorColor: Colors.white,
                            labelStyle: TextStyle(fontSize: 18),
                            tabs: <Widget>[
                              Tab(text: 'Email'),
                              Tab(text: 'Phone')
                            ],
                          ),
                        ),
                      ),
                pageState == 1
                    ? Expanded(
                        child: TabBarView(
                          children: <Widget>[tabFirst(), tabSecond()],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabFirst() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 5),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          //const SizedBox(height: 14.0),
          Hero(tag: "logo", child: Image.asset("assets/icon/login_logo.png")),
          const SizedBox(height: 14.0),
          Text(
            "Zero Brokerage & Hassle-Free Living With All Property Managment Taken Care of",
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          LabelText("Email"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeEmail,
            child: new TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: 'Enter your email address',
              ),
              onSaved: (value) => _loginRequestModel.email = value,
              validator: _loginRequestModel.emailValidate,
              controller: _emailController,
              focusNode: _focusNodeEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeEmail, _focusNodePassword);
              },
            ),
          ),
          const SizedBox(height: 34.0),
          LabelText("Password"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodePassword,
            child: new TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: 'Enter your password',
              ),
              onSaved: (value) => _loginRequestModel.password = value,
              validator: _loginRequestModel.passwordValidate,
              controller: _passwordController,
              focusNode: _focusNodePassword,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              obscureText: true,
              onFieldSubmitted: (value) {
                _validateAndSubmitForm();
              },
            ),
          ),
          const SizedBox(height: 34.0),
          showLoader
              ? Center(
                  child: CommonLoader(),
                )
              : CommonButton(
                  text: "Login",
                  bgColor: Theme.of(context).accentColor,
                  onPressed: _validateAndSubmitForm,
                ),
          const SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    rememberMe = !rememberMe;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(rememberMe
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Remember Me",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (!showLoader) {
                    _openForgotPassword();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: Text(
                    "Forgot Password?",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget tabSecond() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26.0, 10, 26, 5),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          //const SizedBox(height: 14.0),
          Hero(tag: "logo", child: Image.asset("assets/icon/login_logo.png")),
          const SizedBox(height: 14.0),
          Text(
            "Zero Brokerage & Hassle-Free Living With All Property Managment Taken Care of",
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          LabelText("Phone Number"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeNumber,
            child: new TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: 'Enter your phoe number',
              ),
              onSaved: (value) => _loginRequestModel.phoneNumber = value,
              validator: _loginRequestModel.phoneValidate,
              controller: _numberController,
              focusNode: _focusNodeNumber,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                // fieldFocusChange(context, _focusNodeEmail, _focusNodePassword);
              },
            ),
          ),
          const SizedBox(height: 34.0),
          const SizedBox(height: 34.0),
          showLoader
              ? Center(
                  child: CommonLoader(),
                )
              : CommonButton(
                  text: "Generate OTP",
                  bgColor: Theme.of(context).accentColor,
                  onPressed: _validateAndSubmitFormForOtp,
                ),
          const SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    rememberMe = !rememberMe;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(rememberMe
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Remember Me",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget otpView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26.0, 10, 26, 5),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          //const SizedBox(height: 14.0),
          Hero(tag: "logo", child: Image.asset("assets/icon/login_logo.png")),
          const SizedBox(height: 14.0),
          Text(
            "Zero Brokerage & Hassle-Free Living With All Property Managment Taken Care of",
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          LabelText("OTP"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeOtp,
            child: new TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: 'Verification code sent to your phone',
              ),
              onSaved: (value) => _loginRequestModel.otp = value,
              validator: _loginRequestModel.otpValidate,
              controller: _otpController,
              focusNode: _focusNodeOtp,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {},
            ),
          ),
          const SizedBox(height: 34.0),
          timeEnd
              ? Container()
              : Text(
                  countDownTime,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
          timeEnd
              ? showLoader
                  ? CommonLoader()
                  : FlatButton(
                      child: Text(
                        'Resend OTP',
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        _validateAndSubmitFormForOtp();
                      },
                    )
              : Container(),
          const SizedBox(height: 34.0),
          showLoader
              ? Center(
                  child: CommonLoader(),
                )
              : CommonButton(
                  text: "Verify",
                  bgColor: Theme.of(context).accentColor,
                  onPressed: _verifyOtp,
                ),
          const SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    rememberMe = !rememberMe;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(rememberMe
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Remember Me",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

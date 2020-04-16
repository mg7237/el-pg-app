import 'package:el_pg_app/api_client/repository.dart';
import 'package:el_pg_app/config/config.dart';
import 'package:el_pg_app/model/forgot_pass_request.dart';
import 'package:el_pg_app/model/forgot_pass_response.dart';
import 'package:el_pg_app/util/route_setting.dart';
import 'package:el_pg_app/util/utility.dart';
import 'package:el_pg_app/widget/EnsureVisibleWhenFocused.dart';
import 'package:el_pg_app/widget/button.dart';
import 'package:el_pg_app/widget/common_loader.dart';
import 'package:el_pg_app/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPageBundle {
  String email;
  bool showMsg;

  ForgotPasswordPageBundle({this.email, this.showMsg});
}

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage();

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeCode = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeRePassword = new FocusNode();
  static final TextEditingController _codeController =
      new TextEditingController();
  static final TextEditingController _passwordController =
      new TextEditingController();
  static final TextEditingController _rePasswordController =
      new TextEditingController();
  bool showToast = true;

  ForgotPasswordRequest _request = ForgotPasswordRequest();
  bool showLoader = false;

  TextStyle labelTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

  _onClickResetPassword() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        showLoader = true;
      });
      ForgotPassResponse response = await Repository().forgotPassword(_request);
      setState(() {
        showLoader = false;
      });
      if (response == null) {
        Utility.showErrorSnackBar(_scaffoldKey, Config.SERVER_ERROR);
      } else if (response.updateStatus) {
        _showSuccessAlert();
      } else {
        Utility.showErrorSnackBar(_scaffoldKey, response.message);
      }
    }
  }

  _showSuccessAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success",textScaleFactor: 1.0,),
            content: Text(
              "Your password updated successfully.",
              textScaleFactor: 1.0,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK",textScaleFactor: 1.0,),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LOGIN, (Route<dynamic> route) => false);
                },
              )
            ],
          );
        },
        barrierDismissible: false);
  }

  _showMsgAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Message",textScaleFactor: 1.0,),
            content: Text(
              "You are required to change password, please check OTP sent to your mobile and email id.",
              textScaleFactor: 1.0,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK",textScaleFactor: 1.0,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
        barrierDismissible: true);
  }

  show(bool showMsg)async{
    if (showToast && showMsg) {
      showToast = false;
      Future.delayed(Duration(milliseconds: 500), () {
          _showMsgAlert();
      });
    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ForgotPasswordPageBundle bundle = ModalRoute.of(context).settings.arguments;
    _request.user = bundle.email;
    show(bundle.showMsg);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/icon/background_image.png"))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26.0, 10, 26, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // const SizedBox(height: 14.0),
                        Image.asset("assets/icon/login_logo.png"),
                        const SizedBox(height: 14.0),
                        Text(
                          "Zero Brokerage & Hassle-Free Living With All Property Managment Taken Care of",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 30),
                        LabelText("Security code (sent to you on email)"),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodeCode,
                          child: new TextFormField(
                            enabled: !showLoader,
                            decoration: const InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: 'Enter Security code',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16)),
                            onSaved: (String value) =>
                                _request.securityCode = value,
                            validator: _request.validateSecurityCode,
                            controller: _codeController,
                            focusNode: _focusNodeCode,
                            onFieldSubmitted: (value) {
                              fieldFocusChange(
                                  context, _focusNodeCode, _focusNodePassword);
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        LabelText(
                          "Password",
                        ),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodePassword,
                          child: new TextFormField(
                            enabled: !showLoader,
                            decoration: const InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: 'Enter your new password',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16)),
                            onSaved: (String value) =>
                                _request.newPassword1 = value,
                            validator: _request.validateNewPassword1,
                            controller: _passwordController,
                            focusNode: _focusNodePassword,
                            obscureText: true,
                            onFieldSubmitted: (value) {
                              fieldFocusChange(context, _focusNodePassword,
                                  _focusNodeRePassword);
                            },
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        LabelText("Confirm Password"),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodeRePassword,
                          child: new TextFormField(
                            enabled: !showLoader,
                            decoration: const InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: 'Re-enter your new password',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16)),
                            onSaved: (String value) =>
                                _request.newPassword2 = value,
                            validator: (String value) =>
                                _request.validateNewPassword2(
                                    value, _passwordController.text),
                            controller: _rePasswordController,
                            focusNode: _focusNodeRePassword,
                            obscureText: true,
                            onFieldSubmitted: (value) {
                              _onClickResetPassword();
                            },
                          ),
                        ),
                        const SizedBox(height: 34.0),
                        showLoader
                            ? Center(
                                child: CommonLoader(),
                              )
                            : CommonButton(
                                text: "Reset Password",
                                bgColor: Theme.of(context).accentColor,
                                onPressed: _onClickResetPassword,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

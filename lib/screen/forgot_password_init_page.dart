import 'package:el_pg_app/api_client/repository.dart';
import 'package:el_pg_app/config/config.dart';
import 'package:el_pg_app/model/forgot_pass_init_request.dart';
import 'package:el_pg_app/model/forgot_pass_init_response.dart';
import 'package:el_pg_app/screen/forgot_password_page.dart';
import 'package:el_pg_app/util/route_setting.dart';
import 'package:el_pg_app/util/utility.dart';
import 'package:el_pg_app/widget/EnsureVisibleWhenFocused.dart';
import 'package:el_pg_app/widget/button.dart';
import 'package:el_pg_app/widget/common_loader.dart';
import 'package:el_pg_app/widget/label_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordInitPage extends StatefulWidget {
  @override
  _ForgotPasswordInitPageState createState() => _ForgotPasswordInitPageState();
}

class _ForgotPasswordInitPageState extends State<ForgotPasswordInitPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode _focusNodeCode = new FocusNode();
  static final TextEditingController _codeController =
      new TextEditingController();

  bool showLoader = false;

  TextStyle labelTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);
  ForgotPasswordInitRequest _request = ForgotPasswordInitRequest();

  _openForgotPassword() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        showLoader = true;
      });
      ForgotPassInitResponse response =
          await Repository().forgotPasswordInit(_request);
      setState(() {
        showLoader = false;
      });
      if (response == null) {
        Utility.showErrorSnackBar(_scaffoldKey, Config.SERVER_ERROR);
      } else if (response.initStatus) {
        ForgotPasswordPageBundle bundle = ForgotPasswordPageBundle(
            email: _request.email,showMsg: false
        );
        Navigator.of(context)
            .pushNamed(FORGOT_PASSWORD, arguments: bundle);
      } else {
        Utility.showErrorSnackBar(_scaffoldKey, response.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 30),
                        LabelText("Email"),
                        EnsureVisibleWhenFocused(
                          focusNode: _focusNodeCode,
                          child: new TextFormField(
                            enabled: !showLoader,
                            decoration: const InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: 'Enter your email',
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16)),
                            onSaved: (String value) => _request.email = value,
                            validator: _request.emailValidate,
                            controller: _codeController,
                            focusNode: _focusNodeCode,
                            onFieldSubmitted: (value) {
                              _openForgotPassword();
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
                                onPressed: () => _openForgotPassword(),
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

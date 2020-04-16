import 'package:dotted_border/dotted_border.dart';
import 'package:el_pg_app/api_client/repository.dart';
import 'package:el_pg_app/model/add_tenant_request_model.dart';
import 'package:el_pg_app/model/add_tenant_response.dart';
import 'package:el_pg_app/model/proof_type_response.dart';
import 'package:el_pg_app/model/state_list_response.dart';
import 'package:el_pg_app/util/utility.dart';
import 'package:el_pg_app/widget/EnsureVisibleWhenFocused.dart';
import 'package:el_pg_app/widget/attachment_view.dart';
import 'package:el_pg_app/widget/common_loader.dart';
import 'package:el_pg_app/widget/label_text.dart';
import 'package:el_pg_app/widget/label_text_with_astric.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class AddNewTenant extends StatefulWidget {
  final String pgId;

  AddNewTenant(this.pgId);

  @override
  _AddNewTenantState createState() => _AddNewTenantState();
}

class _AddNewTenantState extends State<AddNewTenant> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodeFullName = FocusNode();
  FocusNode _focusNodeNumber = FocusNode();
  FocusNode _focusNodeJoinDate = FocusNode();
  FocusNode _focusNodeExitDate = FocusNode();
  FocusNode _focusNodeAdd1 = FocusNode();
  FocusNode _focusNodeAdd2 = FocusNode();
  FocusNode _focusNodeCity = FocusNode();
  FocusNode _focusNodeState = FocusNode();
  FocusNode _focusNodePin = FocusNode();
  FocusNode _focusNodeRoom = FocusNode();
  FocusNode _focusNodeRent = FocusNode();
  FocusNode _focusNodeMaintenance = FocusNode();
  FocusNode _focusNodeDeposit = FocusNode();
  FocusNode _focusNodeCName = FocusNode();
  FocusNode _focusNodeCNumber = FocusNode();
  FocusNode _focusNodeEmEmail = FocusNode();
  FocusNode _focusNodeEmployerName = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _joinDateController = TextEditingController();
  final TextEditingController _exitDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _add1Controller = TextEditingController();
  final TextEditingController _add2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _maintenanceController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emergencyEmailController =
      TextEditingController();
  final TextEditingController _employerNameController = TextEditingController();
  bool showLoader = false;
  AddTenantRequestModel _requestModel = AddTenantRequestModel();
  List<ProofType> _proofList;
  List<States> stateList;
  ProofType _proofTypeDoc1, _proofTypeDoc2;
  bool loadProof = true;
  States selectedState;
  DateTime joinDate, exitDate;

  onClickOnBoard() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_requestModel.idDoc1 == null) {
        Utility.showErrorSnackBar(_scaffoldKey, 'Select Document.');
      } else if (_proofTypeDoc1 == null) {
        Utility.showErrorSnackBar(_scaffoldKey, 'Select Document type.');
      }
      /* else if (_requestModel.profileImg == null) {
        Utility.showErrorSnackBar(_scaffoldKey, 'Select profile.');
      } */
      else {
        if (joinDate != null && exitDate != null) {
          if (joinDate.isAfter(exitDate)) {
            Utility.showErrorSnackBar(
                _scaffoldKey, 'Exit date should be after join date.');
            return;
          }
        }
        _requestModel.pgId = widget.pgId;
        setState(() {
          showLoader = true;
        });
        AddTenantResponse response =
            await Repository().addTenant(_requestModel);
        setState(() {
          showLoader = false;
        });
        if (response != null) {
          if (response.status) {
            Utility.showSuccessSnackBar(_scaffoldKey, response.message);
            Future.delayed(Duration(milliseconds: 3000), () {
              Navigator.of(context).pop(true);
            });
          } else {
            Utility.showErrorSnackBar(
                _scaffoldKey, response.errors.join(",\n"));
          }
        } else {
          Utility.showSuccessSnackBar(
              _scaffoldKey, 'Something went wrong, Try again later.');
        }
      }
    }
  }

  void getProofTypes() async {
    ProofTypeResponse response = await Repository().getProofTypes();
    if (response != null) {
      if (response.status) {
        _proofList = response.proofTypes;
      }
    }
    setState(() {
      loadProof = false;
    });
  }

  void getStateList() async {
    StateListResponse response = await Repository().getStateList();
    if (response != null) {
      if (response.status) {
        stateList = response.states;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getStateList();
    getProofTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[600],
      appBar: AppBar(
          backgroundColor: Colors.blue[600],
          title: Text('On-Board New Tenant', textScaleFactor: 1.0),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30)),
                child: Icon(Icons.arrow_back),
              ),
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(8))),
        child: showLoader
            ? Center(child: CommonLoader())
            : Center(
                child: loadProof
                    ? CommonLoader()
                    : Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              customerInfoView(),
                              addressView(),
                              identificationDocView(),
                              priceView(),
                              emergencyContact(),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.blue)),
                                      child: Text(
                                        'Cancel',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: RaisedButton(
                                      color: Colors.blue,
                                      child: Text(
                                        'On-Board Tenant',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        onClickOnBoard();
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
              ),
      ),
    );
  }

  Widget header(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 18, top: 18),
      color: Colors.white,
      child: Text(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget customerInfoView() {
    return StickyHeader(
      header: header('Customer Info'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200],
                  ),
                  child: InkWell(
                    onTap: () {
                      _showImagePicker(4);
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      //padding: const EdgeInsets.all(6),
                      child: _requestModel.profileImg != null
                          ? Image.file(
                              _requestModel.profileImg,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          LabelTextAstric("Full Name"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeFullName,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: InputBorder.none,
                //hintText: 'Enter your email address',
              ),
              controller: _fullNameController,
              focusNode: _focusNodeFullName,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: _requestModel.fullNameValidate,
              onSaved: (value) {
                _requestModel.fullName = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeFullName, _focusNodeEmail);
              },
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          LabelTextAstric("Email"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeEmail,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                // hintText: 'Enter your email address',
              ),
              controller: _emailController,
              focusNode: _focusNodeEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _requestModel.emailValidate,
              onSaved: (value) {
                _requestModel.email = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeEmail, _focusNodeNumber);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelTextAstric("Mobile"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeNumber,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _numberController,
              focusNode: _focusNodeNumber,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              maxLength: 15,
              validator: _requestModel.phoneValidate,
              onSaved: (value) {
                _requestModel.phoneNumber = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeNumber, _focusNodeJoinDate);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelTextAstric("Join Date"),
          InkWell(
            onTap: () {
              showDatePicker(1);
            },
            child: EnsureVisibleWhenFocused(
              focusNode: _focusNodeJoinDate,
              child: TextFormField(
                enabled: false,
                decoration: const InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: '',
                ),
                controller: _joinDateController,
                focusNode: _focusNodeJoinDate,
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                validator: _requestModel.joinDateValidate,
                onSaved: (value) {
                  _requestModel.joinDate = value;
                },
                onFieldSubmitted: (value) {
                  fieldFocusChange(
                      context, _focusNodeJoinDate, _focusNodeExitDate);
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          LabelText("Planned Exit Date"),
          InkWell(
            onTap: () {
              showDatePicker(2);
            },
            child: EnsureVisibleWhenFocused(
              focusNode: _focusNodeExitDate,
              child: TextFormField(
                enabled: false,
                decoration: const InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: '',
                ),
                controller: _exitDateController,
                focusNode: _focusNodeExitDate,
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _requestModel.exitDate = value;
                },
                onFieldSubmitted: (value) {
                  fieldFocusChange(context, _focusNodeExitDate, _focusNodeAdd1);
                },
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget addressView() {
    return StickyHeader(
      header: header('Address'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LabelTextAstric("Address Line 1"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeAdd1,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _add1Controller,
              focusNode: _focusNodeAdd1,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: _requestModel.addressValidate,
              onSaved: (value) {
                _requestModel.address1 = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeAdd1, _focusNodeAdd2);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelText("Address Line 2"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeAdd2,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _add2Controller,
              focusNode: _focusNodeAdd2,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                _requestModel.address2 = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeAdd2, _focusNodeCity);
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LabelTextAstric("City"),
                    EnsureVisibleWhenFocused(
                      focusNode: _focusNodeCity,
                      child: TextFormField(
                        enabled: !showLoader,
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          hintText: '',
                        ),
                        controller: _cityController,
                        focusNode: _focusNodeCity,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: _requestModel.cityValidate,
                        onSaved: (value) {
                          _requestModel.city = value;
                        },
                        onFieldSubmitted: (value) {
                          fieldFocusChange(
                              context, _focusNodeCity, _focusNodeState);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LabelTextAstric("State"),
                    InkWell(
                      onTap: () {
                        _showStatePicker();
                      },
                      child: EnsureVisibleWhenFocused(
                        focusNode: _focusNodeState,
                        child: TextFormField(
                          enabled: false,
                          decoration: const InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: '',
                          ),
                          controller: _stateController,
                          focusNode: _focusNodeState,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: _requestModel.stateValidate,
                          onSaved: (value) {
                            _requestModel.state = selectedState.code;
                          },
                          onFieldSubmitted: (value) {
                            fieldFocusChange(
                                context, _focusNodeState, _focusNodePin);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          LabelTextAstric("Pin Code"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodePin,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _pinCodeController,
              focusNode: _focusNodePin,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              validator: _requestModel.pinValidate,
              maxLength: 15,
              onSaved: (value) {
                _requestModel.pinCode = value;
              },
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget identificationDocView() {
    return StickyHeader(
      header: header('Identification\nDocuments'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LabelTextAstric("Identification Document 1"),
          SizedBox(height: 10),
          _requestModel.idDoc1 != null
              ? Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(
                              Icons.insert_drive_file,
                              color: Colors.grey[600],
                              size: 50,
                            ),
                            Text(
                              path.basename(_requestModel.idDoc1.path),
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _requestModel.idDoc1 = null;
                          });
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.clear),
                        ),
                      )
                    ],
                  ),
                )
              : AttachmentView(
                  onPressed: () {
                    _showImagePicker(1);
                  },
                ),
          SizedBox(height: 16),
          LabelTextAstric("Identification Document 1 Type"),
          InkWell(
            onTap: () {
              _showProofTypePicker(1);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _proofTypeDoc1 == null ? '' : _proofTypeDoc1.name,
                      textScaleFactor: 1.0,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey)
                ],
              ),
            ),
          ),
          Container(
            height: 2,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          LabelText("Identification Document 2"),
          SizedBox(height: 10),
          _requestModel.idDoc2 != null
              ? Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(
                              Icons.insert_drive_file,
                              color: Colors.grey[600],
                              size: 50,
                            ),
                            Text(
                              path.basename(_requestModel.idDoc2.path),
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _requestModel.idDoc2 = null;
                          });
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.clear),
                        ),
                      )
                    ],
                  ),
                )
              : AttachmentView(
                  onPressed: () {
                    _showImagePicker(2);
                  },
                ),
          SizedBox(height: 16),
          LabelText("Identification Document 2 Type"),
          InkWell(
            onTap: () {
              _showProofTypePicker(2);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _proofTypeDoc2 == null ? '' : _proofTypeDoc2.name,
                      textScaleFactor: 1.0,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey)
                ],
              ),
            ),
          ),
          Container(
            height: 2,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget priceView() {
    return StickyHeader(
      header: header('Pricing'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LabelTextAstric("Room Number"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeRoom,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _roomNoController,
              focusNode: _focusNodeRoom,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: _requestModel.roomNumberValidate,
              onSaved: (value) {
                _requestModel.roomNumber = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeRoom, _focusNodeRent);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelTextAstric("Rent"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeRent,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _rentController,
              focusNode: _focusNodeRent,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: _requestModel.rentValidate,
              onSaved: (value) {
                _requestModel.rent = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(
                    context, _focusNodeRent, _focusNodeMaintenance);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelTextAstric("Maintenance"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeMaintenance,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _maintenanceController,
              focusNode: _focusNodeMaintenance,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: _requestModel.maintenanceValidate,
              onSaved: (value) {
                _requestModel.maintenance = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(
                    context, _focusNodeMaintenance, _focusNodeDeposit);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelTextAstric("Deposit"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeDeposit,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _depositController,
              focusNode: _focusNodeDeposit,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: _requestModel.depositValidate,
              onSaved: (value) {
                _requestModel.deposit = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeDeposit, _focusNodeCName);
              },
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget emergencyContact() {
    return StickyHeader(
      header: header('Emergency Contact & Employer details'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LabelText("Emergency Contact Name"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeCName,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _contactNameController,
              focusNode: _focusNodeCName,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                _requestModel.emContactName = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeCName, _focusNodeCNumber);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelText("Emergency Contact Number"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeCNumber,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _contactNumberController,
              focusNode: _focusNodeCNumber,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                _requestModel.emContactNumber = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(context, _focusNodeCNumber, _focusNodeEmEmail);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelText("Emergency Contact Email"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeEmEmail,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _emergencyEmailController,
              focusNode: _focusNodeEmEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                _requestModel.emContactEmail = value;
              },
              onFieldSubmitted: (value) {
                fieldFocusChange(
                    context, _focusNodeEmEmail, _focusNodeEmployerName);
              },
            ),
          ),
          SizedBox(height: 16),
          LabelText("Employer Name"),
          EnsureVisibleWhenFocused(
            focusNode: _focusNodeEmployerName,
            child: TextFormField(
              enabled: !showLoader,
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: '',
              ),
              controller: _employerNameController,
              focusNode: _focusNodeEmployerName,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSaved: (value) {
                _requestModel.employeeName = value;
              },
            ),
          ),
          SizedBox(height: 16),
          LabelText("Employee Id"),
          SizedBox(height: 10),
          _requestModel.employeeId != null
              ? Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(
                              Icons.insert_drive_file,
                              color: Colors.grey[600],
                              size: 50,
                            ),
                            Text(
                              path.basename(_requestModel.employeeId.path),
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _requestModel.employeeId = null;
                          });
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.clear),
                        ),
                      )
                    ],
                  ),
                )
              : AttachmentView(
                  onPressed: () {
                    _showImagePicker(3);
                  },
                ),
          SizedBox(height: 26),
        ],
      ),
    );
  }

  _showImagePicker(int imageFor) {
    bool checkCameraPermission = false;
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              'Select Image',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  "Select from Camera",
                  textScaleFactor: 1.0,
                ),
                onPressed: () async {
                  checkCameraPermission = true;
                  checkPermission(checkCameraPermission, imageFor);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  "Select from Gallery",
                  textScaleFactor: 1.0,
                ),
                onPressed: () async {
                  checkPermission(false, imageFor);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  checkPermission(bool result, int imageFor) async {
    if (result) {
      getImage(result, imageFor);
    } else {
      getImage(false, imageFor);
    }
  }

  Future getImage(bool result, int imageFor) async {
    var _image;
    if (result) {
      _image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    if (_image != null) {
      if (imageFor == 1) {
        _requestModel.idDoc1 = _image;
      } else if (imageFor == 2) {
        _requestModel.idDoc2 = _image;
      } else if (imageFor == 3) {
        _requestModel.employeeId = _image;
      } else if (imageFor == 4) {
        _requestModel.profileImg = _image;
      }
      setState(() {});
    }
  }

  _showProofTypePicker(int pickFor) {
    int selectedIndex = 0;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return InkWell(
            onTap: () {},
            child: Container(
              height: 200,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "Cancel",
                          textScaleFactor: 1.0,
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Select",
                            textScaleFactor: 1.0,
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          setState(() {
                            if (pickFor == 1) {
                              _requestModel.idType1 =
                                  _proofList[selectedIndex].id.toString();
                              _proofTypeDoc1 = _proofList[selectedIndex];
                            } else {
                              _requestModel.idType2 =
                                  _proofList[selectedIndex].id.toString();
                              _proofTypeDoc2 = _proofList[selectedIndex];
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[300],
                      itemExtent: 35,
                      children:
                          List<Widget>.generate(_proofList.length, (index) {
                        return Center(
                          child: Text(
                            "${_proofList[index].name}",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        );
                      }),
                      onSelectedItemChanged: (index) {
                        selectedIndex = index;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showStatePicker() {
    int selectedIndex = 0;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return InkWell(
            onTap: () {},
            child: Container(
              height: 200,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "Cancel",
                          textScaleFactor: 1.0,
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Select",
                            textScaleFactor: 1.0,
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          selectedState = stateList[selectedIndex];
                          _stateController.text = stateList[selectedIndex].name;
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[300],
                      itemExtent: 32,
                      children:
                          List<Widget>.generate(stateList.length, (index) {
                        return Center(
                          child: Text(
                            stateList[index].name,
                            textScaleFactor: 1.0,
                          ),
                        );
                      }),
                      onSelectedItemChanged: (index) {
                        selectedIndex = index;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showDatePicker(int dateFor) {
    if (dateFor == 2) {
      if (_joinDateController.text.trim().isEmpty) {
        Utility.showErrorSnackBar(_scaffoldKey, 'Select Join Date First.');
        return;
      }
    }
    DatePicker.showDatePicker(
      context,
      pickerMode: DateTimePickerMode.date,
      dateFormat: 'dd-MMM-yyyy',
      initialDateTime: DateTime.now(),
      minDateTime: dateFor == 1
          ? null
          : DateFormat('dd-MMM-yyyy').parse(_joinDateController.text),
      onConfirm: (DateTime dateTime, List<int> selectedIndex) {
        if (dateFor == 1) {
          // join date
          joinDate = dateTime;
          _joinDateController.text = DateFormat('dd-MMM-yyyy').format(joinDate);
        } else if (dateFor == 2) {
          //exit date
          exitDate = dateTime;
          _exitDateController.text = DateFormat('dd-MMM-yyyy').format(exitDate);
        }
        setState(() {});
      },
    );
  }
}

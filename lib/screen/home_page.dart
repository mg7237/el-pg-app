import 'dart:io';

import 'package:el_pg_app/api_client/repository.dart';
import 'package:el_pg_app/config/config.dart';
import 'package:el_pg_app/model/exit_tenant_request_model.dart';
import 'package:el_pg_app/model/exit_tenant_response.dart';
import 'package:el_pg_app/model/get_pg_tenant_response_model.dart';
import 'package:el_pg_app/model/get_pg_tenanta_request_model.dart';
import 'package:el_pg_app/model/payment_modes_response.dart';
import 'package:el_pg_app/model/pg_list_response.dart';
import 'package:el_pg_app/model/receive_payment_model.dart';
import 'package:el_pg_app/screen/add_new_tenant.dart';
import 'package:el_pg_app/screen/splash_screen.dart';
import 'package:el_pg_app/screen/view_new_tenant.dart';
import 'package:el_pg_app/util/helper.dart';
import 'package:el_pg_app/util/hex_color.dart';
import 'package:el_pg_app/util/preference_connector.dart';
import 'package:el_pg_app/util/route_setting.dart';
import 'package:el_pg_app/util/utility.dart';
import 'package:el_pg_app/widget/EnsureVisibleWhenFocused.dart';
import 'package:el_pg_app/widget/attachment_view.dart';
import 'package:el_pg_app/widget/button.dart';
import 'package:el_pg_app/widget/common_loader.dart';
import 'package:el_pg_app/widget/label_text.dart';
import 'package:el_pg_app/widget/label_text_with_astric.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Data> pgList = List();
  List<Datum> pgTenantList = List();
  bool loadFailed = false, loadPg = true, loadPgTenant = false;
  int status = 1; // 1 = active, 2 = past
  Data selectedPg;
  String message = '';
  ExitTenantResponse exitTenantResponse;
  int exitIndex = -1;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime exitDate;
  final TextEditingController exitDateController = TextEditingController();
  final TextEditingController exitReasonController = TextEditingController();
  int receivePaymentIndex = -1;

  StateSetter receivePaymentSetter;
  String paymentMode = '';
  TextEditingController amountDueCnt = TextEditingController();
  TextEditingController amountPaidCnt = TextEditingController();
  TextEditingController remarkCnt = TextEditingController();
  TextEditingController tranReferenceCnt = TextEditingController();
  GlobalKey<FormState> _keyReceivePaymentForm = GlobalKey();
  ReceivePaymentModel receivePaymentModel = ReceivePaymentModel();
  PaymentModesListResponse paymentModesListResponse;
  Mode selectedPaymentMode;

  @override
  void initState() {
    super.initState();
    getPGList();
    getPaymentModes();
  }

  getPaymentModes() async {
    paymentModesListResponse = await Repository().getPaymentMethodList();
  }

  getPGList() async {
    loadFailed = false;
    PgListResponse pgResponse = await Repository().getPGList();
    if (pgResponse != null) {
      if (pgResponse.status) {
        setState(() {
          pgList = pgResponse.data;
          if (pgList.length != 0) {
            selectedPg = pgList[0];
            getPGTenantList(selectedPg.id, '', '1');
          }
        });
      } else {
        setState(() {
          message = pgResponse.message;
          loadFailed = true;
        });
        pgList = null;
      }
    } else {
      setState(() {
        message = Config.SERVER_ERROR;
        loadFailed = true;
      });
      pgList = null;
    }
    setState(() {
      loadPg = false;
    });
  }

  getPGTenantList(String pgId, String term, String status) async {
    GetPGTenantRequestModel requestModel = GetPGTenantRequestModel();
    requestModel.pgId = pgId;
    requestModel.term = term;
    requestModel.status = status;
    setState(() {
      loadPgTenant = true;
    });
    PgTenantListResponse tenantListResponse =
        await Repository().getPGTenantList(requestModel);
    if (tenantListResponse != null) {
      if (tenantListResponse.status) {
        pgTenantList = tenantListResponse.data;
      } else {}
    } else {}
    setState(() {
      loadPgTenant = false;
    });
  }

  exitTenant(
    int index,
    String propertyId,
    String tenantId,
    String exitDate,
    String exitReason,
  ) async {
    ExitTenantRequestModel requestModel = ExitTenantRequestModel();
    requestModel.propertyId = propertyId;
    requestModel.exitDate = DateFormat('dd-MM-yyyy')
        .format(DateFormat('dd-MMM-yyyy').parse(exitDate));
    requestModel.tenantId = tenantId;
    requestModel.exitReason = exitReason;
    setState(() {
      exitIndex = index;
    });
    exitTenantResponse = await Repository().exitTenant(requestModel);
    if (exitTenantResponse != null) {
      if (exitTenantResponse.status) {
        //Utility.showSuccessSnackBar(_scaffoldKey, exitTenantResponse.message);
        pgTenantList[index].exitDate =
            DateFormat('dd-MM-yyyy').parse(requestModel.exitDate);
        // pgTenantList.removeAt(index);
        if (exitTenantResponse.warnings != null &&
            exitTenantResponse.warnings.length > 0) {
          Utility.showInfoDialog(context, 'Successfully Updated Agreement',
              'Warning(s):\n${exitTenantResponse.warnings.reduce((value, element) => value + '.\n' + element)}');
        } else {
          Utility.showInfoDialog(
              context, '', 'Successfully Updated Agreement.');
        }
      } else {
        if (exitTenantResponse.warnings != null &&
            exitTenantResponse.warnings.length > 0) {
          String warnings =
              'Warning(s):\n${exitTenantResponse.warnings.reduce((value, element) => value + '.\n' + element)}';
          String errors =
              'Error(s):\n${exitTenantResponse.errors.reduce((value, element) => value + '.\n' + element)}';
          Utility.showInfoDialog(context, 'Error while updating agreement',
              '$warnings\n\n$errors');
        } else {
          String errors =
              'Error(s):\n${exitTenantResponse.errors.reduce((value, element) => value + '.\n' + element)}';
          Utility.showInfoDialog(
              context, 'Error while updating agreement', errors);
        }
        Utility.showErrorSnackBar(_scaffoldKey, exitTenantResponse.message);
      }
    } else {
      Utility.showErrorSnackBar(_scaffoldKey, Config.SERVER_ERROR);
    }
    setState(() {
      exitIndex = -1;
    });
  }

  onClickSaveReceivePayment(int index) async {
    setState(() {
      receivePaymentIndex = index;
    });
    await Repository().receivePayment(receivePaymentModel);
    setState(() {
      pgTenantList[receivePaymentIndex].totalDue =
          (int.parse(pgTenantList[receivePaymentIndex].totalDue) -
                  int.parse(receivePaymentModel.amountPaid))
              .toString();
      receivePaymentIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: loadFailed ? Colors.white : HexColor('#2e7ccb'),
      body: Container(
        child: loadFailed
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    message,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(color: HexColor('#2e7ccb')),
                      padding: const EdgeInsets.all(20),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                'PG Guest List',
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              )),
                          InkWell(
                            onTap: () {
                              logoutDialog(context);
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Icon(Icons.exit_to_app,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 2, right: 2),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(8))),
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Property',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(height: 5),
                            loadPg
                                ? Center(child: CommonLoader())
                                : Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 5,
                                    child: InkWell(
                                      onTap: () {
                                        _showRequestTypePicker();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 12, 16, 12),
                                        color: HexColor('#f0f6ff'),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: Text(
                                              selectedPg == null
                                                  ? 'Property Value'
                                                  : selectedPg.name,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            )),
                                            Icon(Icons.keyboard_arrow_down)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(14),
                                      color: status == 1
                                          ? HexColor('#2e7ccb')
                                          : Colors.grey[100],
                                      child: Text(
                                        'Active Tenants',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                          color: status == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          status = 1;
                                        });
                                        getPGTenantList(selectedPg.id, '',
                                            status.toString());
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(14),
                                      color: status == 2
                                          ? HexColor('#2e7ccb')
                                          : Colors.grey[100],
                                      child: Text(
                                        'Past Tenants',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                          color: status == 2
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          status = 2;
                                        });
                                        await Future.delayed(
                                            Duration(milliseconds: 100));
                                        getPGTenantList(selectedPg.id, '',
                                            status.toString());
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 16, left: 5, right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(3)),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search)),
                                onChanged: (value) {
                                  if (value.length > 1) {
                                    getPGTenantList(selectedPg.id, value,
                                        status.toString());
                                  } else if (value.isEmpty) {
                                    getPGTenantList(
                                        selectedPg.id, '', status.toString());
                                  }
                                },
                              ),
                            ),
                            loadPgTenant
                                ? Center(child: CommonLoader())
                                : pgTenantList != null &&
                                        pgTenantList.length != 0
                                    ? ListView.separated(
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          Datum item = pgTenantList[index];
                                          return row(index, item);
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 5);
                                        },
                                        itemCount: pgTenantList.length,
                                        shrinkWrap: true,
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            'No tenant foud.',
                                            textScaleFactor: 1.0,
                                          ),
                                        ),
                                      ),
                            SizedBox(height: 80),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAddNewTenant();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Confirmation",
              textScaleFactor: 1.0,
            ),
            content: Text(
              "Are you sure, you want to logout?",
              textScaleFactor: 1.0,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "No",
                  textScaleFactor: 1.0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Yes",
                  textScaleFactor: 1.0,
                ),
                onPressed: () {
                  PreferenceConnector()
                      .setBool(PreferenceConnector.REMEMBER_ME_STATUS, false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (Route<dynamic> route) => false);
                },
              )
            ],
          );
        });
  }

  openAddNewTenant() async {
    if (selectedPg != null) {
      bool result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddNewTenant(selectedPg.id),
      ));
      if (result != null && result) {
        getPGTenantList(selectedPg.id, '', status.toString());
      }
    }
  }

  Widget row(int index, Datum item) {
    return Card(
      elevation: 6,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ViewTenant(selectedPg.id, item.id)));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${item.name}',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Room no. ${item.roomNo}',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Member since: ${DateFormat('dd-MMM-yyyy').format(item.memberSince)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          textScaleFactor: 1.0,
                        ),
                        SizedBox(height: 2),
                        Text(
                          item.exitDate != null
                              ? 'Exit Date: ${DateFormat('dd-MMM-yyyy').format(item.exitDate)}'
                              : '',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          textScaleFactor: 1.0,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '${item.email}',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 115,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '+${item.phone}',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey[300],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Rent',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Text('${Helper.RUPEE} ${item.rent}',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey[300],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Maintenance',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Text('${Helper.RUPEE} ${item.maintenance}',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey[300],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Deposit',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Text('${Helper.RUPEE} ${item.deposit}',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Utility.launchURL(
                          'mailto:${item.email}?subject=EL%20PG%20App&body=');
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 12, 2, 5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.email,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Email',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Utility.launchURL('tel:+${item.phone}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 12, 2, 5),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.call, size: 20, color: Colors.green),
                                SizedBox(width: 5),
                                Text(
                                  'Call',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Utility.launchURL('sms:+${item.phone}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 12, 2, 5),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.message,
                                    size: 20, color: Colors.blue),
                                SizedBox(width: 5),
                                Text(
                                  'Text',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  status == 1
                      ? InkWell(
                          onTap: () {
                            showExitDialog(item, index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 12, 2, 5),
                            child: exitIndex == index
                                ? Center(
                                    child: SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Row(
                                    children: <Widget>[
                                      Icon(Icons.exit_to_app,
                                          size: 20, color: Colors.red),
                                      SizedBox(width: 5),
                                      Text(
                                        'Exit Tenant',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                        )
                      : Container(),
                ],
              ),
              item.totalDue == '0'
                  ? Row(
                      children: <Widget>[
                        Text(
                          'No Dues',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[400],
                          ),
                        )
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Amount Due ${Helper.RUPEE} ${item.totalDue}',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                                textScaleFactor: 1.0,
                              ),
                              item.overdue
                                  ? Text(
                                      'Overdue',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.redAccent,
                                      ),
                                      textScaleFactor: 1.0,
                                    )
                                  : Text(
                                      'Due By: ${item.dueDate != null ? DateFormat('dd-MMM-yyyy').format(item.dueDate) : ''}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                      textScaleFactor: 1.0,
                                    ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: receivePaymentIndex == index
                              ? Center(
                                  child: CommonLoader(),
                                )
                              : InkWell(
                                  onTap: () {
                                    showReceivePaymentDialog(item, index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    color: Colors.blue[700],
                                    child: Center(
                                        child: Text(
                                      'Receive Payment',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      textScaleFactor: 1.0,
                                    )),
                                  ),
                                ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  _showRequestTypePicker() {
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
                          searchController.clear();
                          setState(() {
                            selectedPg = pgList[selectedIndex];
                          });
                          getPGTenantList(selectedPg.id, '', '1');
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[300],
                      itemExtent: 40,
                      children: List<Widget>.generate(pgList.length, (index) {
                        return Center(
                          child: Text(
                            "${pgList[index].name}",
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

  showExitDialog(Datum item, int index) {
    exitReasonController.clear();
    exitDateController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, stateSetter) {
              return AlertDialog(
                title: Center(
                    child: Text(
                  'Exit Tenant',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                )),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LabelText("Exit On"),
                    InkWell(
                      onTap: () {
                        DateTime joinDate = item.memberSince;
                        showDatePicker(joinDate, stateSetter);
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: exitDateController,
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          hintText: 'Tap to pic date',
                        ),
                        // controller: _roomNoController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    LabelText("Reason"),
                    TextFormField(
                      controller: exitReasonController,
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        hintText: 'Reason',
                      ),
                      // controller: _roomNoController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      maxLength: 200,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Save',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (exitDateController.text.isEmpty) {
                        return;
                      }
                      Navigator.pop(context);

                      exitTenant(index, selectedPg.id, pgTenantList[index].id,
                          exitDateController.text, exitReasonController.text);
                    },
                  )
                ],
              );
            },
          );
        });
  }

  showDatePicker(DateTime joinDate, StateSetter stateSetter) {
    DatePicker.showDatePicker(
      context,
      pickerMode: DateTimePickerMode.date,
      dateFormat: 'dd-MMM-yyyy',
      initialDateTime: DateTime.now(),
      minDateTime: joinDate,
      onConfirm: (DateTime dateTime, List<int> selectedIndex) {
        exitDate = dateTime;
        exitDateController.text = DateFormat('dd-MMM-yyyy').format(dateTime);
        stateSetter(() {});
      },
    );
  }

  showReceivePaymentDialog(Datum item, int index) {
    receivePaymentModel = ReceivePaymentModel();
    receivePaymentModel.tenantId = item.id;
    receivePaymentModel.propertyId = selectedPg.id;
    receivePaymentModel.paymentMode = '1';
    amountDueCnt.text = item.totalDue;
    remarkCnt.clear();
    amountPaidCnt.clear();
    tranReferenceCnt.clear();
    selectedPaymentMode = null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, stateSetter) {
            receivePaymentSetter = stateSetter;
            return AlertDialog(
              title: Text(
                'Receive Payment',
                style: TextStyle(
                    color: Colors.blue[400], fontWeight: FontWeight.w800),
              ),
              content: Container(
                width: double.maxFinite,
                child: Form(
                  key: _keyReceivePaymentForm,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      LabelTextAstric('Payment Mode'),
                      Card(
                        color: Colors.grey[300],
                        child: InkWell(
                          onTap: () {
                            _showPaymentModePicker();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  selectedPaymentMode != null
                                      ? selectedPaymentMode.name
                                      : 'Select Payment Mode',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                  textScaleFactor: 1.0,
                                )),
                                Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      LabelText('Amount Due'),
                      TextFormField(
                        enabled: false,
                        controller: amountDueCnt,
                        decoration: InputDecoration(
                          hintText: '',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      LabelTextAstric('Amount Paid'),
                      TextFormField(
                        controller: amountPaidCnt,
                        decoration: InputDecoration(
                          hintText: '',
                        ),
                        validator: receivePaymentModel.amountPaidValidate,
                        onSaved: (value) {
                          receivePaymentModel.amountPaid = value;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      LabelText('Transaction Reference'),
                      TextFormField(
                        controller: tranReferenceCnt,
                        decoration: InputDecoration(hintText: ''),
                        onSaved: (value) {
                          receivePaymentModel.transactionReference = value;
                        },
                      ),
                      SizedBox(height: 16),
                      LabelText('Remark'),
                      TextFormField(
                        controller: remarkCnt,
                        decoration: InputDecoration(hintText: ''),
                        onSaved: (value) {
                          receivePaymentModel.remark = value;
                        },
                        maxLength: 200,
                      ),
                      SizedBox(height: 16),
                      LabelText('Payment Proof'),
                      SizedBox(height: 8),
                      receivePaymentModel.paymentProofImg != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.file(
                                      receivePaymentModel.paymentProofImg,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                          height: receivePaymentModel.paymentProofImg != null
                              ? 8
                              : 0),
                      AttachmentView(
                        onPressed: () {
                          _showImagePicker();
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.blue[600],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                                textScaleFactor: 1.0,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.blue[600])),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: FlatButton(
                              color: Colors.blue[600],
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                                textScaleFactor: 1.0,
                              ),
                              onPressed: () {
                                if (_keyReceivePaymentForm.currentState
                                    .validate()) {
                                  _keyReceivePaymentForm.currentState.save();
                                  Navigator.of(context).pop();
                                  onClickSaveReceivePayment(index);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.blue[600])),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _showPaymentModePicker() {
    selectedPaymentMode = null;
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
                          selectedPaymentMode =
                              paymentModesListResponse.modes[selectedIndex];
                          receivePaymentSetter(() {});
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[300],
                      itemExtent: 35,
                      children: List<Widget>.generate(
                          paymentModesListResponse.modes.length, (index) {
                        return Center(
                          child: Text(
                            "${paymentModesListResponse.modes[index].name}",
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

  _showImagePicker() {
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
                  checkPermission(checkCameraPermission);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  "Select from Gallery",
                  textScaleFactor: 1.0,
                ),
                onPressed: () async {
                  checkPermission(false);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  checkPermission(bool result) async {
    if (result) {
      getImage(result);
    } else {
      getImage(false);
    }
  }

  Future getImage(bool result) async {
    var _image;
    if (result) {
      _image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    if (_image != null) {
      receivePaymentSetter(() {
        receivePaymentModel.paymentProofImg = _image;
      });
    }
  }
}

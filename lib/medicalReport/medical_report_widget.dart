import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_c/medicalReport/history_balance_copy_widget.dart';
import 'package:team_c/medicalReport/medical_report_model.dart';


import 'package:http/http.dart' as http;
import 'package:team_c/auth/custom_auth/auth_util.dart';
import 'package:team_c/employepage/employepage_widget.dart';
import 'package:team_c/utils/const_api.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'medical_report_model.dart';

class MedicalReportWidget extends StatefulWidget {
  final String token;
  const MedicalReportWidget({super.key, required this.token});

  @override
  State<MedicalReportWidget> createState() => _MedicalReportWidgetState();
}

class _MedicalReportWidgetState extends State<MedicalReportWidget> {
  late MedicalReportModel _model;

  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  bool _isLoading = false;

   

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  
 final _tyoeOfClaim=['Normal Medical Fees','Urgent Medical Fees'];
 final _reason=['New','Renewal'];

  String ? _selectedValue;
    String ? _selectreasonValue;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _model = createModel(context, () => MedicalReportModel());

    _model.textController1 ??= TextEditingController();
    
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController();
    _model.textFieldFocusNode6 ??= FocusNode();

    _model.textController7 ??= TextEditingController();
    _model.textFieldFocusNode7 ??= FocusNode();

    _model.textController8 ??= TextEditingController();
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController9 ??= TextEditingController();
    _model.textFieldFocusNode9 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  
Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    
 final token = await getAuthToken();
  
  
  final String? jwt3 = token;

    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/hr/api/user_details'),
        headers: {
          'Authorization': 'Bearer $jwt3',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _employeeNameController.text = '${data['first_name']} ${data['last_name']}'?? '';
          _employeeIdController.text = data['emp_id'] ?? '';
          _emailController.text = data['email'] ?? '';
          _departmentController.text = data['department'] ?? '';
        });
      } else {
        // Handle error response
        print('Failed to fetch user details: ${response.body}');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error fetching user details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }



 Future<void> _sendAdminNotification(String email) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/hr/api/send_admin_notification'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'subject': 'Medical Application request',
        'message': 'Mediacl Reimbursement request by Employee with email $email.',
        'recipients': ['farhanabadubhai@gmail.com'],
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medical request sent successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      print('Admin notification sent successfully');
    } else {
      print('Failed to send admin notification: ${response.body}');
    }
  }

  Future<void> _sendMedicalReimbursementRequest() async {
  // Validate the form fields before proceeding
  if (_formKey.currentState!.validate()) {
    


 final token = await getAuthToken();
  
  
  final String? jwt3 = token;

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/hr/api/medical-reimbursement'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwt3',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'username': _employeeNameController.text,
          'emp_id': _employeeIdController.text,
          'email': _emailController.text,
          'group': _model.textController4.text,
          'department': _departmentController.text,
          'medicalreimbursement_reason': _selectreasonValue,
          'type_of_claim': _selectedValue,
          'amount_aed': _model.textController8.text,
          'medicalReimbursement_comments': _model.textController9.text,
        }),
      );

      if (response.statusCode == 200) {
        await _sendAdminNotification(_emailController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Medical reimbursement request applied successfully',
              style: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
        print('Medical reimbursement request successful');

        setState(() {
          _model.textController1?.clear();
          _model.textController2?.clear();
          _model.textController3?.clear();
          _model.textController4?.clear();
          _model.textController5?.clear();
          _selectedValue = null;
          _selectreasonValue = null;
          _model.textController8?.clear();
          _model.textController9?.clear();
        });
      } else {
        // Request failed
        print('Failed to submit medical reimbursement request: ${response.body}');
        // Handle error cases
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to submit medical reimbursement request. Please try again.',
              style: TextStyle(color: Colors.red),
            ),
            duration: Duration(milliseconds: 4000),
          ),
        );
      }
    } catch (e) {
      // Exception occurred
      print('Exception occurred: $e');
      // Handle exception cases
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An error occurred. Please try again later.',
            style: TextStyle(color: Colors.red),
          ),
          duration: Duration(milliseconds: 4000),
        ),
      );
    }
  } else {
    // Display a message if form validation fails
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all required fields correctly.'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).oxfordBlue,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 40,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () async {

              final token=await getAuthToken();
            if (token != null) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployepageWidget(token: token),
                                  ),
                                );
                 }
               },
        ),
             
          title: Text(
            'Medical Reimbursement',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 0,
                ),
          ),
          actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryBalanceCopyWidget()),
              );

            },
            icon: const Icon(Icons.more_vert),
            tooltip: 'History',
          ),
        ],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(12),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 12, 0.0),
                        child: Text(
                          'Medical Reimbursement Report-Application',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ),
                      // Generated code for this Column Widget...
                      Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: Text(
                          'Employee Name',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 12, 0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Icon(
                                Icons.person,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 18,
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  _employeeNameController.text,
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                      Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: Text(
                          'Employee Id',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 12, 0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: FaIcon(
                                  FontAwesomeIcons.idBadge,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  size: 18,
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding:
                                      const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                  child: Text(
                                   _employeeIdController.text,
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: Text(
                          'Email Address ',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 12, 0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Icon(
                                Icons.email,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 18,
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  _emailController.text,
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                       Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: Text(
                          'Business Group',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 12, 0),
                      child: TextFormField(
                        controller: _model.textController4,
                        focusNode: _model.textFieldFocusNode4,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          hintText: 'Business Group',
                           hintStyle: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          prefixIcon: Icon(
                            Icons.article_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 18,
                          ),
                        ),
                       style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Business Group is required';
                                }
                                return null;
                              },
                        textAlign: TextAlign.start,
                       
                      ),
                    ),
                  
                      
                     Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: Text(
                          'Department ',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 12, 0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: FaIcon(
                                  FontAwesomeIcons.briefcase,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  size: 18,
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding:
                                      const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                  child: Text(
                                     _departmentController.text,
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                  
                    Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                        child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '*',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context).fireEngineRed,
                                            fontSize: 16,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                     TextSpan(
                                      text: 'Reason',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                      ),
                                ),
                              )
                      ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 12, 0.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectreasonValue,
                        items: _reason.map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        ).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectreasonValue = newValue;
                            // You can add additional logic here if needed
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Select Reason',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                              ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          prefixIcon: Icon(
                            Icons.article_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 18,
                          ),
                        ),
                        style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                        // textAlign: TextAlign.start,
                        validator: (value) {
                          return null;
                        
                          // Add your validation logic here if needed
                        },
                      ),
                    ),
                  
                  
                  
                   
                    
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                        child: RichText(textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(text: '*',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',color: FlutterFlowTheme.of(context).fireEngineRed,fontSize: 16,letterSpacing: 0,fontWeight: FontWeight.bold,),),
                                 TextSpan(text: 'Type of Medical Claim',style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),)
                              ],
                              style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Readex Pro',letterSpacing: 0,
                            ),
                          ),
                          )
                      ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 12, 0.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedValue,
                        items: _tyoeOfClaim.map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        ).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedValue = newValue;
                            // You can add additional logic here if needed
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Select Type of Medical Claim',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                              ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          prefixIcon: Icon(
                            Icons.medical_information,
                                     color: FlutterFlowTheme.of(context).secondaryText,
                            size: 18,
                          ),
                        ),
                        style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                        // textAlign: TextAlign.start,
                        validator: (value) {
                          return null;
                        
                          // Add your validation logic here if needed
                        },
                      ),
                    ),
                  
                      
                      
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child:  RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '*',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context).fireEngineRed,
                                            fontSize: 16,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                     TextSpan(
                                      text: 'Amount(AED)',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                      ),
                                ),
                              )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 12, 0),
                      child: TextFormField(
                        controller: _model.textController8,
                        focusNode: _model.textFieldFocusNode8,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          hintText: 'Amount(AED)',
                           hintStyle: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          prefixIcon: Icon(
                            Icons.money,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 18,
                          ),
                        ),
                       style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Amount(AED) is required';
                                }
                                return null;
                              },
                        textAlign: TextAlign.start,
                        
                      ),
                    ),
                  
                  
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: Text(
                          'Comment',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0,
                                fontSize: 12,
                                color: Colors.black
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 12, 0),
                      child: TextFormField(
                        controller: _model.textController9,
                        focusNode: _model.textFieldFocusNode9,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                          hintText: 'Comment',
                            hintStyle: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          prefixIcon: Icon(
                            Icons.article_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 18,
                          ),
                        ),
                       style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0,
                                        fontSize:14,
                                      ),
                            validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Comment is required';
                                }
                                return null;
                              },
                        textAlign: TextAlign.start,
                       
                      ),
                    ),
                  
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              FFButtonWidget(
                                onPressed: _sendMedicalReimbursementRequest,
                                text: 'Apply',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context).oxfordBlue,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        letterSpacing: 0,
                                      ),
                                  elevation: 3,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ), 
                                loadingIndicatorColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                  
                  
                      ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
    );
  }
}

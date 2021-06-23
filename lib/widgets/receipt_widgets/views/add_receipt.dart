import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/utils/commons.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';
import 'package:rt_gem/utils/responsive.dart';
import 'package:rt_gem/widgets/snackbar.dart';

class AddReceipt extends StatefulWidget {
  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {

  final GlobalKey<FormState> _addReceiptFormKey = new GlobalKey<FormState>();
  late final GlobalKey<FormFieldState> _key;
  var dropdownValue;
  var newContact;
  var month;
  final TextEditingController _controllerDate = new TextEditingController();
  final TextEditingController _controllerExpiration  = new TextEditingController();
  final TextEditingController _amountController  = new TextEditingController();
  final TextEditingController _controllerQuantity  = new TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  late TransactionsProvider transactions;

  DateTime _selectedDate = DateTime.now();


  late Animation _arrowAnimation;
  late AnimationController _arrowAnimationController;
  late AnimationController _animationController;
  late Animation _animation;
  // final TextEditingController _controller = new TextEditingController();
  bool expirationType = false;
  // TextEditingController _controllerone = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  Future<Null> _chooseDate(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controllerDate.text = dateFormatS.format(result);
    });
  }

  Future<Null> _chooseDateExpiration(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2100));

    if (result == null) return;

    setState(() {
      _controllerExpiration.text = dateFormatS.format(result);
    });
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  DateTime? convertToDate(String input) {
    try {
      var d = dateFormatS.parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    CustomSnackBar(context, Text(message),Colors.green);
  }

  void _submitForm() {
    final FormState? form = _addReceiptFormKey.currentState;

    if (form!.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event
    }
  }

  @override
  void initState() {
    super.initState();
    transactions = Provider.of<TransactionsProvider>(context, listen: false);
    _controllerDate.text = dateFormatS.format(DateTime.now());
    //_controllerone.text = "0";
  }

  void chooseDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Receipts"),
      ),
      body:  Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 800 ,
          child: SingleChildScrollView(
            child: Form(
              key: _addReceiptFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 7.5),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        //icon: const Icon(Icons.person),
                        hintText: 'Enter Receipt Name',
                        labelText: 'Receipt Name',
                      ),
                      inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                      validator: (val) =>
                      val!.isEmpty ? 'Name is required' : null,
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 7.5),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        //icon: const Icon(Icons.person),
                        hintText: 'Enter Amount',
                        labelText: 'Amount',
                      ),
                      inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                      validator: (val) =>
                      val!.isEmpty ? 'Amount is required' : null,
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      //focusNode: _titleFocusNode,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                    child: DropdownButtonFormField<String>(
                      //key: _formKey,
                      value: dropdownValue,
                      decoration: InputDecoration(
                          filled: false,
                          labelText: 'Category',
                          labelStyle: new TextStyle(color: Colors.green),
                          enabledBorder: new OutlineInputBorder(
                            //borderRadius: new BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            //borderRadius: new BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          )),
                      items: receiptCategories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      // items: _countries.map((country) => DropdownMenuItem<String>(value: country.countryCode, child: Text(country.name))).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                    child: new TextFormField(
                      onTap: () {
                        // Below line stops keyboard from appearing
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _chooseDate(
                            context, _controllerDate.text);
                        // Show Date Picker Here
                      },
                      decoration: new InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          //icon: const Icon(Icons.calendar_today),
                          hintText: 'Select Date',
                          labelText: 'Date',
                          suffixIcon: Icon(Icons.calendar_today_outlined)),
                      controller: _controllerDate,
                      keyboardType: TextInputType.datetime,
                      validator: (val) =>
                      val!.isEmpty ? 'Date is required' : null,
                      //validator: (val) =>
                      //isValidDob(val!) ? null : 'Not a valid date',
                      //onSaved: (val) => newContact.dob = convertToDate(val!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,30,8,8),
                    child: InkWell(
                      onTap: () async {
                        ///ToDo: add form validations
                        _submitForm();
                        // Database.addReceipt(
                        //   id: DateTime.now().toString(),
                        //   receiptName: _titleController.text,
                        //   amount: int.parse(_amountController.text),
                        //   category: dropdownValue,
                        //   addedDate: _controllerDate.text,
                        // );

                        DateFormat dateForm = DateFormat("dd/MM/yyyy");
                        convertToDate(_controllerDate.text);

                        try {
                          transactions.addTransactions(
                            Receipt(
                              id: DateTime.now().toString(),
                              title: _titleController.text,
                              amount: int.parse(_amountController.text),
                              date: convertToDate(_controllerDate.text),
                              category: dropdownValue,
                            ),
                          );

                          _addReceiptFormKey.currentState!.reset();
                          _titleController.clear();
                          _controllerDate.clear();

                          setState(() {
                            dropdownValue = null;
                          });

                          CustomSnackBar(context, const Text('Receipt Added'),Colors.green);
                        } on Exception catch (exception) {
                          CustomSnackBar(context, const Text('Exception'),Colors.red);
                        } catch (error) {
                          CustomSnackBar(context, const Text('Error'),Colors.red);

                        }


                        //

                      },
                      child: Container(
                        width: Responsive.deviceWidth(65, context),
                        height: Responsive.deviceHeight(7, context),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal,
                              Colors.blue,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Add Item',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),



      /*Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),*/
    );
  }
}
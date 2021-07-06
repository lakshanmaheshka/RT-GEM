import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var dropdownValue;
  var newContact;
  var month;
  final TextEditingController _controllerDate = new TextEditingController();
  final TextEditingController _amountController  = new TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  late TransactionsProvider transactions;

  bool expirationType = false;
  final FocusNode _titleFocusNode = FocusNode();

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
        lastDate: new DateTime(2100));

    if (result == null) return;

    setState(() {
      _controllerDate.text = dateFormatS.format(result);
    });
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
                        hintText: 'Enter Amount',
                        labelText: 'Amount',
                      ),
                      inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                      validator: (val) =>
                      val!.isEmpty ? 'Amount is required' : null,
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                    child: DropdownButtonFormField<String>(
                      value: dropdownValue,
                      decoration: InputDecoration(
                          filled: false,
                          labelText: 'Category',
                          labelStyle: new TextStyle(color: Colors.green),
                          enabledBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: new OutlineInputBorder(
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
                          hintText: 'Select Date',
                          labelText: 'Date',
                          suffixIcon: Icon(Icons.calendar_today_outlined)),
                      controller: _controllerDate,
                      keyboardType: TextInputType.datetime,
                      validator: (val) =>
                      val!.isEmpty ? 'Date is required' : null,

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,30,8,8),
                    child: InkWell(
                      onTap: () async {
                        _submitForm();
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
                          _amountController.clear();

                          setState(() {
                            dropdownValue = null;
                          });

                          CustomSnackBar(context, const Text('Receipt Added'),Colors.green);
                        } on Exception catch (exception) {
                          print("Exception while adding receipt : $exception");
                          CustomSnackBar(context, const Text('Exception'),Colors.red);
                        } catch (error) {
                          CustomSnackBar(context, const Text('Error'),Colors.red);
                        }


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
    );
  }
}
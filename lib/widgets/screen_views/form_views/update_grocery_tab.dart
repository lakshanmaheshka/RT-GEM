import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rt_gem/utils/constants_categories.dart';
import 'package:rt_gem/utils/database.dart';
import 'package:rt_gem/widgets/number_input.dart';
import 'package:rt_gem/widgets/responsive.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:rt_gem/widgets/snackbar.dart';

class UpdateGroceryForm extends StatefulWidget {
  final String currentProductName;
  final String currentCategory;
  final String currentQuantity;
  final String currentItemMfg;
  final String currentItemExp;
  final String documentId;

  const UpdateGroceryForm({
    required this.currentProductName,
    required this.currentCategory,
    required this.currentQuantity,
    required this.currentItemMfg,
    required this.currentItemExp,
    required this.documentId,
    Key? key,
  }) : super(key: key);

  @override
  _UpdateGroceryFormState createState() => _UpdateGroceryFormState();
}

class _UpdateGroceryFormState extends State<UpdateGroceryForm>
    with TickerProviderStateMixin {
  //final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var dropdownValue;
  var newContact;
  var month;
  late TextEditingController _controllerManufacture =
      new TextEditingController();
  late TextEditingController _controllerExpiration =
      new TextEditingController();
  late TextEditingController _controllerQuantity = new TextEditingController();
  late Animation _arrowAnimation;
  late AnimationController _arrowAnimationController;
  late AnimationController _animationController;
  late Animation _animation;
  final TextEditingController _controller = new TextEditingController();
  bool expirationType = false;
  TextEditingController _controllerone = TextEditingController();
  late TextEditingController _titleController = TextEditingController();

  Future<Null> _chooseDateManufacture(
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
      _controllerManufacture.text = new DateFormat.yMd().format(result);
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
      _controllerExpiration.text = new DateFormat.yMd().format(result);
    });
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  DateTime? convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    CustomSnackBar(context, Text(message));
  }

  void _submitForm() {
    final FormState? form = _formKey.currentState;

    if (form!.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      // print('Form save called, newContact is now up to date...');
      // print('Name: ${newContact.name}');
      // print('Dob: ${newContact.dob}');
      // print('Phone: ${newContact.phone}');
      // print('Email: ${newContact.email}');
      // print('Favorite Color: ${newContact.favoriteColor}');
      // print('========================================');
      // print('Submitting to back end...');
      // var contactService = new ContactService();
      // contactService.createContact(newContact).then((value) =>
      //     showMessage('New contact created for ${value.name}!', Colors.blue));
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = IntTween(begin: 35, end: 450).animate(_animationController);
    _animation.addListener(() => setState(() {}));
    _arrowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _arrowAnimation =
        Tween(begin: 0.0, end: pi).animate(_arrowAnimationController);
    _controllerone.text = "0";
    _titleController = TextEditingController(
      text: widget.currentProductName,
    );
    _controllerManufacture = TextEditingController(
      text: widget.currentItemMfg,
    );
    _controllerExpiration = TextEditingController(
      text: widget.currentItemExp,
    );
    _controllerQuantity = TextEditingController(
      text: widget.currentItemExp,
    );

    dropdownValue = widget.currentCategory;
  }

  @override
  void dispose() {
    super.dispose();
    _arrowAnimationController.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          child: Form(
            key: _formKey,
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
                      hintText: 'Enter Product Name',
                      labelText: 'Product Name',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) =>
                        val!.isEmpty ? 'Name is required' : null,
                    controller: _titleController,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                        child: NumberInputWithIncrementDecrement(
                          controller: TextEditingController(),
                          suffixText: "Item/s",
                          enabled: expirationType,
                          labelText: "Quantity",
                          prefixIcon: Icons.add_to_photos,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 7.5, 15, 7.5),
                        child: DropdownButtonFormField<String>(
                          value: dropdownValue,
                          decoration: InputDecoration(
                              filled: false,
                              labelText: 'Category',
                              labelStyle: new TextStyle(color: Colors.green),
                              enabledBorder: new OutlineInputBorder(
                                //borderRadius: new BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: Colors.pinkAccent),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                //borderRadius: new BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              )),
                          items: groceryCategories.map<DropdownMenuItem<String>>((String value) {
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
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                  child: new Expanded(
                      child: new TextFormField(
                    onTap: () {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _chooseDateManufacture(
                          context, _controllerManufacture.text);
                      // Show Date Picker Here
                    },
                    decoration: new InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        //icon: const Icon(Icons.calendar_today),
                        hintText: 'Select Manufactured Date',
                        labelText: 'Manufactured Date',
                        suffixIcon: Icon(Icons.calendar_today_outlined)),
                    controller: _controllerManufacture,
                    keyboardType: TextInputType.datetime,
                    validator: (val) =>
                        val!.isEmpty ? 'Manufactured Date is required' : null,
                    //validator: (val) =>
                    //isValidDob(val!) ? null : 'Not a valid date',
                    //onSaved: (val) => newContact.dob = convertToDate(val!),
                  )),
                ),
                Row(
                  children: [
                    new Expanded(
                        flex: 100,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 7.5, 0, 0),
                          child: new TextFormField(
                            enabled: !expirationType,
                            onTap: () {
                              // Below line stops keyboard from appearing
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _chooseDateExpiration(
                                  context, _controllerExpiration.text);
                              // Show Date Picker Here
                            },
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              //icon: const Icon(Icons.calendar_today),
                              hintText: 'Select Expiration Date',
                              labelText: 'Expiration Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: _controllerExpiration,
                            keyboardType: TextInputType.datetime,
                            validator: (val) => val!.isEmpty
                                ? 'Expiration Date is required'
                                : null,
                            //validator: (val) =>
                            //isValidDob(val!) ? null : 'Not a valid date',
                            //onSaved: (val) => newContact.dob = convertToDate(val!),
                          ),
                        )),

                    // Column(
                    //   children: [
                    //     Container(
                    //       height: 20,
                    //       child: VerticalDivider(color: Colors.black),
                    //     ),
                    //     Text("OR"),
                    //     Container(
                    //       height: 20,
                    //       child: VerticalDivider(color: Colors.black),
                    //     ),
                    //   ],
                    // ),

                    Container(
                      child: AnimatedBuilder(
                        animation: _arrowAnimationController,
                        builder: (context, child) => Transform.rotate(
                          angle: _arrowAnimation.value,
                          child: IconButton(
                              splashRadius: 20,
                              iconSize: 50,
                              onPressed: () {
                                expirationType = !expirationType;
                                if (_animationController.value == 0.0) {
                                  _animationController.forward();
                                } else {
                                  _animationController.reverse();
                                }
                                _arrowAnimationController.isCompleted
                                    ? _arrowAnimationController.reverse()
                                    : _arrowAnimationController.forward();
                              },
                              icon: Icon(
                                Icons.arrow_left_sharp,
                                //size: 50.0,
                                color: Colors.black,
                              )),
                        ),
                        //  child:
                      ),
                    ),

                    Expanded(
                      flex: _animation.value,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 7.5, 15, 0),
                        child: NumberInputWithIncrementDecrement(
                          controller: TextEditingController(),
                          suffixText: expirationType == true ? "Month/s" : "",
                          enabled: expirationType,
                          labelText: "Best Before",
                          prefixIcon: Icons.access_time,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 7.5, 2, 0),
                        child: InkWell(
                          onTap: () async {
                            Database.updateGroceries(
                                docId: widget.documentId,
                                productName: _titleController.text,
                                quantity: _controllerQuantity.text,
                                category: dropdownValue,
                                manufacturedDate: _controllerManufacture.text,
                                expiryDate: _controllerExpiration.text
                                //description: _descriptionController.text,
                                );

                            //_titleController.clear();

                            CustomSnackBar(
                                context, const Text('Grocery Updated'));
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
                              borderRadius: BorderRadius.circular(15),
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
                                'Update Grocery',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 7.5, 4, 0),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              //_isDeleting = true;
                            });

                            Database.deleteGrocery(
                              docId: widget.documentId,
                            );

                            CustomSnackBar(
                                context, const Text('Grocery Deleted'));

                            setState(() {
                              //_isDeleting = false;
                            });

                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: Responsive.deviceWidth(6, context),
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
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Center(
                                child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 7.5, 15, 0),
                        child: GestureDetector(
                          onTap: () async {
                            Database.markConsumedGroceries(
                              docId: widget.documentId,
                            );

                            _titleController.clear();

                            CustomSnackBar(
                                context, const Text('Grocery Updated'));
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
                              borderRadius: BorderRadius.circular(15),
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
                                'Mark Consumed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

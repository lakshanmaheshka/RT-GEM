import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rt_gem/utils/commons.dart';
import 'package:rt_gem/utils/database.dart';
import 'package:rt_gem/utils/receipt_models/global_data.dart';
import 'package:rt_gem/widgets/isApp/views/add_grocery.dart';
import 'package:rt_gem/widgets/isApp/views/scan_date_camera_screen.dart';
import 'package:rt_gem/widgets/number_input.dart';
import 'package:rt_gem/utils/responsive.dart';
import 'dart:async';
import 'package:rt_gem/widgets/snackbar.dart';

class AddGroceryForm extends StatefulWidget {
  const AddGroceryForm({
    Key? key,
  }) : super(key: key);

  @override
  _AddGroceryFormState createState() => _AddGroceryFormState();
}

class _AddGroceryFormState extends State<AddGroceryForm>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _addGroceryFormKey = new GlobalKey<FormState>();
  var dropdownValue;
  var newContact;
  var month;
  final TextEditingController _controllerManufacture = new TextEditingController();
  final TextEditingController _controllerExpiration  = new TextEditingController();
  final TextEditingController _controllerBestBefore  = new TextEditingController();
  final TextEditingController _controllerQuantity  = new TextEditingController();
  final TextEditingController _titleController = TextEditingController();



  late Animation _arrowAnimation;
  late AnimationController _arrowAnimationController;
  late AnimationController _animationController;
  late Animation _animation;
  bool isExpirationTypeBestBefore = false;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  Future<Null> _chooseDateManufacture(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);


    var result = await showDatePicker(
        context: context,
        locale: const Locale('en', 'GB'),
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controllerManufacture.text = dateFormatS.format(result);
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



  void showMessage(String message, [MaterialColor color = Colors.red]) {
    CustomSnackBar(context, Text(message),Colors.green);
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
  }

  @override
  void dispose() {
    super.dispose();
    _arrowAnimationController.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Container(
        child: Form(
          key: _addGroceryFormKey,
          child: SingleChildScrollView(
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
                      hintText: 'Enter Product Name',
                      labelText: 'Product Name',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) =>
                        val!.isEmpty ? 'Name is required' : null,
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 50,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                        child: NumberInputWithIncrementDecrement(
                          controller: _controllerQuantity,
                          suffixText: "Item/s",
                          enabled: true,
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
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: new OutlineInputBorder(
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


                kIsWeb ?

                Container()
                    :
                Platform.isAndroid ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                  child: InkWell(
                    onTap:  () async {


                      try {
                        WidgetsFlutterBinding.ensureInitialized();
                        cameras = await availableCameras();
                      } on CameraException catch (e) {
                        print(e);
                      }
                      final value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScanDateCameraScreen()),
                      );

                      setState(() {
                        _controllerManufacture.text = Globaldata.mfdString!;
                        _controllerExpiration.text = Globaldata.expString!;
                      });

                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
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
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.camera_alt, color: Colors.white,),
                          ),

                          Text(
                            'Scan Dates',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ) : Container(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                  child: new TextFormField(
                    onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _chooseDateManufacture(
                      context, _controllerManufacture.text);
                    },
                    decoration: new InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Select Manufactured Date',
                    labelText: 'Manufactured Date',
                    suffixIcon: Icon(Icons.calendar_today_outlined)),
                    controller: _controllerManufacture,
                    keyboardType: TextInputType.datetime,
                    validator: (val) =>
                    val!.isEmpty ? 'Manufactured Date is required' : null,
                  ),
                ),
                Row(
                  children: [
                    new Expanded(
                        flex: 100,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 7.5, 0, 0),
                          child: new TextFormField(
                            enabled: !isExpirationTypeBestBefore,
                            onTap: () {
                              // Below line stops keyboard from appearing
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _chooseDateExpiration(
                                  context, _controllerExpiration.text);
                            },
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintText: 'Select Expiration Date',
                              labelText: 'Expiration Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: _controllerExpiration,
                            keyboardType: TextInputType.datetime,
                            validator: (val) => val!.isEmpty
                                ? 'Expiration Date is required'
                                : null,
                          ),
                        )),
                    Container(
                      child: AnimatedBuilder(
                        animation: _arrowAnimationController,
                        builder: (context, child) => Transform.rotate(
                          angle: _arrowAnimation.value,
                          child: IconButton(
                              splashRadius: 20,
                              iconSize: 50,
                              onPressed: () {
                                _titleFocusNode.unfocus();

                                isExpirationTypeBestBefore = !isExpirationTypeBestBefore;
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
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: _animation.value,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 7.5, 15, 0),
                        child: NumberInputWithIncrementDecrement(
                          controller: _controllerBestBefore,
                          suffixText: isExpirationTypeBestBefore == true ? "Month/s" : "",
                          enabled: isExpirationTypeBestBefore,
                          labelText: "Best Before",
                          prefixIcon: Icons.access_time,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,45,15,8),
                  child: InkWell(
                    onTap: ()  {
                      setState(() {
                        Globaldata.stateChanged.value =  !Globaldata.stateChanged.value;
                      });

                      if(_titleController.text.isNotEmpty){
                        try {
                          DateTime convertDate;
                          if(isExpirationTypeBestBefore == true){
                            convertDate = convertToDate(_controllerManufacture.text)!;
                            int i = int.parse(_controllerBestBefore.text);
                            DateTime d = Jiffy(convertDate).add(months: i).dateTime;
                            String bestBeforeDate = dateFormatS.format(d);

                            Database.addGrocery(
                                productName: _titleController.text,
                                quantity: int.parse(_controllerQuantity.text),
                                category: dropdownValue,
                                manufacturedDate: convertToDate(_controllerManufacture.text)!,
                                expiryDate: convertToDate(bestBeforeDate)! );

                          } else {
                            Database.addGrocery(
                                productName: _titleController.text,
                                quantity: int.parse(_controllerQuantity.text),
                                category: dropdownValue,
                                manufacturedDate: convertToDate(_controllerManufacture.text)!,
                                expiryDate: convertToDate(_controllerExpiration.text)! );
                          }
                          CustomSnackBar(context, const Text('Grocery Added'),Colors.green);

                        } on Exception catch (exception) {
                          print("Exception while adding grocery : $exception");
                          CustomSnackBar(context, const Text('There is an exception !'),Colors.red);
                        } catch (error) {
                          CustomSnackBar(context, const Text('Error !'),Colors.red);
                        }
                      }else{
                        CustomSnackBar(context, const Text('Title is Empty !'),Colors.red);
                      }

                      _addGroceryFormKey.currentState!.reset();
                      _titleController.clear();
                      _controllerExpiration.clear();
                      _controllerManufacture.clear();
                      _controllerQuantity.text = "1";
                      _controllerBestBefore.text = "1";

                      setState(() {
                        dropdownValue = null;
                      });

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
                        borderRadius: BorderRadius.circular(6),
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
    );
  }
}

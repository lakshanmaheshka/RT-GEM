import 'package:flutter/material.dart';
import 'package:rt_gem/widgets/responsive.dart';

class TabOne extends StatefulWidget {
  const TabOne({
    Key? key,
  }) :  super(key: key);

  @override
  _TabOneState createState() => _TabOneState();
}

class _TabOneState extends State<TabOne> {
  final _formKey = GlobalKey<FormState>();
  var dropdownValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  // enabledBorder: new OutlineInputBorder(
                  //   //borderRadius: new BorderRadius.circular(25.0),
                  //   borderSide:  BorderSide(color: Colors.pinkAccent ),
                  //
                  // ),
                  focusedBorder: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(25.0),
                    borderSide:  BorderSide(color: Colors.cyan ),

                  ),
                  border: OutlineInputBorder(borderSide:  BorderSide(color: Colors.blue ),),
                  labelText: 'Product Name',
                  hintText: 'Enter Product Name',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(0.0),
              child: DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration: InputDecoration(
                    filled: false,
                    labelText: 'Country',
                    labelStyle: new TextStyle(color: Colors.green),
                    enabledBorder: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide:  BorderSide(color: Colors.pinkAccent ),

                    ),
                    focusedBorder: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide:  BorderSide(color: Colors.cyan ),

                    ),
                    border: OutlineInputBorder(borderSide:  BorderSide(color: Colors.blue ),)
                ),
                items: <String>['One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
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
                },),
            ),



            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Fruit',
                hintText: 'Selection',
                //labelStyle: Theme.of(context).primaryTextTheme.caption.copyWith(color: Colors.black),
                border: const OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child:
                DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['One', 'Two', 'Free', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              /*  DropdownButton(
                  isExpanded: true,
                  isDense: true, // Reduces the dropdowns height by +/- 50%
                  icon: Icon(Icons.keyboard_arrow_down),
                  value: _selectedFruit,
                  items: _fruits.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (selectedItem) => setState(() => _selectedFruit = selectedItem,
                  ),
                ),*/
              ),
            ),



        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>['One', 'Two', 'Free', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child:

                Container(
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
                      'Press',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
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
    );
  }
}
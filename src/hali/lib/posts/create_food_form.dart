
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/config/application.dart';
import 'package:hali/config/routes.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:intl/intl.dart';
import 'package:select_dialog/select_dialog.dart';

class CreateFoodForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return CreateFoodFormState();
  }
}

class CreateFoodFormState extends State<CreateFoodForm> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  String listFor5Days = "";
  List<String> listOfDays;

  List<String> _renderListingDays() {
    List<String> chidrens = [];
    for (var i = 5; i < 29; i++) {
      chidrens.add("$i days");
    }
    return chidrens;
  }

  _showListDays() {
    listOfDays = _renderListingDays();

    SelectDialog.showModal<String>(
      context,
      searchBoxDecoration: InputDecoration(
        hintText: "Search"
      ),
      label: "List for ",
      selectedValue: listFor5Days,
      items: listOfDays,
      onChange: (String selected) {
        setState(() {
          listFor5Days = selected;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    listOfDays = _renderListingDays();
    listFor5Days = listOfDays[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                initialValue: {
                  'title': '',
                  'date': DateTime.now(),
                  'accept_terms': false,
                },
                autovalidate: true,
                child: Column(
                  children: <Widget>[

                    FormBuilderTextField(
                      attribute: "title",
                      decoration: InputDecoration(labelText: "Title"),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "description",
                      decoration: InputDecoration(labelText: "Description", hintText: "e.g. Quality, quanlity, use by date"),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    FormBuilderDateTimePicker(
                      attribute: "pickupTime",
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      decoration:
                      InputDecoration(labelText: "Pick up time"),
                      validators: [
                        FormBuilderValidators.required(errorText: "You must choose pick up time."),
                      ],
                    ),

                    FormBuilderDateTimePicker(
                      attribute: "startDate",
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      decoration:
                      InputDecoration(labelText: "Start date"),
                      validators: [
                        FormBuilderValidators.required(errorText: "You must choose start date."),
                      ],
                    ),

                    FormBuilderDateTimePicker(
                      attribute: "endDate",
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      decoration:
                      InputDecoration(labelText: "End date"),
                      validators: [
                        FormBuilderValidators.required(errorText: "You must be choose end date."),
                      ],
                    ),

                    // list for pickup location
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                      child: new Row(
                        children: <Widget>[
                          Icon(Icons.location_on, size: 20, color: Colors.grey),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                            child: Text("Pickup location is set ", style: Styles.getRegularStyle(12, Colors.grey),),
                          ),
                          GestureDetector(
                            child: Text("Change", style: Styles.getRegularStyle(12, Colors.red),  textAlign: TextAlign.left),
                            onTap: _presentLocationScreen,
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: ColorUtils.hexToColor(colorD92c27),
                  borderRadius: BorderRadius.circular(8)
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        child: Text("Submit"),

                        textColor: Colors.white,
                        onPressed: () {
                          if (_fbKey.currentState.saveAndValidate()) {
                            print(_fbKey.currentState.value);
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void _presentLocationScreen() {
      Application.router.navigateTo(context, Routes.locationScreen, transition: TransitionType.fadeIn);
  }
}


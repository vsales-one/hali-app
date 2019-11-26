
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CreateFoodForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return CreateFoodFormState();
  }
}

class CreateFoodFormState extends State<CreateFoodForm> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  List<DropdownMenuItem<String>> _renderListingDays() {
    List<DropdownMenuItem<String>> chidrens = [];
    for (var i = 5; i < 29; i++) {
      chidrens.add(new DropdownMenuItem(child: Text("$i days"), value: "$i days",));
    }
    return chidrens;
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
                        FormBuilderValidators.requiredTrue(
                          errorText:
                          "You must choose pick up time.",
                        ),
                      ],
                    ),

                    FormBuilderDropdown(
                      attribute: "listTime",
                      decoration: InputDecoration(labelText: "List for 5 days."),
                      // initialValue: 'Male',
                      hint: Text('5 days'),
                      initialValue: '5 days',
                      validators: [FormBuilderValidators.required()],
                      items: _renderListingDays()
                          .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text("$gender")
                      )).toList(),
                    ),

                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey.currentState.value);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}


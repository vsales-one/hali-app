
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/config/application.dart';
import 'package:hali/config/routes.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/utils/alert_helper.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:hali/utils/date_utils.dart';
import 'package:intl/intl.dart';
import 'bloc/index.dart';

class CreateFoodForm extends StatefulWidget {

final File imageCover;
final int _categoryId;

  const CreateFoodForm(this.imageCover, this._categoryId);

  @override
  State<StatefulWidget> createState() {
    return CreateFoodFormState();
  }
}

class CreateFoodFormState extends State<CreateFoodForm> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  String _title = "";
  String _description = "";
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _pickup = "";
  String _lat = "";
  String _longtitude = "";

  @override
  void initState() {
    super.initState();
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
                      onChanged: (title){
                        setState(() {
                          _title = title;
                        });
                      },          
                    ),
                    FormBuilderTextField(
                      attribute: "description",
                      decoration: InputDecoration(labelText: "Description", hintText: "e.g. Quality, quanlity, use by date"),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                      onChanged: (desc) {
                        setState(() {
                          _description = desc;
                        });
                      },
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
                      onChanged: (pickup){
                        setState(() {
                          _pickup = pickup.toIso8601String();
                        });
                      },
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
                      onChanged: (startDate){
                        setState(() {
                          _startDate = startDate;
                        });
                      },
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
                      onChanged: (endDate){
                        setState(() {
                          _endDate = endDate;
                        });
                      },
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
                        onPressed: _handleCreatePost
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

  void _handleCreatePost() {
    if (_fbKey.currentState.saveAndValidate()) {
      if (widget.imageCover == null) {
        AlertHelper.showAlertError(context, "Image Cover can not empty.");
      }

      final postModel = new PostModel(
        title: _title,
        description: _description,
        pickUpTime: _pickup,
        startDate: DateUtils.dateToString(_startDate),
        endDate: DateUtils.dateToString(_endDate),
        categoryId: widget._categoryId,
        lastModifiedBy: "trung@yopmail.com",
        lastModifiedDate: DateUtils.dateToString(DateTime.now()),
        pickupAddress: "92 Nguyen Huu Canh"
      );
      BlocProvider.of<CreatePostBloc>(context).add(AddPostStartEvent(postModel: postModel, image: widget.imageCover));
    }
  }
}


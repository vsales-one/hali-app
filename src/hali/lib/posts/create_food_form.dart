
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/hali_category.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/utils/alert_helper.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:hali/utils/date_utils.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/place_picker.dart';
import 'bloc/index.dart';

class CreateFoodForm extends StatefulWidget {

final File imageCover;

  const CreateFoodForm(this.imageCover);

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
  LatLng _postLocation;
  HCategory _categorySelected;
  String _address;

  @override
  void initState() {
    super.initState();

    _categorySelected = HCategory.generated()[0];

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
              FormBuilderRadio(
                decoration: InputDecoration(labelText: 'Category'),
                attribute: "category",
                initialValue: _categorySelected.categoryName,
                validators: [FormBuilderValidators.required()],
                onChanged: (cate){
                  logger.d("did tap");
                  _categorySelected = HCategory.generated().where((e) => e.categoryName == cate).toList().first;
                },
                options: HCategory.generated()
                    .map((lang) => FormBuilderFieldOption(value: lang.categoryName))
                    .toList(growable: false),
              ),
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
                          _pickup = DateUtils.dateToString(pickup);
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

  Future _presentLocationScreen() async {
    _postLocation = new LatLng(10.7797855,106.6968249);
    LocationResult result = await Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => PlacePicker(kApiKey, displayLocation: _postLocation,)));
    _postLocation = result.latLng;
    _address = result.formattedAddress;

  }

  void _handleCreatePost() {
    if (_fbKey.currentState.saveAndValidate()) {
      if (widget.imageCover == null) {
        AlertHelper.showAlertError(context, "Image Cover can not empty.");
        return;
      }

      final postModel = new PostModel(
        title: _title,
        description: _description,
        pickUpTime: _pickup,
        startDate: DateUtils.dateToString(_startDate),
        endDate: DateUtils.dateToString(_endDate),
        categoryId: _categorySelected.id,
        lastModifiedDate: DateUtils.dateToString(DateTime.now()),
        latitude: _postLocation.latitude,
        longitude: _postLocation.longitude,
        pickupAddress: _address
      );
      BlocProvider.of<CreatePostBloc>(context).add(AddPostStartEvent(postModel: postModel, image: widget.imageCover));
    }
  }
}


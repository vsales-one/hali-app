import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/config/application.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/create_post_command.dart';
import 'package:hali/models/hali_category.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/posts/bloc/index.dart';
import 'package:hali/repositories/app_location_manager.dart';
import 'package:hali/utils/alert_helper.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:hali/utils/date_utils.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/place_picker.dart';

class CreateFoodForm extends StatefulWidget {
  final File imageCover;
  final String postImageUrl;

  const CreateFoodForm(
      {@required this.imageCover, @required this.postImageUrl});

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
  String _pickup = "Từ 9h sáng đến 5h chiều";
  LatLng _postLocation;
  HCategory _categorySelected;
  String _city;
  String _district;
  String _address = "";
  bool _isCheckingCurrentLocation = false;

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    final position = await AppLocationManager.initCurrentLocation();
    if (!mounted) {
      return;
    }

    final defaultPickupAddress = Application.currentUser?.fullAddress;

    setState(() {
      _postLocation = LatLng(position.latitude, position.longitude);
      _isCheckingCurrentLocation = false;
      _address = defaultPickupAddress;
    });
  }

  @override
  void initState() {
    super.initState();
    _categorySelected = HCategory.generated()[0];
    _initCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.isPostLocationChanged) {
          _postLocation = state.locationResult.latLng;
          _address = state.addressDto
              .streetAddress; //state.locationResult.formattedAddress;
          _district = state.addressDto.district;
          _city = state.addressDto.city;
          logger.d(">>>>>>> pickup address: $_address");
        }

        return _buildFormBody(context);
      },
    );
  }

  Widget _buildFormBody(BuildContext context) {
    if (_isCheckingCurrentLocation) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      child: Container(
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
                      FormBuilderRadio(
                        decoration: InputDecoration(),
                        attribute: "category",
                        initialValue: _categorySelected.categoryName,
                        validators: [FormBuilderValidators.required()],
                        onChanged: (cate) {
                          logger.d("did tap");
                          _categorySelected = HCategory.generated()
                              .where((e) => e.categoryName == cate)
                              .toList()
                              .first;
                        },
                        options: HCategory.generated()
                            .map((lang) => FormBuilderFieldOption(
                                value: lang.categoryName))
                            .toList(growable: false),
                      ),
                      FormBuilderTextField(
                        attribute: "title",
                        initialValue: _title ?? "",
                        decoration: InputDecoration(
                          labelText: "Tiêu đề",
                          errorStyle: TextStyle(color: Colors.redAccent),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Hãy nhập tiêu đề"),
                        ],
                        onChanged: (title) {
                          setState(() {
                            _title = title;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        attribute: "description",
                        initialValue: _description ?? "",
                        decoration: InputDecoration(
                          labelText: "Mô tả",
                          hintText:
                              "e.g. Số lượng, chất lượng, ngày hết hạn,...",
                          errorStyle: TextStyle(color: Colors.redAccent),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Hãy nhập mô tả"),
                        ],
                        onChanged: (desc) {
                          setState(() {
                            _description = desc;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        attribute: "pickupTime",
                        initialValue: _pickup ?? "Từ 9h sáng đến 5h chiều",
                        decoration: InputDecoration(
                          labelText: "Thời gian nhận",
                          hintText: "Từ 9h sáng đến 5h chiều",
                          errorStyle: TextStyle(color: Colors.redAccent),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Hãy thời gian có thể nhận quà"),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _pickup = val;
                          });
                        },
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "startDate",
                        initialDate: DateTime.now(),
                        initialValue: _startDate ?? DateTime.now(),
                        inputType: InputType.date,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          labelText: "Ngày nhận",
                          errorStyle: TextStyle(color: Colors.redAccent),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Bạn hãy nhập ngày có thể nhận"),
                        ],
                        onChanged: (startDate) {
                          setState(() {
                            _startDate = startDate;
                          });
                        },
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "endDate",
                        initialDate: DateTime.now(),
                        initialValue: _endDate ?? DateTime.now(),
                        inputType: InputType.date,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          labelText: "Ngày kết thúc nhận",
                          errorStyle: TextStyle(color: Colors.redAccent),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Bạn hãy nhập ngày kết thúc nhận"),
                        ],
                        onChanged: (endDate) {
                          setState(() {
                            _endDate = endDate;
                          });
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                size: 20, color: Colors.grey),
                            _address == null || _address.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child:
                                        Text("Hãy chọn địa điểm cho nhận quà"),
                                  )
                                : Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
                                      child: Text(
                                        _address,
                                        style: Styles.getRegularStyle(
                                            12, Colors.grey),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 8),
                        child: GestureDetector(
                          child: Text("Thay đổi",
                              style: Styles.getRegularStyle(12, Colors.red),
                              textAlign: TextAlign.left),
                          onTap: _presentLocationScreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: ColorUtils.hexToColor(colorD92c27),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                            child: Text("Đăng Tin"),
                            textColor: Colors.white,
                            onPressed: _handleCreatePost),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future _presentLocationScreen() async {
    LocationResult result = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => PlacePicker(
          kGMapApiKey,
          displayLocation: _postLocation,
        ),
      ),
    );
    BlocProvider.of<CreatePostBloc>(context)
        .add(ChangePostPickupLocationEvent(locationResult: result));
  }

  void _handleCreatePost() {
    if (_fbKey.currentState.saveAndValidate()) {
      if (widget.imageCover == null) {
        AlertHelper.showAlertError(context, "Bạn cần chụp hình sản phẩm");
        return;
      }

      final profile = userManager.userProfile.value;

      final postModel = CreatePostCommand(
        title: _title,
        imageUrl: widget.postImageUrl,
        description: _description,
        pickUpTime: _pickup,
        startDate: DateUtils.dateToString(_startDate),
        // startDate: "2019-12-13T04:11:00.000Z",
        endDate: DateUtils.dateToString(_endDate),
        // endDate: "2019-12-13T04:11:00.000Z",
        categoryId: _categorySelected.id,
        lastModifiedDate: DateUtils.dateToString(
          DateTime.now(),
        ),
        // lastModifiedDate: "2019-12-13T04:11:00.000Z",
        lastModifiedBy: profile.email ?? profile.userId ?? "",
        latitude: _postLocation.latitude ?? 0.0,
        longitude: _postLocation.longitude ?? 0.0,
        pickupAddress: _address ?? "",
        city: _city,
        district: _district,
        userProfileDisplayName:
            profile.displayName ?? profile.email ?? profile.userId,
        userProfileImageUrl: profile.imageUrl ?? kDefaultUserPhotoUrl,
        status: ItemRequestMessageStatus.Open.toString(),
      );
      BlocProvider.of<CreatePostBloc>(context).add(
          AddPostStartEvent(postModel: postModel, image: widget.imageCover));
    }
  }
}

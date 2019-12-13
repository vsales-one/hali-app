import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hali/app_widgets/empty_listing.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/user_profile/bloc/bloc.dart';
import 'package:hali/utils/color_utils.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>(); 
  UserProfile model;
  UserProfileBloc _userProfileBloc;

  void showSnackBar(String msg) {
    _globalKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
      ));
  }

  @override
  void initState() {
    super.initState();    
    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _userProfileBloc..add(UserProfileLoading());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (ctx, state) {
        if (state is UserProfileUpdatedState) {
          _userProfileBloc.add(UserProfileLoading());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoadingState) {
            return _buildLoadingBody();
          }

          if (state is UserProfileLoadedState) {
            this.model = state.userProfile;
            return _buildBody(context);
          }

          return EmptyListing();
        },
      ),
    );
  }

  Widget _buildLoadingBody() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        "Cập nhật thông tin cá nhân",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      backgroundColor: ColorUtils.hexToColor(colorD92c27),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: _buildAppBar(),
      body: FormBuilder(
        key: _fbKey,
        autovalidate: true,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormBuilderTextField(
                  attribute: "displayName",
                  decoration: InputDecoration(
                    labelText: "Tên Hiển Thị",
                  ),
                  initialValue: model.displayName,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Cần nhập tên hiển thị"),
                    FormBuilderValidators.maxLength(500),
                  ],
                  keyboardType: TextInputType.text,
                ),
                FormBuilderTextField(
                  attribute: "phoneNumber",
                  decoration: InputDecoration(
                    labelText: "Số Điện Thoại",
                  ),
                  initialValue: model.phoneNumber,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Cần nhập số điện thoại"),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.maxLength(500),
                  ],
                  keyboardType: TextInputType.number,
                ),
                FormBuilderTextField(
                  attribute: "email",
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  initialValue: model.email,
                  validators: [
                    FormBuilderValidators.required(errorText: "Cần nhập email"),
                    FormBuilderValidators.email(
                        errorText: "Email không hợp lệ"),
                    FormBuilderValidators.maxLength(500),
                  ],
                  keyboardType: TextInputType.text,
                ),
                FormBuilderTextField(
                  attribute: "address",
                  decoration: InputDecoration(
                    labelText: "Địa Chỉ",
                  ),
                  initialValue: model.address,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Cần cung cấp địa chỉ"),
                    FormBuilderValidators.maxLength(500),
                  ],
                  keyboardType: TextInputType.text,
                ),
                FormBuilderTextField(
                  attribute: "district",
                  decoration: InputDecoration(
                    labelText: "Quận",
                  ),
                  initialValue: model.district,
                  validators: [
                    //FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(500),
                  ],
                  keyboardType: TextInputType.text,
                ),
                FormBuilderTextField(
                  attribute: "city",
                  decoration: InputDecoration(
                    labelText: "Thành Phố",
                  ),
                  initialValue: model.city,
                  validators: [
                    //FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(500),
                  ],
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  color: Colors.blueAccent,
                  child: Text(
                    "Lưu",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_fbKey.currentState.saveAndValidate()) {
                      final updatedUser = UserProfile(
                        model.email,
                        _fbKey.currentState.value['displayName'],
                        _fbKey.currentState.value['phoneNumber'],
                        model.email,
                        model.imageUrl,
                        _fbKey.currentState.value['address'],
                        _fbKey.currentState.value['district'],
                        _fbKey.currentState.value['city'],
                        model.isActive,
                        model.longitude,
                        model.latitude,
                      );
                      _userProfileBloc
                          .add(UserProfileUpdating(userProfile: updatedUser));
                    } else {
                      print(_fbKey.currentState.value);
                      print("validation failed");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hali/app_widgets/empty_listing.dart';
import 'package:hali/authentication_bloc/authentication_bloc.dart';
import 'package:hali/authentication_bloc/bloc.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/user_profile/bloc/bloc.dart';
import 'package:hali/config/application.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  UserProfile model;
  UserProfileBloc _userProfileBloc;

  ValueChanged _onChanged = (val) => print(val);
  final districts = ['', 'Q1', 'Tân Bình', 'Tân Phú'];
  final cities = ['', "TpHCM", "Cần Thơ", "Vĩnh Long", "Đà Lạt"];

  @override
  void initState() {
    super.initState();
    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _userProfileBloc..add(UserProfileLoading());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (ctx, s) {},
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoadingState) {
            return _buildLoadingBody();
          }
          if (state is UserProfileLoadedState) {
            this.model = state.userProfile;
            print(">>>>>>> get user profile data:");
            print(model.toJson());
            return _buildBody(context);
          }
          if (state is UserProfileUpdatedState) {
            model = state.userProfile;
            return _buildBody(context);
          }
          return EmptyListing();
        },
      ),
    );
  }

  Widget _buildLoadingBody() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: _fbKey,
        autovalidate: true,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  attribute: "displayName",
                  decoration: InputDecoration(
                    labelText: "Tên Hiển Thị",
                  ),
                  initialValue: model.displayName,
                  validators: [
                    FormBuilderValidators.required(errorText: "Cần nhập tên hiển thị"),
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
                    FormBuilderValidators.required(errorText: "Cần nhập số điện thoại"),
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
                  onChanged: _onChanged,
                  validators: [
                    FormBuilderValidators.required(errorText: "Cần nhập email"),
                    FormBuilderValidators.email(errorText: "Email không hợp lệ"),
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
                    FormBuilderValidators.required(errorText: "Cần cung cấp địa chỉ"),
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
                // FormBuilderDropdown(
                //   attribute: "district",
                //   decoration: InputDecoration(
                //     labelText: "District",
                //   ),
                //   //initialValue: model.district,
                //   initialValue: 'Q1',
                //   hint: Text('Select District'),
                //   validators: [FormBuilderValidators.required()],
                //   items: districts
                //       .map((district) => DropdownMenuItem(
                //             value: district,
                //             child: Text('$district'),
                //           ))
                //       .toList(),
                // ),
                // FormBuilderDropdown(
                //   attribute: "city",
                //   decoration: InputDecoration(
                //     labelText: "City",
                //   ),
                //   //initialValue: model.city,
                //   initialValue: 'TpHCM',
                //   hint: Text('Select City'),
                //   validators: [FormBuilderValidators.required()],
                //   items: cities
                //       .map((city) => DropdownMenuItem(
                //             value: city,
                //             child: Text('$city'),
                //           ))
                //       .toList(),
                // ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Save",
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
                            //final updatedUser = UserProfile.fromJson(_fbKey.currentState.value);
                            //updatedUser.email = model.email;
                            // final updatedUser = UserProfile.fromNamed(
                            //   id: model.id,
                            //   email: model.email,
                            //   displayName: _fbKey.currentState.value["displayName"]
                            // );
                            _userProfileBloc.add(
                                UserProfileUpdating(userProfile: updatedUser));
                          } else {
                            print(_fbKey.currentState.value);
                            print("validation failed");
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(LoggedOut());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hali/authentication_bloc/authentication_bloc.dart';
import 'package:hali/authentication_bloc/bloc.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => print(val);
  var districts = ['Q1', 'Tân Bình', 'Tân Phú'];
  final cities = ["TpHCM", "Cần Thơ", "Vĩnh Long", "Đà Lạt"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                // context,
                key: _fbKey,
                autovalidate: true,
                initialValue: {
                  'movie_rating': 5,
                },
                child: Column(
                  children: <Widget>[                   
                    FormBuilderTextField(
                      attribute: "displayName",
                      decoration: InputDecoration(
                        labelText: "Display Name",
                      ),
                      //onChanged: _onChanged,                      
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(500),
                      ],
                      keyboardType: TextInputType.text,
                    ),
                    FormBuilderTextField(
                      attribute: "phoneNumber",
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                      ),
                      //onChanged: _onChanged,                      
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(500),
                      ],
                      keyboardType: TextInputType.text,
                    ),
                    FormBuilderTextField(
                      attribute: "email",
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                      onChanged: _onChanged,                      
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(500),
                      ],
                      keyboardType: TextInputType.text,
                    ),
                    FormBuilderTextField(
                      attribute: "address",
                      decoration: InputDecoration(
                        labelText: "Address",
                      ),
                      onChanged: _onChanged,                      
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(500),
                      ],
                      keyboardType: TextInputType.text,
                    ),
                    FormBuilderDropdown(
                      attribute: "district",
                      decoration: InputDecoration(
                        labelText: "District",
                      ),
                      // initialValue: 'Male',
                      hint: Text('Select District'),
                      validators: [FormBuilderValidators.required()],
                      items: districts
                          .map((district) => DropdownMenuItem(
                        value: district,
                        child: Text('$district'),
                      ))
                          .toList(),
                    ),
                    FormBuilderTypeAhead(
                      decoration: InputDecoration(
                        labelText: "City",
                      ),
                      attribute: 'city',
                      onChanged: _onChanged,
                      itemBuilder: (context, country) {
                        return ListTile(
                          title: Text(country),
                        );
                      },
                      controller: TextEditingController(text: ''),
                      initialValue: "TpHCM",
                      suggestionsCallback: (query) {
                        if (query.length != 0) {
                          var lowercaseQuery = query.toLowerCase();
                          return cities.where((country) {
                            return country
                                .toLowerCase()
                                .contains(lowercaseQuery);
                          }).toList(growable: false)
                            ..sort((a, b) => a
                                .toLowerCase()
                                .indexOf(lowercaseQuery)
                                .compareTo(
                                    b.toLowerCase().indexOf(lowercaseQuery)));
                        } else {
                          return cities;
                        }
                      },
                    ),
                    
                  ],
                ),
              ),
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
                          print(_fbKey.currentState.value);
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
                        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
      
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(      
  //     body: Center(
  //       child: RaisedButton(
  //         child: Text("Sign out"),
  //         onPressed: () {
  //           // await RepositoryProvider.of<UserRepository>(context).signOut();
  //           BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  //         },
  //       ),
  //     ),
  //   );
  // }
}

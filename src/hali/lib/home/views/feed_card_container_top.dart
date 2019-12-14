import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/utils/date_utils.dart';

class FeedCardContainerTop extends StatelessWidget {
  final UserProfile userProfile;
  final String createdDate;

  FeedCardContainerTop({this.userProfile, this.createdDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                // avatar
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(userProfile.imageUrl),
                  ),
                ),
                // name
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userProfile.displayName ?? "",
                        style: Styles.getSemiboldStyle(14, Colors.black87),
                        textAlign: TextAlign.left,
                      ),
                      Text(DateUtils.timeAgo(this.createdDate),
                          style: Styles.getRegularStyle(12, Colors.grey[500]),
                          textAlign: TextAlign.left)
                    ],
                  ),
                ),
              ],
            ),
          ),
          // button
        ],
      ),
    );
  }
}

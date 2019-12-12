
import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/utils/color_utils.dart';

class FeedDetailRequestButton extends StatelessWidget {
  final double distance;
  final VoidCallback onSendItemRequest;

  FeedDetailRequestButton({this.onSendItemRequest, this.distance});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ColorUtils.hexToColor(colorD92c27),
            borderRadius: BorderRadius.circular(24)),
        child: Column(
          children: <Widget>[
            FlatButton(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Request listing",
                      style: Styles.getRegularStyle(14, Colors.white),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.white,
                          ),
                          Text(
                            "$distance km away",
                            style: Styles.getRegularStyle(14, Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                onPressed: onSendItemRequest),
          ],
        ),
      ),
    );
  }
}

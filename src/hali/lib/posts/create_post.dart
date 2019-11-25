
import 'package:flutter/material.dart';
import 'package:hali/utils/color_utils.dart';
class CreatePostScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return CreatePostScreenState();
  }
}
class CreatePostScreenState extends State<CreatePostScreen> {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(

      slivers: <Widget>[

      ],
    );
  }
}

class _PhotoCover extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return SliverToBoxAdapter(
       child: SizedBox(
         height: 200,
         child: Container(
           child: Center(
             child: Column(
               children: <Widget>[
                 Icon(Icons.camera_alt, size: 100,),
                 _TakePhoto()
               ],
             ),
           ),
         ),
       ),
     );
  }
}

class _TakePhoto extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.hexToColor(colorD92c27)
      ),
      child: FlatButton(
          onPressed: null,
          child: Text("Take a Photo")
      ),
    );
  }
}

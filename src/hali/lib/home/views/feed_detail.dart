
import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';

class FeedDetail extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FeedDetailState();
  }
}

class FeedDetailState extends State<FeedDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        slivers: <Widget>[
          // sliver app bar
          _VSliverAppBar(),
          _LocationWidget(),
          _GoingOnWidget(),
          _TitleWidget(),

        ],
      ),
    );
  }

}

class _VSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text("Collapsing Toolbar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
          background: Image.network(
            "https://images.unsplash.com/photo-1537758069025-b07fb3548d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2752&q=80",
            fit: BoxFit.cover,
          )
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Container(
              padding: EdgeInsets.only(left: 16, top: 20, bottom: 20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("PORSTMORE FEST", style: Styles.getSemiboldStyle(25, Colors.black54), textAlign: TextAlign.center,),
                  ),
                  Text("Cùng Phượt – Hòn Nội (Khánh Hòa) sở hữu bãi tắm đôi duy nhất tại Việt Nam với một bên nóng, một bên lạnh. Nơi đây trở thành địa điểm check-in biển tuyệt vời của du khách.", style: Styles.getRegularStyle(16, Colors.black54), textAlign: TextAlign.left,),
                  Text("Read more...", style: Styles.getRegularStyle(12, Colors.blue),  textAlign: TextAlign.left),
                ],
              ),
            )
          )
        ]
      ),
    );
  }
}

class _GoingOnWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
        height: 120.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, top: 8,right: 8, bottom: 5),
              child: Text("Going on", style: Styles.getSemiboldStyle(16, Colors.black54)),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, bottom: 16),
              height: 3,
              width: 70,
              color: Colors.black54,
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(left: 16,bottom: 8),
                    child:  CircleAvatar(
                      radius: 30,
                    ),
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }
}

class _LocationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(child: Icon(Icons.date_range, color: Colors.black54,), padding: EdgeInsets.only(right: 16),),
                  Text("24 May, 2018, 8h30 AM", style: Styles.getSemiboldStyle(14, Colors.black54),)
                ],
              ),

              Row(
                children: <Widget>[
                  Padding(child: Icon(Icons.location_on, color: Colors.black54,), padding: EdgeInsets.only(right: 16),),
                  Expanded(
                    child: Text("92 Nguyen Huu Canh, Sai Gon Pearl, 92 Nguyen Huu Canh, Sai Gon Pearl", style: Styles.getSemiboldStyle(14, Colors.black54),),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Future getUsers() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("trucks").getDocuments();
    return qn.documents;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SELECT TRUCK"),
          backgroundColor: Colors.red[900],
        ),

        body: Container(
          child: new Column(
            children: <Widget>[

              new Flexible(
                child: FutureBuilder(
                    future: getUsers(),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading... Please wait"),
                        );
                      }if (snapshot.data == null){
                        return Center(
                          child: Text("The are no pending requests"),);
                      }else{
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return new GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new PostDates(

                                  truckNumber: snapshot.data[index].data["plate"],
                                  driverName: snapshot.data[index].data["driver"],
                                  driverNumber: snapshot.data[index].data["phone"],
                                  driverID: snapshot.data[index].data["ID"],
                                  turnboy: snapshot.data[index].data["turnboy"],


                                )));
                              },
                              child: new Card(
                                child: Stack(
                                  alignment: FractionalOffset.topLeft,
                                  children: <Widget>[
                                    new ListTile(
                                      leading: new CircleAvatar(
                                          backgroundColor: Colors.red[900],
                                          child: new Icon(Icons.directions_car)
                                      ),
                                      title: new Text("${snapshot.data[index].data["plate"]}",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.0,
                                            color: Colors.red[900]),),
                                      subtitle: new Text("Driver : ${snapshot.data[index].data["driver"]}",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0,
                                            color: Colors.grey),),
                                    ),

                                  ],
                                ),
                              ),
                            );

                          },
                        );

                      }
                    }),)
            ],
          ),
        )

    );
  }
}

class PostDates extends StatefulWidget {

  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String turnboy;
  String itemDescription;

  PostDates({

    this.truckNumber,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.turnboy,
    this.itemDescription
  });

  @override
  _PostDatesState createState() => _PostDatesState();
}

class _PostDatesState extends State<PostDates> {

  CollectionReference collectionReference =
  Firestore.instance.collection("posttrip");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.where("Truck", isEqualTo:
          widget.truckNumber).snapshots(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading... Please wait"),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data.documents[index];
                      return Card(
                        child: ListTile(
                          title: Text("Date: ${doc.data['date']}"),

                          onTap: () async {

                            Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new PostDetails(

                              truckNo: doc.data["Truck"],
                              gasket: doc.data["Gasket"],
                              hosepipe: doc.data["Hose pipe"],
                              engineMounts: doc.data["Engine Mounts"],
                              fanBelt: doc.data["Fan belt and blades"],
                              radiator: doc.data["Radiator"],
                              injectorPump: doc.data["Injector Pump"],
                              evaluationDate: doc.data["date"],
                              inspection: doc.data["Inspection"],
                              insurance: doc.data["Insurance Expiry"],
                              greasing: doc.data["Greasing at KM"],
                              comment: doc.data["Comment"],
                              engine: Map<String, dynamic>.from(doc.data["engine"]),
                              electronics: Map<String, dynamic>.from(doc.data["electronics"]),
                              brakes: Map<String, dynamic>.from(doc.data["brakes"]),
                              frontSusp: Map<String, dynamic>.from(doc.data["front suspension"]),
                              rearSusp: Map<String, dynamic>.from(doc.data["rear suspension"]),
                              wheelDetail: Map<String, dynamic>.from(doc.data["wheel details"]),
                              cabin: Map<String, dynamic>.from(doc.data["cabin"]),
                              body: Map<String, dynamic>.from(doc.data["body"]),
                              safety: Map<String, dynamic>.from(doc.data["safety"]),
                              frontWheels: Map<String, dynamic>.from(doc.data["frontWheels"]),
                              backWheels: Map<String, dynamic>.from(doc.data["backWheels"]),



                            )));

                          },
                        ),
                      );

                },
              );

            }
          }),

    );
  }
}

class PostDetails extends StatefulWidget {

  final Map<String,dynamic> engine ;
  final Map<String,dynamic> electronics;
  final Map<String,dynamic> brakes;
  final Map<String,dynamic> frontSusp;
  final Map<String,dynamic> rearSusp;
  final Map<String,dynamic> wheelDetail;
  final Map<String,dynamic> cabin;
  final Map<String,dynamic> body;
  final Map<String,dynamic> safety;
  final Map<String,dynamic> frontWheels;
  final Map<String,dynamic> backWheels;
  String truckNo;
  String evaluationDate;
  String inspection;
  String insurance;
  String greasing;
  String comment;
  String gasket;
  String hosepipe;
  String engineMounts;
  String fanBelt;
  String  radiator;
  String  injectorPump;



  PostDetails({
    this.engine,
    this.electronics,
    this.brakes,
    this.frontSusp,
    this.rearSusp,
    this.wheelDetail,
    this.cabin,
    this.body,
    this.safety,
    this.frontWheels,
    this.backWheels,
    this.truckNo,
    this.evaluationDate,
    this.insurance,
    this.inspection,
    this.greasing,
    this.comment,
    this.gasket,
    this.hosepipe,
    this.engineMounts,
    this.fanBelt,
    this.radiator,
    this.injectorPump,


  });

  @override
  _PostDetailsState createState() => _PostDetailsState();
}



class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text("Detail"),
        centerTitle: true,
      ),

      body: new Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            height: 50.0,
            decoration: new BoxDecoration(
              color: Colors.grey.withAlpha(50),
              borderRadius: new BorderRadius.only(
                bottomRight: new Radius.circular(20.0),
                bottomLeft: new Radius.circular(20.0),
              ),
            ),
          ),

          new SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new SizedBox(
                          width: 5.0,
                        ),
                        new Text(
                          "Evaluation Date",
                          style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                        )
                      ],
                    ),
                    new Text(
                      widget.evaluationDate,
                      style: new TextStyle(
                          fontSize: 11.0,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                new SizedBox(
                  height: 10.0,
                ),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "ENGINE",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.engine == null ? Container() :
                      new Flexible(
                    child: new ListView.builder(
                      shrinkWrap: true,
                    itemCount: widget.engine.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = widget.engine.keys.elementAt(index);
                      return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text("$key"),
                            subtitle: new Text("${widget.engine[key]}"),
                          ),
                          new Divider(
                            height: 2.0,
                          ),
                        ],
                      );
                    },
                ),
                  ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "ELECTRONICS",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.electronics == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.electronics.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.electronics.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.electronics[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "BRAKES",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.brakes == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.brakes.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.brakes.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.brakes[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "FRONT SUSPENSION",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.frontSusp == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.frontSusp.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.frontSusp.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.frontSusp[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "REAR SUSPENSION",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.rearSusp == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.rearSusp.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.rearSusp.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.rearSusp[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "WHEEL DETAIL",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.wheelDetail == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.wheelDetail.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.wheelDetail.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.wheelDetail[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "CABIN",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.cabin == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.cabin.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.cabin.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.cabin[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "BODY",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.body == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.body.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.body.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.body[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "SAFETY",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.safety == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.safety.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.safety.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.safety[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "FRONT WHEELS",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.frontWheels == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.frontWheels.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.frontWheels.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.frontWheels[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: new Text(
                          "BACK WHEELS",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      widget.backWheels == null ? Container() :
                      new Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.backWheels.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = widget.backWheels.keys.elementAt(index);
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ListTile(
                                  title: new Text("$key"),
                                  subtitle: new Text("${widget.backWheels[key]}"),
                                ),
                                new Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),),
                new Card(
                  child: new Container(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Truck",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.truckNo,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        new SizedBox(
                          height: 5.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Evaluation Date",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.evaluationDate,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),


                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Insurance Expiry",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.insurance,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),

                        new SizedBox(
                          height: 5.0,
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Greasing@KM",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.greasing,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),

                        widget.comment != null?
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Comment",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.comment,
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ): new Offstage(),





                        new SizedBox(
                          height: 5.0,
                        ),


                        new SizedBox(
                          height: 10.0,
                        ),


                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}



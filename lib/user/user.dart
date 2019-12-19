import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:e_lorry/user/post_trip.dart';
import 'package:e_lorry/user/requisition.dart';
import 'package:e_lorry/user/truck_service.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:e_lorry/login.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MATERIALS REQUESTED"),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),

      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountEmail: Text("User"),
              currentAccountPicture: new CircleAvatar(backgroundColor: Colors.white,
                child: new Icon(Icons.person,
                  color: Colors.green,
                  size: 20.0,
                ),)
              ,),

            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.receipt,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Requests"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new Requisition()));
              },
            ),

            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.settings,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Service"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new truckService()));
              },
            ),

            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.directions_car,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Post Trip"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new Post()));
              },
            ),

            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(Icons.subdirectory_arrow_left,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Logout"),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new LoginScreen()));
              },
            ),


          ],
        ),
      ),
      body: Items(),
    );
  }
}

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}


class _ItemsState extends State<Items> {


  CollectionReference collectionReference =
  Firestore.instance.collection("request");

  DocumentSnapshot _currentDocument;

  _updateData() async {
    await Firestore.instance
        .collection('request')
        .document(_currentDocument.documentID)
        .updateData({'status': "checked"});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.where("status", isEqualTo:
          "pending").snapshots(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading... Please wait"),
              );
            }if (snapshot.hasData == false){
              return Center(
                child: Text("There are no pending requests"),);
            }else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data.documents[index];
                      return Card(
                        child: ListTile(
                          title: Text(doc.data['Item']),
                          subtitle: Text(doc.data['Truck']),
                          trailing: new Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.red[900])
                            ),
                            child: Text(doc.data['status'], style: TextStyle(color: Colors.red[900]),),
                          ),
                          onTap: () async {
                            setState(() {
                              _currentDocument = doc;
                            });

                            _updateData();

                            Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new Requests(

                              itemName: doc.data["Item"],
                              itemQuantity: doc.data["Quantity"],
                              itemNumber: doc.data["Truck"],


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

class Requests extends StatefulWidget {

  String itemName;
  String itemQuantity;
  String itemNumber;

  Requests({

    this.itemName,
    this.itemQuantity,
    this.itemNumber,
  });

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

//We have two private fields here
  String _material;
  String _quantity;
  String _name;
  String _truck;
  String _date;
  String _quoteOne;
  String _quoteTwo;
  String _quoteThree;
  String _brand;
  String _price;
  String _supplier;

  var mask = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      _loginCommand();
    }
  }

  void _loginCommand() {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('requisition');

      await reference.add({
        "Truck": widget.itemNumber,
        "Item": widget.itemName,
        "Quantity": widget.itemQuantity,
        "Name": _name,
        "date" : DateTime.now(),
        "quoteOne" : _quoteOne,
        "quoteTwo" : _quoteTwo,
        "quoteThree" : _quoteThree,
        "brand" : _brand,
        "price" : _price,
        "supplier" : _supplier,
        "status" : "pending",
      });
    }).then((result) =>

        _showRequest());

  }

  void _showRequest() {
    // flutter defined function
    final form = formKey.currentState;
    form.reset();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Your request has been sent"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("close"),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Material Requsition"), backgroundColor: Colors.red[900],),

      body: new SingleChildScrollView(
        child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                                  "Item requested",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemName,
                              style: new TextStyle(
                                  fontSize: 14.0,
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
                                  "Quantity",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemQuantity,
                              style: new TextStyle(
                                  fontSize: 14.0,
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
                                  "Truck",
                                  style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                                )
                              ],
                            ),
                            new Text(
                              widget.itemNumber,
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              new Form(
                key: formKey,
                child: Column(
                  children: <Widget>[

                    new SizedBox(
                      height: 10.0,
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: 'Name of person making request',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _name = val,
                        ),
                      ),
                    ),

                    new SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(
                              hintText: "mm/dd/yyyy",
                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: 'Date',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          inputFormatters: [mask],
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _date = val,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: '1st Qoute',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _quoteOne = val,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: '2nd Quote',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _quoteTwo = val,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: '3rd Quote',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _quoteThree = val,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: 'Brand',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _brand = val,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: 'Final negotiated price',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _price = val,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(

                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelText: 'Final approved supplier',
                              labelStyle: TextStyle(
                                  fontSize: 11
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty  ? 'Required' : null,
                          onSaved: (val) => _supplier = val,
                        ),
                      ),
                    ),




                    Padding(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                      child: MaterialButton(
                        onPressed: _submitCommand,
                        child: Text('SAVE',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFUIDisplay',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Colors.white,
                        elevation: 16.0,
                        minWidth: 400,
                        height: 50,
                        textColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                    ),



                  ],
                ),
              ),

            ],
        ),
      ),
    );
  }
}

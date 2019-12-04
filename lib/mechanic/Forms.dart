import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'material_request.dart';


class ServiceForm extends StatefulWidget {



  String truckNumber;
  String driverName;
  String driverNumber;
  String driverID;
  String turnboy;
  String itemDescription;

  ServiceForm({

    this.truckNumber,
    this.driverName,
    this.driverNumber,
    this.driverID,
    this.turnboy,
    this.itemDescription
  });

  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> with SingleTickerProviderStateMixin{

  ScrollController _scrollViewController;
  TabController _tabController;


  String _email;
  String _password;
  String _gasket;
  String _hose;
  String _mounts;
  String _fanbelt;
  String _radiator;
  String _flywheel;
  String _injpump;
  String _myActivity;
  bool autovalidate = true;

  String _inspection;
  String _insurance;
  String _speedgov;
  String _bktyre;
  String _frtyre;
  String _sptyre;
  String _batwarranty;
  String _purchase;
  String _batserial;
  String _first;
  String _second;
  String _ttliters;
  String _avg;
  String _current;
  String _nxt;
  String _given;
  String _oil;
  String _grease;
  String _breaks;
  String _caps;
  String _mirror;
  String _multi;
  String _padlock;
  String _firstaid;
  String _triangle;
  String _fire;
  String _date;
  String _date2;


  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override


  void _saveService() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _serviceDialog();
    }
  }

  void _serviceDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Once you save you can not change anything"),
          content: new Text("Do you want to continue?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
                _serviceCommand();

              },
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _serviceCommand() {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('service');

      await reference.add({
        "Truck": widget.truckNumber,
        "Driver": widget.driverName,
        "Number": widget.driverNumber,
        "Inspection Expiry": _inspection,
        "Insurance Expiry": _insurance,
        "Speed Governor Expiry": _speedgov,
        "Back tyre serial number":_bktyre,
        "Front tyre serial number": _frtyre,
        "Spare tyre serial number": _sptyre,
        "Battery warranty": _batwarranty,
        "Date purchased": _purchase,
        "Battery serial number": _batserial,
        "Date Given": _given,
        "1st Tank": _first,
        "2nd Tank": _second,
        "Total litres": _ttliters,
        "Average per kilometre": _avg,
        "Current kilometres": _current,
        "Next service": _nxt,
        "Km when Oil, Gearbox, and Diff oil changed": _oil,
        "Spare tyre serial number": _sptyre,
        "Grease frontwheel": _grease,
        "timestamp" : DateTime.now(),
        "date":_date2,
        "Service by" : "Mechanic",
      });
    }).then((result) =>

        _showRequest());

  }


  void _submitCommand() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _showDialog();
    }
  }


  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Once you save you can not change anything"),
          content: new Text("Do you want to continue?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
                _loginCommand();

              },
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }





  void _loginCommand() {
    final form = formKey.currentState;

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('posttrip');

      await reference.add({
        "Truck": widget.truckNumber,
        "Gasket": _gasket,
        "Hose pipe": _hose,
        "Engine Mounts": _mounts,
        "Fan belt and blades":_fanbelt,
        "Radiator": _radiator,
        "Injector Pump": _injpump,
        "date": _date,
        "timestamp" : DateTime.now(),
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
          title: new Text("Your data has been saved"),
          content: new Text("Do you want to Request any Material?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new  matRequest(
                      truckNo: widget.truckNumber,
                      driverName: widget.driverName,

                    )
                )
                );
              },
            ),
            new FlatButton(
              child: new Text("NO"),
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
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
    _myActivity = '';
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){ //<-- headerSliverBuilder
          return <Widget>[
            new SliverAppBar(
              title: new Text("Select Form"),
              centerTitle: true,
              pinned: true,                       //<-- pinned to true
              floating: true,                     //<-- floating to true
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Colors.red[900],//<-- forceElevated to innerBoxIsScrolled
              bottom: new TabBar(
                labelColor: Colors.red[900],
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.only(left: 30, right: 30),
                indicator: BoxDecoration(
                  color: Colors.white,),
                tabs: <Tab>[
                  new Tab(
                    text: "POST TRIP",
                  ),
                  new Tab(
                    text: "SERVICE",
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: new TabBarView(
          children: <Widget>[
            new SingleChildScrollView(
        child: SafeArea(
          child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              new Card(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Text("ENGINE",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),),

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
                                  hintText: "01/01/2001",
                                  errorStyle: TextStyle(color: Colors.red),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  labelText: 'Date',
                                  labelStyle: TextStyle(
                                      fontSize: 11
                                  )
                              ),
                              validator: (val) =>
                              val.isEmpty  ? 'Required' : null,
                              onSaved: (val) => _date = val,
                            ),
                          ),
                        ),

                        DropDownFormField(
                          titleText: 'Gasket',
                          hintText: 'Pass/Fail',
                          value: _gasket,
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              _gasket = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _gasket = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Pass",
                              "value": "Pass",
                            },
                            {
                              "display": "Fail",
                              "value": "Fail",
                            },

                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                        DropDownFormField(
                          titleText: 'Hose pipe',
                          hintText: 'Pass/Fail',
                          value: _hose,
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              _hose = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _hose = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Pass",
                              "value": "Pass",
                            },
                            {
                              "display": "Fail",
                              "value": "Fail",
                            },

                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                        DropDownFormField(
                          titleText: 'Engine Mounts',
                          hintText: 'Pass/Fail',
                          value: _mounts,
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              _mounts = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _mounts = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Pass",
                              "value": "Pass",
                            },
                            {
                              "display": "Fail",
                              "value": "Fail",
                            },

                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),

                        DropDownFormField(
                          titleText: 'Fan Belt and Blades',
                          hintText: 'Pass/Fail',
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                          },
                          value: _fanbelt,
                          onSaved: (value) {
                            setState(() {
                              _fanbelt = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _fanbelt = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Pass",
                              "value": "Pass",
                            },
                            {
                              "display": "Fail",
                              "value": "Fail",
                            },

                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),

                        DropDownFormField(
                          titleText: 'Radiator',
                          hintText: 'Pass/Fail',
                          value: _radiator,
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              _radiator = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _radiator = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Pass",
                              "value": "Pass",
                            },
                            {
                              "display": "Fail",
                              "value": "Fail",
                            },

                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),

                        DropDownFormField(
                          titleText: 'Injector Pump',
                          hintText: 'Pass/Fail',
                          value: _injpump,
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              _injpump = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _injpump = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "Pass",
                              "value": "Pass",
                            },
                            {
                              "display": "Fail",
                              "value": "Fail",
                            },

                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),

                      ],
                    ),


                  ],
                ),
              ),


              new SizedBox(
                height: 10.0,
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
      ),
    ),
            new SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Container(
                          child: TextFormField(
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SFUIDisplay'
                            ),
                            decoration: InputDecoration(
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Inspection Expiry',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid date' : null,
                            onSaved: (val) => _inspection = val,
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
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Insurance Expiry',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _insurance = val,
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
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Speed Governor Expiry',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _speedgov = val,
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
                                labelText: 'BackTyre serial number',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _bktyre = val,
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
                                labelText: 'FrontTyre Serial number',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _frtyre = val,
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
                                labelText: 'Sparetyre Serial Number',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _sptyre = val,
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
                                labelText: 'Battery Waranty',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _batwarranty = val,
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
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Date Purchased',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _purchase = val,
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
                                labelText: 'Battery serial number',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _batserial = val,
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
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Date Given',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _email = val,
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
                                labelText: '1st Tank',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _first = val,
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
                                labelText: '2nd Tank',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _second = val,
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
                                labelText: 'Total Liters',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _ttliters = val,
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
                                labelText: 'Average per Kilometre',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _avg = val,
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
                                labelText: 'Current Kilometres',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _current = val,
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
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Next Service',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _nxt = val,
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
                                labelText: 'Date Given',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _given = val,
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
                                labelText: 'KM when Oil, Gearbox and Diff oil changed',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _oil = val,
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
                                labelText: 'Greasefront wheel',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _grease = val,
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
                                labelText: 'Brake system check',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _breaks = val,
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
                                labelText: 'Fuel Caps',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _caps = val,
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
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Side mirrors',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _mirror = val,
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
                                labelText: 'Multi-lock',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _multi = val,
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
                                labelText: 'Padlock',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _padlock = val,
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
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Firstaid Box',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _firstaid = val,
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
                                labelText: 'Triangle',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _triangle = val,
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
                                labelText: 'Fire Extinguisher',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _fire = val,
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
                                hintText: "01/01/2001",
                                errorStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                labelText: 'Date of service',
                                labelStyle: TextStyle(
                                    fontSize: 11
                                )
                            ),
                            validator: (val) =>
                            val.isEmpty  ? 'Enter a valid value' : null,
                            onSaved: (val) => _date2 = val,
                          ),
                        ),
                      ),





                      new SizedBox(
                        height: 10.0,
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                        child: MaterialButton(
                          onPressed: _saveService,
                          child: Text('SAVE FORM',
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
              ),
            ),
          ],
          controller: _tabController,
        ),
      ),

    );
  }
}


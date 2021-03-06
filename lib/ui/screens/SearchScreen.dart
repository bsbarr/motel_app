import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motel_app/core/services/SearchService.dart';
import 'package:motel_app/ui/screens/MotelDetailScreen.dart';

class Search extends StatefulWidget {
  
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['motelName'].toLowerCase().contains(value.toLowerCase()) ==  true) {
            if (element['motelName'].toLowerCase().indexOf(value.toLowerCase()) ==0) {
              setState(() {
                tempSearchStore.add(element);
              });
            }
          }
        if (tempSearchStore.length == 0 && value.length > 1) {
          setState(() {});
        }

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () => {},
                    color: Colors.black,
                    icon: Icon(Icons.search),
                    iconSize: 20.0,
                    
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList())
        ]));
  }
  

Widget buildResultCard(data) {
  
  return GestureDetector(
    child:  Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        child: Center(
          child: Text(data['motelName'],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
          )
        )
      )
    ),
    onTap: () {
      //esto mueve a la page de detalle, da error mientras no esté la page de detalle
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MotelDetailScreen(
          motelName: data['motelName'],
          description: data['description'],
          address: data['address'],
          location:data['location'],
          photo: data['photo'],
          price:data['price'],
          type: data['typeId'],
         )));
         
    }
    
    );
  

}

}

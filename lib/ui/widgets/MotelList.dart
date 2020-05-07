import 'package:flutter/material.dart';
import 'package:motel_app/core/models/Motel.dart';
import 'package:motel_app/core/viewmodels/MotelViewModel.dart';
import 'package:motel_app/ui/widgets/HomeScreenExpanded.dart';
import 'package:provider/provider.dart';

import 'HomeScreenContainers.dart';

int acc = 0;

class MotelList extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final motelProvider = Provider.of<MotelViewModel>(context);
    return FutureBuilder(
      future: motelProvider.fetchMotels(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Motel> motels = snapshot.data;
          return Column(
            children: <Widget>[
              createContainer('Saludo e imagen', 'https://pickaface.net/gallery/avatar/unr_random_160817_0304_2mvqp69.png', 'José'),
              createContainer('Busca tu motel', null, null),
              createContainer('Moteles populares', null, null),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical, 
                  children: motels.map((motel) => 
                    Column(
                      children: <Widget> [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10.0,
                              )
                            ]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Column(
                              children: <Widget>[
                                LimitedBox(
                                  maxHeight: 168,
                                  maxWidth: double.infinity,
                                  child: FadeInImage(
                                    image: NetworkImage(motel.photo),
                                    placeholder: AssetImage('assets/jar-loading.gif'),
                                    width: 400,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                    createExpanded(motel.motelName, 1),
                                    createExpanded('5.0', 2),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      createExpanded('Masaya', 3),
                                      createExpanded(motel.price, 4),
                                    ],
                                  )
                                )
                              ],
                            )
                          ),
                        ),
                      ],
                    )
                  ).toList()
                ),
              )
            ],
          );
        } 
        else {
          return Center(child: CircularProgressIndicator());
        } 
      }
    );
  }
}

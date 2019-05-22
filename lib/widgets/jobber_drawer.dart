import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jobber/themes/jobber_theme.dart';

class JobberDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      JobberTheme.purple,
                      JobberTheme.purple.withOpacity(0.5),
                    ],
                    begin: const FractionalOffset(1.0, 0.0),
                    end: const FractionalOffset(0.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp
                )
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:AssetImage("assets/profile.jpg"))),
            ),
            accountName: new Container(
                child: Text(
                  'Erick Daros Silva',
                  style: TextStyle(color: Colors.white),
                )),
            accountEmail: new Container(
                child: Text(
                  'erickdarosilva@gmail.com',
                  style: TextStyle(color: Colors.white),
                )),
          ),
//          MaterialButton(
//            height: 1,
//            padding: EdgeInsets.all(20.0),
//            onPressed: () => {_onGridChange(!isGrid)},
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Container(
//                    child: Row(
//                      children: <Widget>[
//                        Icon(Icons.view_column),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 15),
//                          child: Text('Mostrar duas colunas'),
//                        ),
//                      ],
//                    )),
//                Switch(
//                  value: isGrid,
//                  onChanged: _onGridChange,
//                  activeColor: JobberTheme.purple,
//                ),
//              ],
//            ),
//          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Icon(Icons.assessment),
                ),
                Text('Minhas Contribuições'),
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Icon(Icons.add_to_photos),
                ),
                Text('Minhas Propostas'),
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Icon(Icons.notifications),
                ),
                Text('Avisos'),
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Icon(Icons.settings),
                ),
                Text('Configurações'),
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Icon(Icons.exit_to_app),
                ),
                Text('Sair'),
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
        ],
      ),
    );
  }
}
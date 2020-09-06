import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/screens/shopping_screens/CartScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/FavoritScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/OrdersScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/UserProducts.dart';
import 'package:AN_shop_application/screens/shopping_screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ANAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('welcome back'),
            automaticallyImplyLeading: false,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(UsersCollection)
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    DocumentSnapshot ds = snapshot.data;
                    final dsd = ds.data();
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(dsd[USER_IMAGE]),
                      ),
                      title: Text(dsd[UserName]),
                      subtitle: Text(FirebaseAuth.instance.currentUser.email),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text('All Products'),
                  onTap: () => Navigator.of(context).pushReplacementNamed('/'),
                ),
                Divider(),
                ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Your Shopping cart'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    }),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Your Favorites'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(FavoritesScreen.routeName);
                  },
                ),
                ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Your Orders'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                    }),
                Divider(),
                ListTile(
                    leading: Icon(Icons.add_shopping_cart),
                    title: Text('your product'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(UserProductsScreen.routename);
                    }),
                Divider(),
                ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('Chat'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(ChatScreen.routeName);
                    }),
                Divider(),
                ...List<Widget>.generate(
                    10,
                    (index) => ListTile(
                          leading: Icon(Icons.apps),
                          title: Text('Shop section no. $index'),
                          onTap: () {
                            Navigator.of(context).pop();
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('it is just a place holder')));
                          },
                        )),
                Divider(),
                ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Log Out'),
                    onTap: () async {
                      await Firebase.initializeApp();
                      FirebaseAuth.instance.signOut();
                    }),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

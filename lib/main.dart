import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/models/shopping_models/Order.dart';
import 'package:AN_shop_application/models/shopping_models/cartItem.dart';
import 'package:AN_shop_application/models/shopping_models/product.dart';
import 'package:AN_shop_application/providers/shopping_providers/Cart.dart';
import 'package:AN_shop_application/providers/shopping_providers/FavoritesProvider.dart';
import 'package:AN_shop_application/providers/shopping_providers/OrdersProvider.dart';
import 'package:AN_shop_application/providers/shopping_providers/ProductsProviders.dart';
import 'package:AN_shop_application/screens/AuthScreen.dart';
import 'package:AN_shop_application/screens/chatScreen.dart';
import 'package:AN_shop_application/screens/messagesScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/CartScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/EditingProductScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/FavoritScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/OrdersScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/ProductShow/ProductDetailsScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/UserProducts.dart';
import 'package:AN_shop_application/screens/shopping_screens/ProductShow/products_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Stream<QuerySnapshot> productStream = null;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Favorites(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'AN Shop Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, appInitsnapshot) {
            if (appInitsnapshot.connectionState == ConnectionState.waiting) {
              return Text('Dont forget to add splash screen');
            } else {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, authSnapShot) {
                  if (authSnapShot.connectionState == ConnectionState.waiting) {
                    return Text('Dont forget to add splash screen');
                  }
                  if (authSnapShot.hasData) {
                    if (productStream == null) {
                      productStream = FirebaseFirestore.instance
                          .collection(PRODUCTS)
                          .snapshots();
                      productStream.listen((event) {
                        Provider.of<Products>(context, listen: false).items =
                            event.docs
                                .map((e) => Product(
                                    id: e.id,
                                    name: e.data()[PRODUCT_NAME],
                                    imageURL: e.data()[PRODUCT_IMAGE_URL],
                                    description: e.data()[PRODUCT_DESCRIPTION],
                                    price: e.data()[PRODUCT_PRICE],
                                    ownerID: e.data()[PRODUCT_OWNER_ID]))
                                .toList();
                      });
                    }
                    FirebaseFirestore.instance
                        .collection(UsersCollection)
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection(USER_CART)
                        .get()
                        .then((value) {
                      Provider.of<Cart>(context, listen: false).items = value
                          .docs
                          .map((e) => CartItem(
                              Provider.of<Products>(context, listen: false)
                                  .getProductByID(e.id),
                              e.data()[CART_ITEM_AMOUNT]))
                          .toList();
                      return;
                    });
                    FirebaseFirestore.instance
                        .collection(UsersCollection)
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .get()
                        .then((value) {
                      final d = value.data()[USER_FAVORITE];
                      if (d == null) {
                        return;
                      }
                      List<String> str = [];
                      for (int i = 0; i < d.length; i++) {
                        str.add(d[i] as String);
                      }

                      Provider.of<Favorites>(context, listen: false).items = str
                          .map((e) =>
                              Provider.of<Products>(context, listen: false)
                                  .getProductByID(e.toString()))
                          .toList();
                    });

                    FirebaseFirestore.instance
                        .collection(UsersCollection)
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection(USER_ORDERS)
                        .get()
                        .then((value) {
                      print('Hello there');
                      final x = value.docs.map((e) => e.id).toList();
                      List<Order> inOrders = [];

                      for (int i = 0; i < x.length; i++) {
                        FirebaseFirestore.instance
                            .collection(UsersCollection)
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection(USER_ORDERS)
                            .doc(x[i])
                            .get()
                            .then((value) {
                          final data = value.data()[USER_OREDER_ITEMS]
                              as Map<String, dynamic>;
                          List<CartItem> fb = [];
                          data.forEach((productID, amount) {
                            final product =
                                Provider.of<Products>(context, listen: false)
                                    .getProductByID(productID);
                            fb.add(CartItem(product, amount));
                          });
                          print(value.data()[USER_ORDER_TOTAL_PRICE]);
                          print(value.data()[USER_ORDER_PAYMENT_METHOD]);
                          inOrders.add(Order(
                              fb,
                              PaymentMethod.values[
                                  value.data()[USER_ORDER_PAYMENT_METHOD]],
                              DateTime.parse(value.data()[USER_ORDER_DATE]),
                              value.data()[USER_ORDER_TOTAL_PRICE]));
                        });
                      }
                      Provider.of<Orders>(context, listen: false).items =
                          inOrders;
                    });
                    return ProductsScreen();
                  } else {
                    return AuthScreen();
                  }
                },
              );
            }
          },
        ),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routename: (ctx) => UserProductsScreen(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          MessagesScreen.routeName : (ctx) => MessagesScreen(),
        },
      ),
    );
  }
}

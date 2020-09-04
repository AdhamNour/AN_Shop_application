import 'package:AN_shop_application/screens/shopping_screens/ProductShow/ProductDetailsScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'Adding_To_Cart_fav.dart';
import '../../models/shopping_models/product.dart';

class ProductItemWidget extends StatelessWidget {
  final Product _product;
  final bool isListView;
  ProductItemWidget(this._product, this.isListView);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isOwner = _product.ownerID == FirebaseAuth.instance.currentUser.uid;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
              gradient: isOwner
                  ? LinearGradient(colors: [
                      Colors.teal,
                      Colors.cyan[600],
                      Colors.indigoAccent[700]
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : null),
          child: LayoutBuilder(
            builder: (context, constraints) {
              var pictureHight = constraints.minHeight == 0
                  ? screenSize.height / 4
                  : constraints.minHeight;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ProductDetailScreen.routeName,
                          arguments: _product);
                    },
                    child: Stack(
                      children: [
                        Hero(
                          tag: _product.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(imageUrl: _product.imageURL
                              ,fit: BoxFit.cover,
                              height: pictureHight,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error,size: pictureHight,)
                              ,width: double.infinity,
                              ),
                          ),
                        ),
                        if (isListView)
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              width: (screenSize.width - 20) / 2,
                              margin: const EdgeInsets.all(10),
                              child: Text(
                                _product.name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  border: Border.all(
                                      width: 2, color: Colors.black87),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        if (!isListView)
                          Positioned(
                            left: 0.0,
                            bottom: 0.0,
                            right: 0.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              child: GridTileBar(
                                backgroundColor: Colors.black45,
                                title: Text(_product.name),
                                subtitle: Center(
                                  child: Text(
                                    _product.price.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                leading: buildConsumer(context, _product),
                                trailing: IconButton(
                                  icon: Icon(Icons.add_shopping_cart),
                                  onPressed: () => addToCart(context, _product),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  if (isListView)
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Price: ${_product.price}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        )),
                        if (!isOwner)
                          RaisedButton.icon(
                              onPressed: () => addToCart(context, _product),
                              icon: Icon(Icons.add_shopping_cart),
                              label: Text('add to cart')),
                        if (!isOwner) buildConsumer(context, _product)
                      ],
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

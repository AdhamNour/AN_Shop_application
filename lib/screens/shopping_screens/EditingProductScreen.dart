import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/models/shopping_models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = 'EditProductScreen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  Product editingProduct;
  bool isEditing = false;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageURLController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void save() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    if (!isEditing) {
      FirebaseFirestore.instance.collection(PRODUCTS).add({
        PRODUCT_DESCRIPTION: editingProduct.description,
        PRODUCT_IMAGE_URL: editingProduct.imageURL,
        PRODUCT_NAME: editingProduct.name,
        PRODUCT_OWNER_ID: editingProduct.ownerID,
        PRODUCT_PRICE: editingProduct.price,
      });
    } else {
      FirebaseFirestore.instance
          .collection(PRODUCTS)
          .doc(editingProduct.id)
          .set({
        PRODUCT_DESCRIPTION: editingProduct.description,
        PRODUCT_IMAGE_URL: editingProduct.imageURL,
        PRODUCT_NAME: editingProduct.name,
        PRODUCT_OWNER_ID: editingProduct.ownerID,
        PRODUCT_PRICE: editingProduct.price,
      });
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        final Product _product =
            ModalRoute.of(context).settings.arguments as Product;
        if (_product == null) {
          editingProduct = Product(
              name: null,
              imageURL: null,
              id: null,
              description: null,
              price: null,
              ownerID: FirebaseAuth.instance.currentUser.uid);
          isEditing = false;
        } else {
          editingProduct = _product;
          nameController.text = _product.name;
          priceController.text = _product.price.toString();
          descriptionController.text = _product.description;
          imageURLController.text = _product.imageURL;
          isEditing = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isEditing ? 'Editing' : 'Adding'} Prodcut'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: nameController,
                  onSaved: (newValue) => editingProduct.name = newValue,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  validator: (value) =>
                      isNumeric(value) ? null : 'entre a valid number,please',
                  onSaved: (newValue) =>
                      editingProduct.price = double.parse(newValue),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  controller: descriptionController,
                  onSaved: (newValue) => editingProduct.description = newValue,
                  maxLines: null,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: imageURLController.text.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: imageURLController.text,
                                  width: 150,
                                  height: 150,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.error,
                                          size: 50,
                                          color: Theme.of(context).errorColor,
                                        ),
                                        Text('InValid URL')
                                      ],
                                    ),
                                  ),
                                )
                              : FlutterLogo(),
                        ),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(labelText: 'imageURL'),
                        controller: imageURLController,
                        validator: (value) =>
                            isURL(value) ? null : 'not a valid URL',
                        onSaved: (newValue) =>
                            editingProduct.imageURL = newValue,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ))
                    ],
                  ),
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: Icon(Icons.save),
      ),
    );
  }
}

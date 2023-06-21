import 'package:flutter/material.dart';
import 'package:my_shop/models/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  final _imageForm = GlobalKey<FormState>();

  var _product = Product(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    imageURL: "",
  );
  var hasImage = true;
  var _init = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final productId = ModalRoute.of(context)!.settings.arguments;
    if (_init) {
      if (productId != null) {
        final _editingProduct =
            Provider.of<Products>(context).findById(productId as String);
        _product = _editingProduct;
      }
    }
    _init = false;
  }

  // void dispose() {
  //   super.dispose();
  //   _priceFocus.dispose();
  // }
  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Rasm URLini kiriting!"),
          content: Form(
            key: _imageForm,
            child: TextFormField(
              initialValue: _product.imageURL,
              decoration: const InputDecoration(
                labelText: "Rasm URL",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Rasm Urlini kiriting!";
                } else if (!value.startsWith("http")) {
                  return "To'g'ri Url kiriting!";
                }
                return null;
              },
              onSaved: (newValue) {
                _product = Product(
                  id: _product.id,
                  title: _product.title,
                  description: _product.description,
                  price: _product.price,
                  imageURL: newValue!,
                  isFavourite: _product.isFavourite,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Bekor Qilish"),
            ),
            ElevatedButton(
              onPressed: saveImageForm,
              child: const Text("Saqlash"),
            ),
          ],
        );
      },
    );
  }

  void saveImageForm() {
    final isValid = _imageForm.currentState!.validate();
    if (isValid) {
      _imageForm.currentState!.save();
      setState(() {
        hasImage = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _form.currentState!.validate();
    setState(() {
      hasImage = _product.imageURL.isNotEmpty;
    });
    if (isValid && hasImage) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Xatolik"),
                  content:
                      const Text("Mahsulot qo'shishda xatolik sodir bo'ldi!"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Ok"),
                    ),
                  ],
                );
              });
        }

        //     .catchError((error) {
        //   return
        // }).then((_) {

        //  finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // }

        // });
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_product);
        } catch (e) {
          showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Xatolik"),
                  content:
                      const Text("Mahsulot qo'shishda xatolik sodir bo'ldi!"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Ok"),
                    ),
                  ],
                );
              });
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mahsulot Qo'shish"),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), //focusni alish
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(11),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _product.title,
                        decoration: const InputDecoration(
                          labelText: "Nomi",
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mahsulot nomini kiriting!";
                          }
                          return null;
                        },
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_priceFocus);
                        // },
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: newValue!,
                            description: _product.description,
                            price: _product.price,
                            imageURL: _product.imageURL,
                            isFavourite: _product.isFavourite,
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _product.price == 0
                            ? ""
                            : _product.price.toStringAsFixed(2),
                        decoration: const InputDecoration(
                          labelText: "Narxi",
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mahsulot narxini kiriting!";
                          } else if (double.tryParse(value) == null) {
                            return "Narxni to'g'ri kiriting!";
                          } else if (double.parse(value) < 0) {
                            return "Narx manfiy bo'lmaydi!";
                          }
                        },
                        // focusNode: _priceFocus,
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            description: _product.description,
                            price: double.parse(newValue!),
                            imageURL: _product.imageURL,
                            isFavourite: _product.isFavourite,
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _product.description,
                        decoration: const InputDecoration(
                          labelText: "Qo'shimcha ma'lumot",
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Qo'shimcha ma'lumot kiriting!";
                          } else if (value.length < 5) {
                            return "Batafsil ma'lumot kiriting!";
                          }
                        },
                        // focusNode: _priceFocus,
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            description: newValue!,
                            price: _product.price,
                            imageURL: _product.imageURL,
                            isFavourite: _product.isFavourite,
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: hasImage
                                ? Colors.grey
                                : Theme.of(context).errorColor,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _showImageDialog(context),
                          splashColor:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5),
                          highlightColor: Colors.transparent,
                          child: Container(
                            height: 180,
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: _product.imageURL.isEmpty
                                ? Text(
                                    "Asosiy Rasm URLini kiriting!",
                                    style: TextStyle(
                                      color: !hasImage
                                          ? Theme.of(context).errorColor
                                          : Colors.black,
                                    ),
                                  )
                                : Image.network(
                                    _product.imageURL,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

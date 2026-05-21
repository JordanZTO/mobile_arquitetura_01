import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/form_widgets.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product; // null para criar, preenchido para editar
  final ProductService productService;
  final Function(Product) onSave;

  const ProductFormScreen({
    super.key,
    this.product,
    required this.productService,
    required this.onSave,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController imageController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product?.title ?? '');
    priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
    imageController = TextEditingController(text: widget.product?.image ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newProduct = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: titleController.text,
        price: double.parse(priceController.text),
        image: imageController.text,
        description: descriptionController.text,
        category: categoryController.text,
        rating: widget.product?.rating,
      );

      final message = widget.product == null
          ? "Product created successfully!"
          : "Product updated successfully!";

      if (widget.product == null) {
        // Criar novo
        await widget.productService.addProduct(newProduct);
      } else {
        // Atualizar existente
        await widget.productService.updateProduct(newProduct);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      widget.onSave(newProduct);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Product" : "Create Product"),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormTextField(
                label: "Title",
                initialValue: titleController.text,
                onChanged: (value) => titleController.text = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Title is required";
                  }
                  return null;
                },
              ),
              FormTextField(
                label: "Price",
                initialValue: priceController.text,
                keyboardType: TextInputType.number,
                onChanged: (value) => priceController.text = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Price is required";
                  }
                  if (double.tryParse(value!) == null) {
                    return "Price must be a valid number";
                  }
                  return null;
                },
              ),
              FormTextField(
                label: "Category",
                initialValue: categoryController.text,
                onChanged: (value) => categoryController.text = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Category is required";
                  }
                  return null;
                },
              ),
              FormTextField(
                label: "Image URL",
                initialValue: imageController.text,
                onChanged: (value) => imageController.text = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Image URL is required";
                  }
                  return null;
                },
              ),
              FormTextField(
                label: "Description",
                initialValue: descriptionController.text,
                maxLines: 5,
                onChanged: (value) => descriptionController.text = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Description is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleSave,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(isEditing ? Icons.check : Icons.add),
                  label: Text(isEditing ? "Update" : "Create"),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

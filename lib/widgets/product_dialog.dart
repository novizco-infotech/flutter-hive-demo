import 'package:flutter/material.dart';
import 'package:hiveflutter/models/product.dart';

class ProductDialog extends StatefulWidget {
  final Product? product;
  final Function(
    String name,
   // DateTime date,
    double amount,
    //String description,
  ) onClickedDone;

  const ProductDialog({
    Key? key,
    this.product,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  //final descriptionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      final student = widget.product!;
      nameCtrl.text = student.name;
      //dateCtrl.text = student.date.toString();
      amountCtrl.text = student.amount.toString();
     // descriptionCtrl.text = student.description;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    dateCtrl.dispose();
    amountCtrl.dispose();
    //descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final title = isEditing ? 'Edit Product' : 'Add Product';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
              const SizedBox(height: 8),
              buildAmt(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameCtrl,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Product Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter Product Name' : null,
      );

  Widget buildAmt() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Amount',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null
            ? 'Enter a amount'
            : null,
        controller: amountCtrl,
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameCtrl.text;
          //final date = DateTime.tryParse(dateCtrl.text);
          final amount = double.tryParse(amountCtrl.text);
          //final description = descriptionCtrl.text;
          widget.onClickedDone(
            name,
           // date!,
            amount!,
            //description
          );
          Navigator.of(context).pop();
        }
      },
    );
  }
}

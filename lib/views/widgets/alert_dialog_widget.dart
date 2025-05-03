import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meyor_lite/controllers/app_controller.dart';
import 'package:meyor_lite/models/cost_model.dart';
import 'package:provider/provider.dart';

class AlertDialogWidget extends StatefulWidget {
  final CostModel? oldCost;
  const AlertDialogWidget({super.key, this.oldCost});

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isLoading = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.oldCost != null) {
      _nameController.text = widget.oldCost!.costName;
      _amountController.text = widget.oldCost!.costPrice.toString();
      _selectedDate = widget.oldCost!.costDate;
      _dateController.text = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).format(_selectedDate!);
    } else {
      _selectedDate = DateTime.now();
      _dateController.text = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.oldCost == null ? "Xarajat qo`shish" : "Xarajatni o`zgartirish",
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Xarajat nomi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Iltimos xarajat nomini kiriting";
                  }

                  if (value.length < 6) {
                    return "Iltimos batajsil xarajatni kiriting";
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Xarajat miqdori",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Iltimos xarajat miqdorini kiriting";
                  }

                  try {
                    final amount = double.parse(value);
                    if (amount <= 0) {
                      return "Miqdor noldan katta bo'lishi kerak";
                    }
                  } catch (e) {
                    return "Iltimos to'g'ri raqam kiriting";
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              Consumer<AppController>(
                builder: (context, value, child) {
                  return TextFormField(
                    readOnly: true,
                    onTap: () {
                      value.showCalendar(
                        context,
                        _selectedDate,
                        _dateController,
                      );
                    },
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Xarajat kuni",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Iltimos xarajat kunini tanlang";
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              _isLoading
                  ? null // Yuklash paytida o'chirilgan
                  : () => Navigator.pop(context),
          child: Text("Bekor Qilish"),
        ),
        FilledButton(
          onPressed: _isLoading ? null : save,
          child:
              _isLoading
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text("Saqlash"),
        ),
      ],
    );
  }

  void save() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        final title = _nameController.text;
        final date = _selectedDate!;
        final cost = double.parse(_amountController.text);

        if (widget.oldCost == null) {
          await context.read<AppController>().addWallet(
            title: title,
            date: date,
            cost: cost,
          );
        } else {
          final updatedWallet = widget.oldCost!.copyWith(
            costName: title,
            costDate: date,
            costPrice: cost,
          );
          await context.read<AppController>().editWallet(updatedWallet);
        }
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e, s) {
      print(e);
      print(s);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Xatolik yuz berdi: $e"),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

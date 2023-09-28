import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';
import 'package:onfly_app/features/list_expenses/presentation/widgets/custom_button.dart';

import '../../controllers/remote/remote_expenses_controller.dart';

class AddUpdateExpense extends StatelessWidget {
  AddUpdateExpense({
    super.key,
    required this.addExpenseMode,
    required this.expenseEntity,
  });

  final bool addExpenseMode;
  final ExpenseEntity expenseEntity;
  final DateTime selectedDate = DateTime.now();
  final brCurrencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  final _remoteExpensesController = Get.find<RemoteExpensesController>();
  final TextEditingController _textEditingControllerDate =
      TextEditingController();
  final TextEditingController _textEditingControllerAmount =
      TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      expenseEntity.expenseDate =
          _remoteExpensesController.getFormatedDate(picked.toString());
      _textEditingControllerDate.text = expenseEntity.expenseDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          addExpenseMode ? "Add Expense" : "Update Expense",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: expenseEntity.description,
                  decoration: InputDecoration(
                    hintText: !addExpenseMode
                        ? expenseEntity.description
                        : "Expense description",
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (text) => expenseEntity.description = text,
                ),
                TextFormField(
                  controller: _textEditingControllerDate,
                  decoration: InputDecoration(
                    hintText: !addExpenseMode
                        ? _remoteExpensesController
                            .getFormatedDate(expenseEntity.expenseDate!)
                        : "Expense date",
                    suffixIcon: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: const Icon(
                        Icons.calendar_today_outlined,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  onChanged: (text) => expenseEntity.expenseDate = text,
                ),
                TextFormField(
                  controller: _textEditingControllerAmount,
                  decoration: InputDecoration(
                    hintText: !addExpenseMode
                        ? brCurrencyFormat.format(
                            double.parse(expenseEntity.amount.toString()))
                        : "Expense amount",
                  ),
                  keyboardType: TextInputType.number,
                  onEditingComplete: () {
                    _textEditingControllerAmount.text = brCurrencyFormat.format(
                        double.parse(_textEditingControllerAmount.text));
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (text) =>
                      expenseEntity.amount = double.parse(text),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.camera_alt,
                      size: 56,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: addExpenseMode ? "Adicionar" : "Editar",
                        color: Colors.blue,
                        callback: () async {
                          if (addExpenseMode) {
                            if (_remoteExpensesController
                                .checkSubmitAddExpenseForm(expenseEntity)) {
                              if (await _remoteExpensesController
                                  .createExpense(expenseEntity)) {
                                Get.snackbar(
                                  "Successfully created expense",
                                  "Your expense has been created successfully",
                                  backgroundColor: Colors.lightBlue,
                                  icon: const Icon(Icons.check),
                                );
                                Get.toNamed('/');
                              } else {
                                Get.snackbar(
                                  "Error when creating expense",
                                  "Unable to register expense",
                                  backgroundColor: Colors.red,
                                  icon: const Icon(Icons.error),
                                );
                              }
                            } else {
                              Get.snackbar(
                                "Error when creating expense",
                                "Fill all the fields to continue",
                                backgroundColor: Colors.red,
                                icon: const Icon(Icons.error),
                              );
                            }
                          } else {
                            if (await _remoteExpensesController
                                .updateExpense(expenseEntity)) {
                              Get.snackbar(
                                "Successfully updated expense",
                                "Your expense has been updated successfully",
                                backgroundColor: Colors.lightBlue,
                                icon: const Icon(Icons.check),
                              );
                              Get.toNamed('/');
                            } else {
                              Get.snackbar(
                                "Error when updating expense",
                                "Unable to updating expense",
                                backgroundColor: Colors.red,
                                icon: const Icon(Icons.error),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

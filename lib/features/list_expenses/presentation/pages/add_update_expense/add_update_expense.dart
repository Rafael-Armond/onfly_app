import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:onfly_app/features/list_expenses/presentation/widgets/custom_button.dart';

import '../../controllers/remote/remote_expenses_controller.dart';

class AddUpdateExpense extends StatelessWidget {
  AddUpdateExpense({
    super.key,
    required this.addExpenseMode,
    this.description,
    this.expenseDate,
    this.amount,
    this.idExpense,
  });

  final bool addExpenseMode;
  final String? description;
  final String? expenseDate;
  final String? amount;
  final String? idExpense;

  final RemoteExpensesController _remoteExpensesController =
      GetIt.instance<RemoteExpensesController>();

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
                const TextField(
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  keyboardType: TextInputType.text,
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: "Expense Date",
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: "Amount",
                  ),
                  keyboardType: TextInputType.number,
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
                        text: "Adicionar",
                        color: Colors.blue,
                        callback: () async {
                          if (addExpenseMode) {
                            if (await _remoteExpensesController
                                .createExpense()) {
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
                            if (await _remoteExpensesController
                                .updateExpense(idExpense!)) {
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

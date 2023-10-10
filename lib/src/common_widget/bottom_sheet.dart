import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

void dialogModalBottomsheet(
    BuildContext context, String title, Function function) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (context) {
      return Wrap(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            // height: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              children: [
                Text(
                  title.toUpperCase(),
                  style: text(context).titleLarge?.copyWith(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Bạn có chắc chắn muốn $title?',
                  style: text(context)
                      .titleMedium
                      ?.copyWith(color: colorScheme(context).onTertiary),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 238, 238, 238),
                                elevation: 8,
                                shape: (RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(130)))),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'KHÔNG',
                              style: text(context).titleSmall?.copyWith(
                                  color: colorScheme(context).onTertiary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                elevation: 8,
                                shape: (RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(130)))),
                            onPressed: () {
                              function();
                            },
                            child: Text(
                              title.toUpperCase(),
                              style: text(context).titleSmall?.copyWith(
                                  color: colorScheme(context).tertiary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

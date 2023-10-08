import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';

class giohang_admin extends StatefulWidget {
  final String tenban;
  const giohang_admin({
    super.key,
    required this.tenban,
  });

  @override
  State<giohang_admin> createState() => _giohang_adminState();
}

class _giohang_adminState extends State<giohang_admin> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 2,
          )),
      child: Column(
        children: [
          Center(
            child: Text("Bàn số ${widget.tenban}"),
          ),
          StreamBuilder(
            stream: FirestoreHelper.readgiohang(widget.tenban),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("lỗi"),
                );
              }
              if (snapshot.hasData) {
                final giohang = snapshot.data;
                return Container(
                  width: double.infinity,
                  height: SizeConfig.screenHeight / 1.5,
                  child: ListView.builder(
                    itemCount: giohang!.length,
                    itemBuilder: (context, index) {
                      final giohangindex = giohang[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: getProportionateScreenWidth(20),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F6F9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Image.network(
                                    giohangindex.hinhanh,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    giohangindex.tensp,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "\ ${giohangindex.giasp}",
                                      children: [
                                        TextSpan(
                                            text: "x ${giohangindex.soluong}")
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  "  VND: ${giohangindex.soluong * giohangindex.giasp}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    ));
  }
}

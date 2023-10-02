// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
import 'package:managerfoodandcoffee/src/firebasehelper/firebasestore_helper.dart';

class giohangUser extends StatefulWidget {
  final String tenban;
  const giohangUser({
    Key? key,
    required this.tenban,
  }) : super(key: key);

  @override
  State<giohangUser> createState() => _giohangUserState();
}

class _giohangUserState extends State<giohangUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Giỏ Hàng bàn ${widget.tenban}"),
          centerTitle: true,
        ),
        body: StreamBuilder(
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
              return ListView.builder(
                itemCount: giohang!.length,
                itemBuilder: (context, index) {
                  final giohangindex = giohang[index];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(88),
                          child: AspectRatio(
                            aspectRatio: 0.88,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F6F9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.network(giohangindex.hinhanh),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(20),
                        ),
                        Column(
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
                                  TextSpan(text: "x ${giohangindex.soluong}")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}

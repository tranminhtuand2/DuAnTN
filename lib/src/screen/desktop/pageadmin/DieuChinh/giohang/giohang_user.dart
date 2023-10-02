// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:managerfoodandcoffee/src/constants/size.dart';
import 'package:managerfoodandcoffee/src/controller/alertthongbao.dart';
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
  TextEditingController makm = TextEditingController();
  int tongtienthanhtoan = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tongtienthanhtoan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ Hàng bàn ${widget.tenban}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(22)),
                height: SizeConfig.screenHeight * 0.8,
                child: StreamBuilder(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      child:
                                          Image.network(giohangindex.hinhanh),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(20),
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
                                IconButton(
                                    onPressed: () {
                                      FirestoreHelper.deletegiohang(
                                          giohangindex, widget.tenban);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 200,
                        child: StreamBuilder(
                          stream: FirestoreHelper.readgiohang(widget.tenban),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              tongtienthanhtoan = 0;
                              final tongtiengh = snapshot.data;
                              for (var i = 0; i < tongtiengh!.length; i++) {
                                tongtienthanhtoan +=
                                    tongtiengh[i].giasp * tongtiengh[i].soluong;
                              }
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("nhập mã"),
                                        SizedBox(
                                          width: SizeConfig.screenWidth * 0.6,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.confirmation_num))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("số tiền cần thanh toán:"),
                                        Text("${tongtienthanhtoan} VND"),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                child: Text("xem hoá đơn"),
              ),
            )

            // Container(
            //   height: SizeConfig.screenHeight * 0.2,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(22),
            //     color: Theme.of(context).colorScheme.secondaryContainer,
            //   ),
            //   child: Row(
            //     children: [TextFormField()],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

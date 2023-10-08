import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerLoading() {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 18.0,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 18.0,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 14.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 140,
                  width: 100,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

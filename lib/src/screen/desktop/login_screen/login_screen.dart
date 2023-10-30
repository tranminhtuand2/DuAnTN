import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/login_screen/widget/login_panel.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/login_screen/widget/register_panel.dart';
import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 126, 126, 126), BlendMode.overlay),
                fit: BoxFit.cover,
                scale: 1,
                image: AssetImage('/images/br_login.jpg'),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.1,
            bottom: size.height * 0.1,
            right: size.width * 0.15,
            left: size.width * 0.15,
            child: Card(
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: size.width * 0.6,
                  height: size.height * 0.7,
                  child: Row(
                    children: [
                      Expanded(
                        child: widgetLeft(context),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          color: colorScheme(context).primary,
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: isLogin
                              ? LoginPanel(
                                  onTapTitle: (value) {
                                    setState(() {
                                      isLogin = value;
                                    });
                                  },
                                )
                              : RegisterPanel(
                                  onTapTitle: (value) {
                                    setState(() {
                                      isLogin = value;
                                    });
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack widgetLeft(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Image.asset(
            'assets/images/bgdesktop.jpg',
            filterQuality: FilterQuality.none,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(160, 0, 0, 0),
                Color.fromARGB(160, 0, 0, 0)
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Lottie.asset(
                  "assets/images/logocf.json",
                  animate: true,
                  height: 100,
                  width: 100,
                ),
                Text(
                  "Wind Coffee",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme(context).tertiary,
                      fontFamily: GoogleFonts.aboreto().fontFamily),
                ),
              ],
            ),
            const Spacer(),
            FittedBox(
              child: Text(
                "Hương thơm đắm say \ncảm xúc đậm đà",
                style: text(context).displayMedium?.copyWith(
                    letterSpacing: 1.5,
                    color: colorScheme(context).tertiary,
                    fontFamily: GoogleFonts.pacifico().fontFamily),
              ),
            ),
            const SizedBox(height: 100),
          ],
        )
      ],
    );
  }
}

class BtnLogin extends StatelessWidget {
  final String urlImage;
  final String title;
  final Color color;
  final Color colorTitle;
  final Function? onClick;
  const BtnLogin({
    super.key,
    required this.urlImage,
    required this.title,
    required this.color,
    this.onClick,
    required this.colorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick?.call();
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Colors.blue),
            ),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: text(context).titleSmall?.copyWith(color: colorTitle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: cacheNetWorkImage(
              urlImage,
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

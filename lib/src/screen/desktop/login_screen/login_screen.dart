import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:managerfoodandcoffee/src/common_widget/cache_image.dart';
import 'package:managerfoodandcoffee/src/common_widget/input_field.dart';
import 'package:managerfoodandcoffee/src/common_widget/my_button.dart';
import 'package:managerfoodandcoffee/src/controller_getx/google_signin_controller.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/admin_panel.dart';
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
    // ignore: no_leading_underscores_for_local_identifiers
    final _controllerUsername = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    final _controllerPassword = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     Color.fromARGB(251, 148, 251, 251),
              //     Color.fromARGB(255, 102, 171, 178),
              //     Color.fromARGB(255, 183, 124, 238),
              //     Color.fromARGB(255, 213, 101, 170),
              //   ],
              // ),
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
                              ? SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Chào mừng quay lại \nHãy đăng nhập để bắt đầu ',
                                        style: text(context)
                                            .titleLarge
                                            ?.copyWith(
                                                fontFamily:
                                                    GoogleFonts.spaceGrotesk()
                                                        .fontFamily,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      InputField(
                                          controller: _controllerUsername,
                                          inputType: TextInputType.emailAddress,
                                          labelText: 'Email',
                                          prefixIcon: const Icon(Icons.email),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Vui lòng điền vào địa chỉ email";
                                            }
                                            if (!RegExp(
                                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                                .hasMatch(value)) {
                                              return "Địa chỉ email không hợp lệ";
                                            }
                                            return null;
                                          }),
                                      const SizedBox(height: 20),
                                      InputField(
                                        controller: _controllerPassword,
                                        inputType: TextInputType.text,
                                        prefixIcon: const Icon(Icons.lock),
                                        labelText: 'Nhập mật khẩu',
                                        maxLines: 1,
                                        isPassword: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Vui lòng điền vào mật khẩu";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MyButton(
                                        onTap: () {
                                          Get.to(
                                              () => const AdminPanelScreen());
                                        },
                                        backgroundColor: colorScheme(context)
                                            .onSurfaceVariant,
                                        height: 54,
                                        text: Text(
                                          'Đăng nhập',
                                          style: text(context)
                                              .titleSmall
                                              ?.copyWith(
                                                  color: colorScheme(context)
                                                      .tertiary,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isLogin = !isLogin;
                                                });
                                              },
                                              child: Text(
                                                'Đăng ký ngay',
                                                textAlign: TextAlign.left,
                                                style: text(context)
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color:
                                                            colorScheme(context)
                                                                .tertiary),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Text(
                                                'Quên mật khẩu?',
                                                textAlign: TextAlign.right,
                                                style: text(context)
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color:
                                                            colorScheme(context)
                                                                .tertiary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 10),
                                      BtnLogin(
                                        color: Colors.transparent,
                                        title: "Đăng nhập với Google",
                                        colorTitle:
                                            colorScheme(context).tertiary,
                                        urlImage:
                                            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png',
                                        onClick: () {
                                          Get.put(GoogleSignInController())
                                              .loginGoogleInWeb();
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Đăng ký để sử dụng dịch vụ ',
                                        style: text(context)
                                            .titleLarge
                                            ?.copyWith(
                                                fontFamily:
                                                    GoogleFonts.spaceGrotesk()
                                                        .fontFamily,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      InputField(
                                          controller: _controllerUsername,
                                          inputType: TextInputType.emailAddress,
                                          labelText: 'Email',
                                          prefixIcon: const Icon(Icons.email),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Vui lòng điền vào địa chỉ email";
                                            }
                                            if (!RegExp(
                                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                                .hasMatch(value)) {
                                              return "Địa chỉ email không hợp lệ";
                                            }
                                            return null;
                                          }),
                                      const SizedBox(height: 20),
                                      InputField(
                                          controller: _controllerUsername,
                                          inputType: TextInputType.text,
                                          labelText: 'Họ và tên',
                                          prefixIcon: const Icon(Icons.email),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Vui lòng điền vào địa chỉ email";
                                            }
                                            if (!RegExp(
                                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                                .hasMatch(value)) {
                                              return "Địa chỉ email không hợp lệ";
                                            }
                                            return null;
                                          }),
                                      const SizedBox(height: 20),
                                      InputField(
                                        controller: _controllerPassword,
                                        inputType: TextInputType.text,
                                        prefixIcon: const Icon(Icons.lock),
                                        labelText: 'Nhập mật khẩu',
                                        maxLines: 1,
                                        isPassword: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Vui lòng điền vào mật khẩu";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InputField(
                                        controller: _controllerPassword,
                                        inputType: TextInputType.text,
                                        prefixIcon: const Icon(Icons.lock),
                                        labelText: 'Nhập lại mật khẩu',
                                        maxLines: 1,
                                        isPassword: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Vui lòng điền vào mật khẩu";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MyButton(
                                        onTap: () {
                                          // Get.to(
                                          //     () => const AdminPanelScreen());
                                        },
                                        backgroundColor: colorScheme(context)
                                            .onSurfaceVariant,
                                        height: 54,
                                        text: Text(
                                          'Đăng ký',
                                          style: text(context)
                                              .titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isLogin = !isLogin;
                                            });
                                          },
                                          child: Text(
                                            'Đăng nhập ngay',
                                            textAlign: TextAlign.right,
                                            style: text(context)
                                                .titleSmall
                                                ?.copyWith(
                                                    color: colorScheme(context)
                                                        .tertiary),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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

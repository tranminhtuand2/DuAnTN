import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerfoodandcoffee/src/controller_getx/auth_controller.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebase_auth.dart';

import 'package:managerfoodandcoffee/src/utils/colortheme.dart';
import 'package:managerfoodandcoffee/src/utils/texttheme.dart';

class PermissionUser extends StatefulWidget {
  const PermissionUser({super.key});

  @override
  State<PermissionUser> createState() => _PermissionUserState();
}

class _PermissionUserState extends State<PermissionUser> {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 16, left: 16, right: 8, bottom: 16),
                    decoration: BoxDecoration(
                        color: colorScheme(context).onPrimary,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                authController.urlAvatar.value != ''
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            authController.urlAvatar.value),
                                      )
                                    : const CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/avatar.png'),
                                      ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        authController.userName.value == ""
                                            ? 'Khách'
                                            : 'Hi, ${authController.userName.value}',
                                        overflow: TextOverflow.ellipsis,
                                        style: text(context)
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(authController.emailUser.value,
                                          overflow: TextOverflow.ellipsis,
                                          style: text(context).titleSmall)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: buttonRole(
                                backgroundColor:
                                    colorScheme(context).onSurfaceVariant,
                                context: context,
                                role: authController.role.value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 16, left: 8, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                        color: colorScheme(context).onPrimary,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Icon(CupertinoIcons.lock),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                  color: colorScheme(context).onPrimary,
                  borderRadius: BorderRadius.circular(8)),
              child: StreamBuilder(
                stream: FireBaseAuth.readUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ListView.builder(
                        itemCount: user!.length,
                        itemBuilder: (context, index) {
                          if (user[index].email ==
                              authController.emailUser.value) {
                            return const SizedBox();
                          }

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                                color: colorScheme(context).primary,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(user[index].email,
                                      overflow: TextOverflow.ellipsis,
                                      style: text(context)
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal)),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: buttonRole(
                                              onTap: () {
                                                authController.updateRole(
                                                    email: user[index].email,
                                                    role: 'admin');
                                              },
                                              backgroundColor:
                                                  user[index].role == 'admin'
                                                      ? colorScheme(context)
                                                          .onSurfaceVariant
                                                      : colorScheme(context)
                                                          .onPrimary,
                                              context: context,
                                              role: 'admin')),
                                      Expanded(
                                          child: buttonRole(
                                              onTap: () {
                                                authController.updateRole(
                                                    email: user[index].email,
                                                    role: 'user');
                                              },
                                              backgroundColor:
                                                  user[index].role == 'user'
                                                      ? colorScheme(context)
                                                          .onSurfaceVariant
                                                      : colorScheme(context)
                                                          .onPrimary,
                                              context: context,
                                              role: 'user')),
                                      Expanded(
                                          child: buttonRole(
                                              onTap: () {
                                                authController.updateRole(
                                                    email: user[index].email,
                                                    role: 'guest');
                                              },
                                              backgroundColor:
                                                  user[index].role == 'guest'
                                                      ? colorScheme(context)
                                                          .onSurfaceVariant
                                                      : colorScheme(context)
                                                          .onPrimary,
                                              context: context,
                                              role: 'guest')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell buttonRole({
    required BuildContext context,
    required String role,
    required Color backgroundColor,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(24)),
        child: Text(role.toUpperCase(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: text(context).titleSmall),
      ),
    );
  }
}

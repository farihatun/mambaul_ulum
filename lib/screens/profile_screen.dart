import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  String nama = "Loading...";
  String email = "Loading...";

  final String baseUrl =
      "http://192.168.1.10:8000/api";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs =
        await SharedPreferences.getInstance();

    setState(() {
      nama =
          prefs.getString('nama') ??
          "Farihatun Aini";

      email =
          prefs.getString('email') ??
          "user@gmail.com";
    });
  }

  Future<void> updateProfileApi(
    String newNama,
    String newEmail,
    String newPassword,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    int userId =
        prefs.getInt('user_id') ?? 0;

    final response = await http.post(
      Uri.parse(
        '$baseUrl/profile/update/$userId',
      ),
      body: {
        'name': newNama,
        'email': newEmail,
        'password': newPassword,
      },
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data['success'] == true) {
      await prefs.setString(
        'nama',
        newNama,
      );

      await prefs.setString(
        'email',
        newEmail,
      );

      setState(() {
        nama = newNama;
        email = newEmail;
      });

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              data['message'],
            ),
            backgroundColor:
                Colors.green,
          ),
        );
      }
    } else {
      throw Exception(
        data['message'],
      );
    }
  }

  void editProfil() {
    final namaController =
        TextEditingController(
      text: nama,
    );

    final emailController =
        TextEditingController(
      text: email,
    );

    final passwordController =
        TextEditingController();

    bool hidden = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              title: const Text(
                "Edit Profil",
              ),
              content:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          namaController,
                      decoration:
                          const InputDecoration(
                        labelText: "Nama",
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller:
                          emailController,
                      decoration:
                          const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller:
                          passwordController,
                      obscureText:
                          hidden,
                      decoration:
                          InputDecoration(
                        labelText:
                            "Password Baru",
                        prefixIcon:
                            const Icon(
                          Icons.lock,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed: () {
                            setDialogState(
                              () {
                                hidden =
                                    !hidden;
                              },
                            );
                          },
                          icon: Icon(
                            hidden
                                ? Icons.visibility
                                : Icons
                                    .visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    "Batal",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await updateProfileApi(
                      namaController.text,
                      emailController.text,
                      passwordController.text,
                    );

                    if (mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
                  },
                  child: const Text(
                    "Simpan",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget infoCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              const Color(
                0xFF1FA463,
              ).withOpacity(0.15),
          child: Icon(
            icon,
            color:
                const Color(0xFF0F6B3E),
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget statCard(
    String angka,
    String title,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color:
                  const Color(0xFF0F6B3E),
            ),
            const SizedBox(height: 8),
            Text(
              angka,
              style:
                  const TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            Text(
              title,
              style:
                  const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                ),
                decoration:
                    const BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      Color(
                        0xFF0B5D35,
                      ),
                      Color(
                        0xFF1FA463,
                      ),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.only(
                    bottomLeft:
                        Radius.circular(
                      35,
                    ),
                    bottomRight:
                        Radius.circular(
                      35,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 90,
                        height: 90,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      nama,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style:
                          const TextStyle(
                        color:
                            Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        statCard(
                          "6",
                          "Menu",
                          Icons.apps,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        statCard(
                          "24",
                          "Modul",
                          Icons.menu_book,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        statCard(
                          "100%",
                          "Aktif",
                          Icons.check_circle,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    infoCard(
                      Icons.person,
                      "Nama",
                      nama,
                    ),

                    infoCard(
                      Icons.email,
                      "Email",
                      email,
                    ),

                    infoCard(
                      Icons.lock,
                      "Password",
                      "••••••••",
                    ),

                    infoCard(
                      Icons.school,
                      "Status",
                      "Santri Aktif",
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      height: 50,
                      child:
                          ElevatedButton.icon(
                        onPressed:
                            editProfil,
                        icon: const Icon(
                          Icons.edit,
                        ),
                        label: const Text(
                          "Edit Profil",
                        ),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF0F6B3E,
                          ),
                          foregroundColor:
                              Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
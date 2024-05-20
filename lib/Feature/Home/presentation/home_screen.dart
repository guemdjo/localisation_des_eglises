import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:localisation_des_eglise/Core/theme/palette.dart';
import 'package:localisation_des_eglise/Feature/auth/presentation/pages/login_page.dart';
import 'package:localisation_des_eglise/Feature/dependencies.dart';
import 'package:localisation_des_eglise/google_map_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = serviceLocator<SupabaseClient>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("localisation des eglise"),
        actions: [
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (xtc) {
                return const LoginPage();
              }));
            },
            icon: const Icon(IconsaxOutline.logout),
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMapPage(),
            Positioned(
              bottom: -70,
              right: 0,
              left: 0,
              child: Container(
                height: 250,
                width: MediaQuery.sizeOf(context).width * 0.99,
                decoration: BoxDecoration(
                  color: AppPallete.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 44,
                      // color: Colors.redAccent,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: TextField(
                        decoration: InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: "Search",
                            hintStyle: const TextStyle(color: Colors.black54),
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            prefixIcon: const Icon(
                              IconsaxOutline.search_normal_1,
                              size: 18,
                            )),
                        // cursorHeight: 20,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

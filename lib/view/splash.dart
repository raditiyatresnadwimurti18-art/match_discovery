// import 'package:flutter/material.dart';
// // import 'package:flutter_ppkd_r_1/extension/navigator.dart';
// import 'package:flutter_ppkd_r_1/tugas_flutter11/database/preference.dart';
// import 'package:flutter_ppkd_r_1/tugas_flutter11/home_t_6.dart';
// import 'package:flutter_ppkd_r_1/tugas_flutter11/login.dart';
// import 'package:flutter_ppkd_r_1/tugas_flutter11/login1.dart';
// import 'package:flutter_ppkd_r_1/extension/navigator.dart';

// class SplashscreenT16 extends StatefulWidget {
//   const SplashscreenT16({super.key});

//   @override
//   State<SplashscreenT16> createState() => _SplashscreenT16State();
// }

// class _SplashscreenT16State extends State<SplashscreenT16> {
//   @override
//   void initState() {
//     super.initState();
//     autoLogin();
//   }

//   void autoLogin() async {
//     await Future.delayed(Duration(seconds: 2));
//     bool? data = await PreferenceHandler.getIsLogin();
//     // print(data);
//     // print("Hai, Joshua");

//     if (data == true) {
//       context.pushAndRemoveAll(HomeT6(text: 'nama', text2: 'kota'));
//     } else {
//       context.pushAndRemoveAll(Login6());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),

//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(height: 200),
//             Image.asset('assets/images/logof1.png', height: 200),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Discovery',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 28,
//                     color: Color(0xffcdb060),
//                   ),
//                 ),
//                 Text(
//                   'Match',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 28,
//                     color: Color(0xff112955),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:virtual_wallet_2/screens/home/SwitchHome.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:virtual_wallet_2/widgets/widgets.dart';

// class Recharger extends StatefulWidget {
//   const Recharger({super.key});

//   @override
//   State<Recharger> createState() => _RechargerState();
// }

// class _RechargerState extends State<Recharger> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.grey.shade100,
//       body: SafeArea(
//           child: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           padding: EdgeInsets.symmetric(vertical: 10),
//           child: Column(
//             children: [
//               _top(),
//               const SizedBox(
//                 height: 20,
//               ),

//               // Recharge
//               const Text(
//                 'Rechargements',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Column(
//                 children: [
//                   _Rechargement(),
//                 ],
//               )
//             ],
//           ),
//         ),
//       )),
//     );
//   }

//   Widget _top() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'My',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   'dépots',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Container(
//             padding: const EdgeInsets.all(0),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: IconButton(
//               icon: Icon(Iconsax.back_square, color: Colors.black),
//               iconSize: 24,
//               onPressed: () => wPushReplaceTo(context, BankApp(index: 0)),
//             ))
//       ]),
//     );
//   }

//   Widget _Btn(iconImagePath, buttonText) {
//     return Column(
//       children: [
//         // icon
//         Container(
//           height: 90,
//           padding: EdgeInsets.all(4),
//           decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(color: Colors.white, blurRadius: 30, spreadRadius: 10)
//               ]),
//           child: Center(
//             child: Image.asset(
//               iconImagePath,
//             ),
//           ),
//         ),
//         SizedBox(height: 4),
//         // text
//         Text(
//           buttonText,
//           style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700]),
//         ),
//       ],
//     );
//   }

//   Widget _Rechargement() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               _Btn("images/Airtel.png", "Airtel Money"),
//               const SizedBox(width: 20),
//               _Btn("images/Zamani.png", "Zamani Cash"),
//               const SizedBox(width: 20),
//               _Btn("images/Moov.png", "Moov Flooz"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

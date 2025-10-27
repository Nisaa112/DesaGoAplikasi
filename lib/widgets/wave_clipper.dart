import 'package:flutter/material.dart';

// Clipper #1: Untuk latar belakang halaman Welcome
class TopArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    final double curveStartHeight = size.height * 0.30;
    final double curvePeakY = 30.0; 

    path.moveTo(0, curveStartHeight);
    path.quadraticBezierTo(
      size.width / 2,   
      curvePeakY,       
      size.width,       
      curveStartHeight  
    );
    path.lineTo(size.width, size.height); 
    path.lineTo(0, size.height);        
    path.close();                       
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}


// Clipper #2: Untuk kartu Pemasukan/Pengeluaran di halaman Home
class WaveClipper extends CustomClipper<Path> {
  final bool isIncome;

  WaveClipper({required this.isIncome});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (isIncome) {
      // Path untuk kartu Pemasukan (gelombang di kiri)
      path.moveTo(0, 0);
      path.lineTo(size.width * 0.45, 0);
      path.cubicTo(
        size.width * 0.7, size.height * 0.3,
        size.width * 0.2, size.height * 0.7,
        size.width * 0.35, size.height,
      );
      path.lineTo(0, size.height);
      path.close();
    } else {
      // Path untuk kartu Pengeluaran (gelombang di kanan, terbalik)
      path.moveTo(size.width, 0);
      path.lineTo(size.width * 0.55, 0);
      path.cubicTo(
        size.width * 0.3, size.height * 0.3,
        size.width * 0.8, size.height * 0.7,
        size.width * 0.65, size.height,
      );
      path.lineTo(size.width, size.height);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
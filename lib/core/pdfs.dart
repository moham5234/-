import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/entities/appointment_entity.dart';

class print_PDF {
  static String title = '';
  static String date = '';
  static List<AppointmentEntity> appointments = [];

  static late pw.Font arFont;

  static Future<void> init() async {
    arFont = pw.Font.ttf(await rootBundle.load(
        "Assets/fonts/alfont_com_AlFont_com_DINNextLTArabic-Regular-4.ttf"));
  }

  static void prepareData({
    required String title_,
    required String date_,
    required List<AppointmentEntity> appointmentList,
  }) {
    title = title_;
    date = date_;
    appointments = appointmentList;
  }

  static Future<void> createPdf({required String fileName}) async {
    await init();

    Directory downloadDir = Directory('/storage/emulated/0/Download');
    String path = '${downloadDir.path}/$fileName.pdf';
    File file = File(path);

    pw.Document pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      textDirection: pw.TextDirection.rtl,
      theme: pw.ThemeData.withFont(base: arFont),
      build: (context) =>
      [
        pw.Column(
          children: [
            pw.Container(
              alignment: pw.Alignment.topRight,
              margin: const pw.EdgeInsets.only(top: 30),
              child: pw.Text(
                title,
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey700),

              children: [
                pw.TableRow(
decoration: pw.BoxDecoration(
  color: PdfColors.blueGrey
),
                  children: [
                    for (var header in [
                      "ملاحظات",
                      "تاريخ ووقت الموعد",
                      "الاسم",
                    ])
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          header,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                      ),
                  ],
                ),
                ...appointments.map((a) {
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: appointments.indexOf(a) % 2 == 0
                          ? PdfColor.fromHex("#D7E1E8FF")
                          : PdfColor.fromHex("#FFFFFFFF"),

                  border: pw.TableBorder.all(color: PdfColor.fromHex("#D7E1E8FF")),
                    ),
                    children: [

                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "${a.phone ?? ''}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "${a.dateTime ?? ''} ",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "${a.name ?? ''}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ],
    ));

    Uint8List bytes = await pdf.save();
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }
}
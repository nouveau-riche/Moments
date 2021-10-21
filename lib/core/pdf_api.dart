import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

import '../models/inventory_details_model.dart';
import '../models/inventory_model.dart';

class PdfApi {
  static Future<File> generatePdf(
      {List<InventoryDetailModel> list, InventoryModel inventoryModel}) async {
    final document = PdfDocument();

    final page = document.pages.add();

    drawGrid(document, page, list, inventoryModel, document);

    return await saveFile(document);
  }

  static void drawNameAndDate(PdfPage page, InventoryModel inventoryModel) {
    final pageSize = page.getClientSize();

    page.graphics.drawString(
        '_____________', PdfStandardFont(PdfFontFamily.helvetica, 15),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(0, pageSize.height - 135, 0, 40));

    page.graphics.drawString(
        'Signature', PdfStandardFont(PdfFontFamily.helvetica, 15),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(0, pageSize.height - 115, 0, 40));

    page.graphics.drawString(
        inventoryModel.title, PdfStandardFont(PdfFontFamily.helvetica, 15),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(0, pageSize.height - 60, 0, 40));

    page.graphics.drawString(
        '${DateFormat().add_yMMMd().format(DateTime.now())}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(0, pageSize.height - 85, 100, 40));
  }

  static void drawGrid(
    PdfDocument document,
    PdfPage page,
    List<InventoryDetailModel> list,
    InventoryModel inventoryModel,
    PdfDocument doc,
  ) async {
    var grid = PdfGrid();
    grid.columns.add(count: 5);

    final headerRow = grid.headers.add(1)[0];

    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(247, 245, 255, 1));
    headerRow.style.textBrush = PdfBrushes.black;

    headerRow.cells[0].value = 'Name';
    headerRow.cells[1].value = 'Street';
    headerRow.cells[2].value = 'City';
    headerRow.cells[3].value = 'State';
    headerRow.cells[4].value = 'Zipcode';
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    final row = grid.rows.add();
    row.cells[0].value = inventoryModel.title;
    row.cells[1].value = inventoryModel.street;
    row.cells[2].value = inventoryModel.city;
    row.cells[3].value = inventoryModel.state;
    row.cells[4].value = inventoryModel.zip;

    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.borders.all = PdfPens.white;

      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, top: 5);
    }

    addStylingToGrid(grid);

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 25, 0, 0),
    );

    var grid1 = PdfGrid();
    grid1.columns.add(count: 6);

    double ht = 100;

    final headerRow1 = grid1.headers.add(1)[0];

    headerRow1.style.backgroundBrush =
        PdfSolidBrush(PdfColor(247, 245, 255, 1));
    headerRow1.style.textBrush = PdfBrushes.black;

    headerRow1.cells[0].value = 'Image';
    headerRow1.cells[1].value = 'Description';
    headerRow1.cells[2].value = 'History';
    headerRow1.cells[3].value = 'Gift';
    headerRow1.cells[4].value = 'Address';
    headerRow1.cells[5].value = 'Relationship';

    headerRow1.style.font = PdfStandardFont(
      PdfFontFamily.helvetica,
      12,
      style: PdfFontStyle.bold,
    );

    var row1;

    list.forEach((element) async {
      final PdfBitmap image = PdfBitmap(element.byteData.buffer.asUint8List());

      row1 = grid1.rows.add();
      row1.cells[0].style.backgroundImage = image;
      row1.cells[1].value = element.description;
      row1.cells[2].value = element.history;
      row1.cells[3].value = element.gift;
      row1.cells[4].value = element.address;
      row1.cells[5].value = element.relationship;
    });

    for (int i = 0; i < headerRow1.cells.count; i++) {
      headerRow1.cells[i].style.borders.all = PdfPens.white;

      headerRow1.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, top: 5, right: 5);
    }

    addStylingToGrid(grid1);

    grid1.draw(
      page: page,
      bounds: Rect.fromLTWH(0, ht, 0, 0),
    );

    int pageCount = document.pages.count;

    drawNameAndDate(document.pages[pageCount - 1], inventoryModel);
  }

  static Future<File> saveFile(PdfDocument document) async {
    final path = await getApplicationDocumentsDirectory();

    String fileName =
        path.path + '/Memorandum${DateTime.now().toIso8601String()}.pdf';
    final file = File(fileName);

    file.writeAsBytes(document.save());
    document.dispose();
    return file;
  }

  static void addStylingToGrid(PdfGrid grid) {
    for (int i = 0; i < grid.rows.count; i++) {
      var row1 = grid.rows[i];

      for (int j = 0; j < row1.cells.count; j++) {
        final cell = row1.cells[j];

        row1.height = 75;
        cell.style.borders.all = PdfPens.white;

        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, top: 5, right: 5);
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:calculdevis/Poutrelle.dart';
import 'package:calculdevis/Hourdis.dart';
import 'package:calculdevis/Agglos.dart';
import 'package:calculdevis/my_drawer_header.dart';
import 'package:calculdevis/DrawerList.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/widgets.dart' show Font;
import 'package:flutter/services.dart'; 
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'; 

class SixthPage extends StatefulWidget {
  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage> {
  double totalControleTechnique = 0.0;
  double totalTs = 0.0;
  double totalHt = 0.0;
  double totalTva = 0.0;
  double totalTtc = 0.0;
  double totalEtrierCost = 0.0;
  double totalPoutrelle = 0.0;
  double totalHourdis = 0.0;
  double totalAgglos = 0.0;
  double totalTranport = 0.0;
  double storedValue = 0.0;
  double controleTechniquePrice = 0.0;

  double storedValueTs = 0.0;
  double tsPrice = 0.0;

  Future<void> _calculateValues() async {
    await _calculateTotalEtrierCost();
    await _calculateTotalTs();
    await _calculateTotalControleTechnique();
    await _calculateTotalHt();
    await _calculateTotalTva();
    await _calculateTransport();
    _calculateTotalTtc();
    
  }

  @override
  void initState() {
    super.initState();
    _calculateValues();
  }

  Future<void> generatePDF() async {
    final pdf = pdfWidgets.Document();
    final fontData =
        await DefaultAssetBundle.of(context).load("assets/Roboto-Regular.ttf");
    final robotoFont = Font.ttf(fontData);
    final logo =
        (await rootBundle.load('assets/images/logo.jpeg')).buffer.asUint8List();

    String title = await getTitleFromSharedPreferences();
    pdf.addPage(
      pdfWidgets.Page(
        build: (pdfWidgets.Context context) {
          return pdfWidgets.Container(
            decoration: pdfWidgets.BoxDecoration(
              border: pdfWidgets.Border.all(width: 1.0),
              borderRadius:
                  const pdfWidgets.BorderRadius.all(pdfWidgets.Radius.circular(1.0)),
            ),
            child: pdfWidgets.Column(
              children: [
                pdfWidgets.Row(
                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfWidgets.Image(pdfWidgets.MemoryImage(logo), width: 35),
                    pdfWidgets.Image(pdfWidgets.MemoryImage(logo), width: 35),
                    
                     
                  ],
                ),
                 pdfWidgets.Padding(
                    padding: const pdfWidgets.EdgeInsets.only( bottom: 10),
                    child: pdfWidgets.Text(
                      title, // Use the retrieved title here
                      style: pdfWidgets.TextStyle(
                        font: robotoFont,
                        fontSize: 15, // Adjust font size as needed
                        fontWeight: pdfWidgets.FontWeight.bold,
                      ),
                    ),
                  ),
                pdfWidgets.Table(
                  children: [
                    pdfWidgets.TableRow(
                      children: [
                        for (var header in [
                          'Type',
                          'Longueur',
                          'Etrier',
                          'Nombre',
                          'Prix ml',
                          'Prix',
                          'Total'
                        ])
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              header,
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust the font size as needed
                              ),
                            ),
                          ),
                      ],
                    ),
                    for (var poutrelle in Poutrelle.poutrelles)
                      pdfWidgets.TableRow(
                        children: [
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(poutrelle.type),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              poutrelle.longueur.toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              poutrelle.nbEtrier.toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              poutrelle.nombre.toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              poutrelle.prix.toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              poutrelle.calculateCost().toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              (poutrelle.calculateCost() * poutrelle.nombre)
                                  .toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                        ],
                      ),
                    pdfWidgets.TableRow(
                      children: [
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "etrier",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            Poutrelle.nbEtrierTotal.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            Poutrelle.PrixUnitaireEtrier.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            totalEtrierCost.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var hourdis in Hourdis.hourdisList)
                      pdfWidgets.TableRow(
                        children: [
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              hourdis.type,
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              "",
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              "",
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              hourdis.number.toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              "",
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              hourdis.calculateCost().toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              (hourdis.calculateCost() * hourdis.number)
                                  .toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),

                        ],
                      ),
 for (var agg in Agglos.agglos)
                      pdfWidgets.TableRow(
                        children: [
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              agg.type,
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              "",
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              "",
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              agg.quantity.toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              "",
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              agg.calculateCost().toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),
                          pdfWidgets.Padding(
                            padding: const pdfWidgets.EdgeInsets.all(4),
                            child: pdfWidgets.Text(
                              (agg.calculateCost() * agg.quantity)
                                  .toString(),
                              style: pdfWidgets.TextStyle(
                                font: robotoFont,
                                fontSize: 10, // Adjust font size as needed
                              ),
                            ),
                          ),

                        ],
                      ),
                      

                       pdfWidgets.TableRow(
                      children: [
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "Controle Technique",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            storedValue.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            controleTechniquePrice.toString(), //6aeazeeae
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            totalControleTechnique.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ],
                    ),
                      


                      pdfWidgets.TableRow(
                      children: [
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "Treilles Soudees",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            storedValueTs.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            tsPrice.toString(), //6aeazeeae
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            totalTs.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ],
                    ),

                      pdfWidgets.TableRow(
                      children: [
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "Transport ",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "", //6aeazeeae
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            totalTranport.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ],
                    ),

                    pdfWidgets.TableRow(
                      children: [
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "Totla Ht",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "", //6aeazeeae
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            totalHt.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ],
                    ),

                    pdfWidgets.TableRow(
                      children: [
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "TVA",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "", //6aeazeeae
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            totalTva.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ],
                    ),
                    pdfWidgets.TableRow(
                      children: [
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "Totla TTC",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "",
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            "", //6aeazeeae
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                        pdfWidgets.Padding(
                          padding: const pdfWidgets.EdgeInsets.all(4),
                          child: pdfWidgets.Text(
                            totalTtc.toString(),
                            style: pdfWidgets.TextStyle(
                              font: robotoFont,
                              fontSize: 10, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    //final bytes = await pdf.save();
    // Get the directory where the PDF will be saved
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    //final file = File("example.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open("${output.path}/example.pdf");
  }


  Future<void> _calculateTotalEtrierCost() async {
    double etrierCost = await Poutrelle.calculateTotalEtrierCost();

    setState(() {
      totalEtrierCost = etrierCost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Prix Total',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Controle technique:'),
            trailing: Text('$totalControleTechnique '),
          ),
          ListTile(
            title: const Text('Ts:'),
            trailing: Text('$totalTs '),
          ),
          ListTile(
            title: const Text('Total Poutrelle:'),
            trailing: Text('$totalPoutrelle '),
          ),
          ListTile(
            title: const Text('Total Hourdis:'),
            trailing: Text('$totalHourdis '),
          ),

          ListTile(
            title: const Text('Total Agglos:'),
            trailing: Text('$totalAgglos '),
          ),
          ListTile(
            title: const Text('Total Cost of Etriers:'),
            trailing: Text('$totalEtrierCost '),
          ),
          ListTile(
            title: const Text('Transport :'),
            trailing: Text('$totalTranport '),
          ),
         
          ListTile(
            title: const Text('Total HT:'),
            trailing: Text('$totalHt '),
          ),
          ListTile(
            title: const Text('TVA:'),
            trailing: Text('$totalTva '),
          ),
          ListTile(
            title: const Text('TOTAL TTC:'),
            trailing: Text('$totalTtc'),
          ),
          ElevatedButton(
            onPressed: () {
              generatePDF();
            },
            child: const Text('Generate PDF'),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/fifthScreen');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Précédent', style: TextStyle(fontSize: 19)),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyHeaderDrawer(),
              DrawerList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _calculateTotalTs() async {
     tsPrice = await getTsPriceFromFirestore(); // Retrieve tsPrice
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedValueTs =
        prefs.getDouble('TreilleSoudee') ?? 0.0; // Retrieve stored value

    setState(() {
      totalTs = tsPrice * storedValueTs; // Calculate totalTs
    });
  }

  Future<double> _calculateTransport() async {
    double po = await Poutrelle.calculateTotalTransportCost();
    double ho = await Hourdis.calculateTotalTransportCost();
    double ag = await Agglos.calculateTotalTransportCost();
    setState(() {
       totalTranport = po + ho + ag; // Calculate totalTs
    });
   
   return totalTranport;
  }


  static Future<double> getTsPriceFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('otherSettings') // Change to your collection name
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String treilleSoudeePriceString = data['TreillesSoudees'];
        double treilleSoudeePrice = double.parse(treilleSoudeePriceString);

        return treilleSoudeePrice;
      } else {
        return 0.0; // Default value if document doesn't exist
      }
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> calculateTotalPricePoutrelle() async {
    double totalPrice = 0.0;
    double remise = await Poutrelle.getRemiseValueFromFirestore() ?? 0.0;
    for (var poutrelle in Poutrelle.poutrelles) {
      totalPrice += poutrelle.calculateCost();
    }
    totalPrice = totalPrice - totalPrice * remise / 100;
    return totalPrice;
  }

  Future<double> calculateTotalPriceHourdis() async {
    double totalPrice = 0.0;
    double remise = await Hourdis.getRemiseValueFromFirestore() ?? 0.0;
    for (var hourdis in Hourdis.hourdisList) {
      totalPrice += hourdis.calculateCost();
    }
    totalPrice = totalPrice - totalPrice * remise / 100;
    return totalPrice;
  }
Future<double> calculateTotalPriceAgglos() async {
    double totalPrice = 0.0;
    double remise = await Agglos.getRemiseValueFromFirestore() ?? 0.0;
    for (var agg in Agglos.agglos) {
      totalPrice += agg.calculateCost();
    }
    totalPrice = totalPrice - totalPrice * remise / 100;
    return totalPrice;
  }






  Future<void> _calculateTotalHt() async {
    double totalPoutrellePrice = await calculateTotalPricePoutrelle();

    double totalHourdisPrice = await calculateTotalPriceHourdis();

    double totalAgglosPrice = await calculateTotalPriceAgglos();

  

    setState(() {
      totalHt = totalPoutrellePrice +
          totalHourdisPrice +
          totalAgglosPrice +
          totalEtrierCost +
          totalControleTechnique +
          totalTranport +
          totalTs;
      totalAgglos= totalAgglosPrice;
      totalHourdis = totalHourdisPrice;
      totalPoutrelle = totalPoutrellePrice;
    });


    
  }

  Future<void> _calculateTotalTva() async {
    double tvaPercentage = await getTvaPercentageFromFirestore();
    double totalTvaAmount = (totalHt * tvaPercentage) / 100;

    setState(() {
      totalTva = totalTvaAmount;
    });
  }

//function to get the title from sharedpreferences



  static Future<double> getTvaPercentageFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('otherSettings') // Change to your collection name
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String tvaPercentageString = data['tva'];
        double tvaPercentage = double.parse(tvaPercentageString);

        return tvaPercentage;
      } else {
        return 0.0; // Default value if document doesn't exist
      }
    } catch (e) {
      return 0.0;
    }
  }
Future<String> getTitleFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String title = prefs.getString('titreDevis') ?? 'Default Title'; // Default title if not found
  return title;
}


  Future<void> _calculateTotalControleTechnique() async {
     controleTechniquePrice =
        await getControleTechniquePriceFromFirestore(); // Retrieve Controle technique price
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedValue = prefs.getDouble('ControleTechnique') ?? 0.0; // Retrieve stored value

    setState(() {
      totalControleTechnique = controleTechniquePrice *
          storedValue; 
    });
  }

  void _calculateTotalTtc() {
    setState(() {
      totalTtc = totalHt + totalTva;
    });
  }

  static Future<double> getControleTechniquePriceFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('otherSettings') // Change to your collection name
          .doc('settings')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String controleTechniquePriceString = data['ControleTechnique'];
        double controleTechniquePrice =
            double.parse(controleTechniquePriceString);

        return controleTechniquePrice;
      } else {
        return 0.0; // Default value if document doesn't exist
      }
    } catch (e) {
      return 0.0;
    }
  }
}

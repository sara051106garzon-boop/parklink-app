import 'package:flutter/material.dart';
import '../../app_theme.dart';

class VigilanteIncidentsScreen extends StatefulWidget {
  const VigilanteIncidentsScreen({Key? key}) : super(key: key);

  @override
  State<VigilanteIncidentsScreen> createState() => _VigilanteIncidentsScreenState();
}

class _VigilanteIncidentsScreenState extends State<VigilanteIncidentsScreen> {
  final _placaController = TextEditingController();
  final _detalleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        title: const Text("Reportar Incidencia", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Detalle de la Novedad", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _placaController,
                    decoration: AppTheme.inputStyle("Placa involucrada (Opcional)", Icons.badge_outlined),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _detalleController,
                    maxLines: 4,
                    decoration: AppTheme.inputStyle("Descripción de la novedad o falla...", Icons.notes),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Incidencia enviada al Administrador")),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Enviar Reporte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
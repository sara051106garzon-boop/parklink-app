import 'package:flutter/material.dart';
import '../../app_theme.dart';

class FormularioVisitantesScreen extends StatefulWidget {
  const FormularioVisitantesScreen({super.key});

  @override
  State<FormularioVisitantesScreen> createState() => _FormularioVisitantesScreenState();
}

class _FormularioVisitantesScreenState extends State<FormularioVisitantesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _documentoController = TextEditingController();
  final _destinoController = TextEditingController();
  final _anfitrionController = TextEditingController();
  final _placaController = TextEditingController();

  bool _traeVehiculo = false;
  bool _cargando = false;

  void _registrarVisitante() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _cargando = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 28),
            SizedBox(width: 10),
            Text("Visitante Registrado", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
        content: Text("${_nombreController.text} fue registrado(a) exitosamente."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Aceptar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        title: const Text("Registro de Visitantes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Datos del Visitante", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nombreController,
                      decoration: AppTheme.inputStyle("Nombre completo", Icons.person_outline_rounded),
                      validator: (v) => (v == null || v.isEmpty) ? "Ingresa el nombre" : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _documentoController,
                      keyboardType: TextInputType.number,
                      decoration: AppTheme.inputStyle("Número de documento", Icons.badge_outlined),
                      validator: (v) => (v == null || v.isEmpty) ? "Ingresa el documento" : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _destinoController,
                      decoration: AppTheme.inputStyle("Destino (empresa / piso / torre)", Icons.apartment_outlined),
                      validator: (v) => (v == null || v.isEmpty) ? "Ingresa el destino" : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _anfitrionController,
                      decoration: AppTheme.inputStyle("Persona que autoriza / anfitrión", Icons.how_to_reg_outlined),
                      validator: (v) => (v == null || v.isEmpty) ? "Ingresa el anfitrión" : null,
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      value: _traeVehiculo,
                      onChanged: (val) => setState(() => _traeVehiculo = val),
                      activeColor: AppTheme.primary,
                      contentPadding: EdgeInsets.zero,
                      title: const Text("¿Ingresa con vehículo?", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                    ),
                    if (_traeVehiculo) ...[
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _placaController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: AppTheme.inputStyle("Placa del vehículo", Icons.directions_car_outlined),
                        validator: (v) => (_traeVehiculo && (v == null || v.isEmpty)) ? "Ingresa la placa" : null,
                      ),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _cargando ? null : _registrarVisitante,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _cargando
                            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text("Registrar Visitante", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

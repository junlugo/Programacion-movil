import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import '../../config/images.dart';
import '../../config/textstyle.dart';
import '../../controller/reserva_controller.dart';
import '../../model/sitema_reservas.dart';

class TopUpScreen extends StatelessWidget {
  TopUpScreen({Key? key}) : super(key: key);

  final ReservaController controller = Get.find<ReservaController>();

  Future<bool?> mostrarConfirmacion(BuildContext context, String mensaje) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar"),
        content: Text(mensaje),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Sí")),
        ],
      ),
    );
  }

  void mostrarPagoConTarjeta(BuildContext context, Reservahistorial reserva) async {
    final confirm = await mostrarConfirmacion(context, "¿Deseas confirmar el pago de esta reserva?");
    if (confirm != true) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Método de Pago", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const ListTile(
                leading: Icon(Icons.credit_card, color: Colors.blue),
                title: Text("Tarjeta de Crédito"),
                subtitle: Text("Único método disponible"),
              ),
              const SizedBox(height: 10),
              Text("Monto a pagar: ₲${reserva.monto}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.pagarReserva(reserva);
                    Navigator.pop(context);
                    Get.back(); // Cierra el modal y la pantalla de confirmación
                    Get.snackbar("Pago exitoso", "La reserva fue pagada correctamente",
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Confirmar Pago", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.isLightTheme == false
          ? HexColor('#15141f')
          : HexColor(AppTheme.primaryColorString!),
      body: SafeArea(
        child: Obx(() {
          // Filtramos solo reservas pendientes (no pagadas)
          final pendientes = controller.historialReservas.where((r) => !r.pagado).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      "Reservas Pendientes",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: pendientes.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay reservas pendientes",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: pendientes.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final reserva = pendientes[index];
                          return Card(
                            color: AppTheme.isLightTheme == false
                                ? const Color(0xff323045)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Auto: ${reserva.auto.chapa}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("Piso: ${reserva.piso.descripcion}"),
                                  Text("Lugar: ${reserva.lugar.descripcionLugar}"),
                                  Text(
                                    "Horario: ${reserva.inicio.hour.toString().padLeft(2, '0')}:${reserva.inicio.minute.toString().padLeft(2, '0')} - ${reserva.salida.hour.toString().padLeft(2, '0')}:${reserva.salida.minute.toString().padLeft(2, '0')}",
                                  ),
                                  Text("Monto: ${reserva.monto} Gs"),
                                  Text("Motivo: ${reserva.motivo.descripcion}"),
                                  Text("Estado: ${reserva.pagado ? "Pagado" : "Pendiente"}"),
                                  if (reserva.pagado && reserva.fechaPago != null)
                                    Text("Pagado el: ${DateFormat('dd/MM/yyyy HH:mm').format(reserva.fechaPago!)}"),
                                  const SizedBox(height: 12),
                                  if (!reserva.pagado)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              mostrarPagoConTarjeta(context, reserva);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            child: const Text("Pagar"),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              final confirm = await mostrarConfirmacion(
                                                  context, "¿Seguro que deseas cancelar esta reserva?");
                                              if (confirm == true) {
                                                controller.cancelarReserva(reserva);
                                                Get.snackbar("Reserva cancelada",
                                                    "La reserva fue cancelada correctamente",
                                                    snackPosition: SnackPosition.BOTTOM);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text("Cancelar"),
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

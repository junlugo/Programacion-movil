import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/images.dart';
import '../../config/textstyle.dart';
import '../../controller/reserva_controller.dart';
import '../../model/sitema_reservas.dart';

class TopUpScreen extends StatelessWidget {
  TopUpScreen({Key? key}) : super(key: key);

  final ReservaController controller = Get.find<ReservaController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.isLightTheme == false
          ? HexColor('#15141f')
          : HexColor(AppTheme.primaryColorString!),
      body: SafeArea(
        child: Obx(() {
          final historial = controller.historialReservas;

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
                child: historial.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay reservas pendientes",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: historial.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final reserva = historial[index];
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
                                    Text("Pagado el: ${reserva.fechaPago}"),
                                  const SizedBox(height: 12),
                                  if (!reserva.pagado)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              controller.pagarReserva(reserva);
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
                                            onPressed: () {
                                              controller.cancelarReserva(reserva);
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

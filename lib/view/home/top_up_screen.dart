import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpSCreen extends StatefulWidget {
  const TopUpSCreen({Key? key}) : super(key: key);
  @override
  State<TopUpSCreen> createState() => _TopUpSCreenState();
}

class _TopUpSCreenState extends State<TopUpSCreen> {
  // Variables para control de selección
  int selectedParkingIndex = 0;
  String selectedPaymentMethod = 'QR';

  // Opciones de estacionamiento con monto en guaraníes
  final List<Map<String, dynamic>> parkingOptions = [
    {'name': 'Piso N° 1 - Nl 1', 'duration': '4 horas', 'amount': 40000},
    {'name': 'Piso N° 2 - Nl 2', 'duration': '5 horas', 'amount': 50000},
    {'name': 'Piso N° 3 - Nl 3', 'duration': '3 hora', 'amount': 30000},
  ];

  // Métodos de pago disponibles
  final List<String> paymentMethods = ['QR', 'Transferencia', 'Tarjeta'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.isLightTheme == false
          ? HexColor('#15141f')
          : HexColor(AppTheme.primaryColorString!),
      body: SafeArea(
        child: Column(
          children: [
            // Parte superior fija
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
                    "Reserva de Estacionamiento",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 24), // Para balancear el icono atrás
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Opciones de estacionamiento
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: parkingOptions.length,
                itemBuilder: (context, index) {
                  final option = parkingOptions[index];
                  final isSelected = selectedParkingIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedParkingIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? HexColor(AppTheme.primaryColorString!)
                            : (AppTheme.isLightTheme == false ? const Color(0xff323045) : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? HexColor(AppTheme.primaryColorString!)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : HexColor(AppTheme.primaryColorString!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.local_parking,
                              color: isSelected
                                  ? HexColor(AppTheme.primaryColorString!)
                                  : Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option['name'],
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: isSelected ? Colors.white : null,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Duración: ${option['duration']}",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: isSelected ? Colors.white70 : Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${option['amount'].toString()} Gs",
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: isSelected ? Colors.white : null,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Método de pago
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.isLightTheme == false
                    ? const Color(0xff211F32)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selecciona método de pago",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.isLightTheme == false ? Colors.white : Colors.black,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: paymentMethods.map((method) {
                      final isSelected = selectedPaymentMethod == method;
                      IconData iconData;
                      switch (method) {
                        case 'QR':
                          iconData = Icons.qr_code;
                          break;
                        case 'Efectivo':
                          iconData = Icons.money;
                          break;
                        case 'Tarjeta':
                          iconData = Icons.credit_card;
                          break;
                        default:
                          iconData = Icons.payment;
                      }
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = method;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? HexColor(AppTheme.primaryColorString!)
                                : (AppTheme.isLightTheme == false ? const Color(0xff323045) : Colors.grey[200]),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? HexColor(AppTheme.primaryColorString!) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(iconData, size: 32, color: isSelected ? Colors.white : Colors.grey[600]),
                              const SizedBox(height: 6),
                              Text(
                                method,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Botón confirmar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor(AppTheme.primaryColorString!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        final selectedOption = parkingOptions[selectedParkingIndex];
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Confirmar Pago"),
                            content: Text(
                                "Estacionamiento: ${selectedOption['name']}\n"
                                "Duración: ${selectedOption['duration']}\n"
                                "Monto: ${selectedOption['amount']} Gs\n"
                                "Método de pago: $selectedPaymentMethod"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Aquí puedes agregar la lógica para procesar el pago
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pago realizado con éxito')),
                                  );
                                },
                                child: const Text("Confirmar"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "Confirmar pago",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

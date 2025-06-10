import 'package:finpay/model/motivo_visita.dart';
import 'package:get/get.dart';
import 'package:finpay/api/local.db.service.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:collection/collection.dart'; // para usar firstOrNull

class Reservahistorial {
  final String codigoReservaAsociada;
  final Auto auto;
  final Piso piso;
  final Lugar lugar;
  final DateTime inicio;
  final DateTime salida;
  final int monto;
  final MotivoVisita motivo;

  bool pagado;
  DateTime? fechaPago;

  Reservahistorial({
    required this.codigoReservaAsociada,
    required this.auto,
    required this.piso,
    required this.lugar,
    required this.inicio,
    required this.salida,
    required this.monto,
    required this.motivo,
    this.pagado = false,
    this.fechaPago,
  });
}

class ReservaDB {
  final String codigoReserva;
  final DateTime horarioInicio;
  final DateTime horarioSalida;
  final double monto;
  final String estadoReserva;
  final String chapaAuto;

  ReservaDB({
    required this.codigoReserva,
    required this.horarioInicio,
    required this.horarioSalida,
    required this.monto,
    required this.estadoReserva,
    required this.chapaAuto,
  });

  factory ReservaDB.fromJson(Map<String, dynamic> json) {
    return ReservaDB(
      codigoReserva: json['codigoReserva'],
      horarioInicio: DateTime.parse(json['horarioInicio']),
      horarioSalida: DateTime.parse(json['horarioSalida']),
      monto: (json['monto'] is int) ? (json['monto'] as int).toDouble() : json['monto'].toDouble(),
      estadoReserva: json['estadoReserva'],
      chapaAuto: json['chapaAuto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoReserva': codigoReserva,
      'horarioInicio': horarioInicio.toIso8601String(),
      'horarioSalida': horarioSalida.toIso8601String(),
      'monto': monto,
      'estadoReserva': estadoReserva,
      'chapaAuto': chapaAuto,
    };
  }
}

class ReservaController extends GetxController {
  final db = LocalDBService();

  RxList<Piso> pisos = <Piso>[].obs;
  Rx<Piso?> pisoSeleccionado = Rx<Piso?>(null);
  RxList<Lugar> lugaresDisponibles = <Lugar>[].obs;
  Rx<Lugar?> lugarSeleccionado = Rx<Lugar?>(null);
  Rx<DateTime?> horarioInicio = Rx<DateTime?>(null);
  Rx<DateTime?> horarioSalida = Rx<DateTime?>(null);
  RxInt duracionSeleccionada = 0.obs;
  RxList<Auto> autosCliente = <Auto>[].obs;
  Rx<Auto?> autoSeleccionado = Rx<Auto?>(null);
  final historialReservas = <Reservahistorial>[].obs;
  // Acá agregás el getter:
  List<Reservahistorial> get reservasPendientesDePago =>
      historialReservas.where((r) => !r.pagado).toList();

  RxList<MotivoVisita> motivos = <MotivoVisita>[].obs;
  Rx<MotivoVisita?> motivoSeleccionado = Rx<MotivoVisita?>(null);
  RxList<ReservaDB> reservasPendientes = <ReservaDB>[].obs;
  

  RxInt pagosDelMes = 0.obs;
  RxInt pagosPendientes = 0.obs;
  RxInt cantidadAutos = 0.obs;
  RxList<Reservahistorial> pagosPrevios = <Reservahistorial>[].obs;

  String codigoClienteActual = 'cliente_1';

  @override
  void onInit() {
    super.onInit();
    resetearCampos();
    cargarAutosDelCliente();
    cargarPisosYLugares();
    cargarMotivos();
    cargarReservasGuardadas();
  }

  Future<void> cargarReservasGuardadas() async {
    try {
      final rawReservas = await db.getAll("reservas.json");
      final reservas = rawReservas.map((e) => ReservaDB.fromJson(e)).toList();

      // Mapear reservas a historial con datos completos
      // Para simplificar, aquí se asume que puedes obtener Auto, Piso, Lugar y Motivo desde tu base local
      // Esto debe ajustarse según tu modelo y lógica real de recuperación

      // Ejemplo rápido de conversión sin los objetos completos, se puede mejorar si tienes métodos para recuperar estos datos
      historialReservas.clear();
      for (var r in reservas) {
        final auto = autosCliente.firstWhereOrNull((a) => a.chapa == r.chapaAuto);
        final lugar = lugaresDisponibles.firstWhereOrNull((l) => l.codigoLugar == r.codigoReserva); // Aquí ajusta según corresponda
        // Piso y motivo a recuperar con lógica propia, o pasar null o datos dummy si no disponible
        if (auto != null && lugar != null) {
          historialReservas.add(Reservahistorial(
            codigoReservaAsociada: r.codigoReserva,
            auto: auto,
            piso: Piso(codigo: lugar.codigoPiso, descripcion: '', lugares: []), // Dummy piso
            lugar: lugar,
            inicio: r.horarioInicio,
            salida: r.horarioSalida,
            monto: r.monto.toInt(),
            motivo: motivos.firstOrNull ?? MotivoVisita(codigo: 0, descripcion: 'Sin motivo'), // Dummy motivo
            pagado: r.estadoReserva == "PAGADO",
            fechaPago: r.estadoReserva == "PAGADO" ? DateTime.now() : null,
          ));
        }
      }

      reservasPendientes.assignAll(reservas.where((r) => r.estadoReserva == "PENDIENTE").toList());

      calcularEstadisticas();
    } catch (e) {
      print("Error cargando reservas guardadas: $e");
    }
  }

  Future<void> pagarReserva(Reservahistorial reserva) async {
    try {
      reserva.pagado = true;
      reserva.fechaPago = DateTime.now();

      final index = reservasPendientes.indexWhere((r) =>
          r.chapaAuto == reserva.auto.chapa &&
          r.horarioInicio.isAtSameMomentAs(reserva.inicio));
      if (index != -1) {
        reservasPendientes[index] = ReservaDB(
          codigoReserva: reservasPendientes[index].codigoReserva,
          horarioInicio: reserva.inicio,
          horarioSalida: reserva.salida,
          monto: reserva.monto.toDouble(),
          estadoReserva: "PAGADO",
          chapaAuto: reserva.auto.chapa,
        );
        await db.saveAll(
          "reservas.json",
          reservasPendientes.map((r) => r.toJson()).toList(),
        );
      }

      calcularEstadisticas();
    } catch (e) {
      print("Error al pagar reserva: $e");
    }
  }

  Future<void> cancelarReserva(Reservahistorial reserva) async {
    try {
      reserva.lugar.estado = "DISPONIBLE";
      historialReservas.remove(reserva);

      reservasPendientes.removeWhere((r) =>
          r.chapaAuto == reserva.auto.chapa &&
          r.horarioInicio.isAtSameMomentAs(reserva.inicio));

      final reservasActualizadas =
          reservasPendientes.map((r) => r.toJson()).toList();
      await db.saveAll("reservas.json", reservasActualizadas);

      final lugares = await db.getAll("lugares.json");
      final index = lugares.indexWhere(
          (l) => l['codigoLugar'] == reserva.lugar.codigoLugar);
      if (index != -1) {
        lugares[index]['estado'] = "DISPONIBLE";
        await db.saveAll("lugares.json", lugares);
      }

      await cargarPisosYLugares();

      calcularEstadisticas();
    } catch (e) {
      print("Error al cancelar reserva: $e");
    }
  }

  void resetearCampos() {
    pisoSeleccionado.value = null;
    lugarSeleccionado.value = null;
    horarioInicio.value = null;
    horarioSalida.value = null;
    duracionSeleccionada.value = 0;
    autoSeleccionado.value = null;
    motivoSeleccionado.value = null;
  }

  Future<void> cargarMotivos() async {
    try {
      final data = await rootBundle.loadString('assets/data/motivos.json');
      final List<dynamic> jsonResult = json.decode(data);
      motivos.value = jsonResult.map((e) => MotivoVisita.fromJson(e)).toList();
    } catch (e) {
      print("Error al cargar motivos: $e");
    }
  }

  Future<void> cargarAutosDelCliente() async {
    final rawAutos = await db.getAll("autos.json");
    final autos = rawAutos.map((e) => Auto.fromJson(e)).toList();
    autosCliente.value =
        autos.where((a) => a.clienteId == codigoClienteActual).toList();

    calcularEstadisticas();
  }

  Future<void> cargarPisosYLugares() async {
    final rawPisos = await db.getAll("pisos.json");
    final rawLugares = await db.getAll("lugares.json");
    final rawReservas = await db.getAll("reservas.json");

    final reservas = rawReservas.map((e) => ReservaDB.fromJson(e)).toList();

    final todosLugares = rawLugares.map((e) => Lugar.fromJson(e)).toList();

    pisos.value = rawPisos.map((pJson) {
      final codigoPiso = pJson['codigo'];
      final lugaresDelPiso =
          todosLugares.where((l) => l.codigoPiso == codigoPiso).toList();
      return Piso(
        codigo: codigoPiso,
        descripcion: pJson['descripcion'],
        lugares: lugaresDelPiso,
      );
    }).toList();

    lugaresDisponibles.value = todosLugares.where((l) {
      return l.estado != "RESERVADO";
    }).toList();
  }

  void seleccionarPiso(Piso piso) {
    pisoSeleccionado.value = piso;
    lugarSeleccionado.value = null;
    lugaresDisponibles.value = piso.lugares.where((lugar) {
      return lugar.estado != "RESERVADO";
    }).toList();
  }

  Future<bool> confirmarReserva() async {
    if (pisoSeleccionado.value == null ||
        lugarSeleccionado.value == null ||
        horarioInicio.value == null ||
        horarioSalida.value == null ||
        autoSeleccionado.value == null ||
        motivoSeleccionado.value == null) {
      return false;
    }

    final duracionEnHoras =
        horarioSalida.value!.difference(horarioInicio.value!).inMinutes / 60;
    if (duracionEnHoras <= 0) return false;

    final montoCalculado = (duracionEnHoras * 10000).round();

    final reserva = Reservahistorial(
      codigoReservaAsociada: "RES-${DateTime.now().millisecondsSinceEpoch}",
      auto: autoSeleccionado.value!,
      piso: pisoSeleccionado.value!,
      lugar: lugarSeleccionado.value!,
      inicio: horarioInicio.value!,
      salida: horarioSalida.value!,
      monto: montoCalculado,
      motivo: motivoSeleccionado.value!,
    );

    final yaExiste = historialReservas.any((r) =>
        r.auto.chapa == reserva.auto.chapa &&
        r.lugar.codigoLugar == reserva.lugar.codigoLugar &&
        r.inicio.isAtSameMomentAs(reserva.inicio));

    if (!yaExiste) {
      historialReservas.add(reserva);
    } else {
      final index = historialReservas.indexWhere((r) =>
          r.auto.chapa == reserva.auto.chapa &&
          r.lugar.codigoLugar == reserva.lugar.codigoLugar &&
          r.inicio.isAtSameMomentAs(reserva.inicio));
      if (index != -1) historialReservas[index] = reserva;
    }

    calcularEstadisticas();

    final nuevaReservaDB = ReservaDB(
      codigoReserva: reserva.codigoReservaAsociada,
      horarioInicio: reserva.inicio,
      horarioSalida: reserva.salida,
      monto: reserva.monto.toDouble(),
      estadoReserva: "PENDIENTE",
      chapaAuto: reserva.auto.chapa,
    );

    try {
      final reservasGuardadas = await db.getAll("reservas.json");
      final reservasFiltradas = reservasGuardadas.where((r) {
        final reservaMap = Map<String, dynamic>.from(r);
        return !(reservaMap['chapaAuto'] == nuevaReservaDB.chapaAuto &&
            DateTime.parse(reservaMap['horarioInicio'])
                .isAtSameMomentAs(nuevaReservaDB.horarioInicio) &&
            DateTime.parse(reservaMap['horarioSalida'])
                .isAtSameMomentAs(nuevaReservaDB.horarioSalida));
      }).toList();

      reservasFiltradas.add(nuevaReservaDB.toJson());
      await db.saveAll("reservas.json", reservasFiltradas);

      final lugares = await db.getAll("lugares.json");
      final index = lugares.indexWhere(
          (l) => l['codigoLugar'] == lugarSeleccionado.value!.codigoLugar);
      if (index != -1) {
        lugares[index]['estado'] = "RESERVADO";
        await db.saveAll("lugares.json", lugares);
      }

      reservasPendientes.assignAll(
          reservasFiltradas.map((e) => ReservaDB.fromJson(e)).toList());

      await cargarPisosYLugares();

      resetearCampos();
      return true;
    } catch (e) {
      print("Error al guardar reserva: $e");
      return false;
    }
  }

  void calcularEstadisticas() {
    cantidadAutos.value = autosCliente.length;

    final ahora = DateTime.now();

    pagosDelMes.value = historialReservas.where((r) =>
        r.pagado &&
        r.fechaPago != null &&
        r.fechaPago!.year == ahora.year &&
        r.fechaPago!.month == ahora.month).fold<int>(0, (sum, r) => sum + r.monto);

    pagosPendientes.value = historialReservas.where((r) => !r.pagado)
        .fold<int>(0, (sum, r) => sum + r.monto);

    pagosPrevios.value = historialReservas.where((r) => r.pagado).toList();
  }
}

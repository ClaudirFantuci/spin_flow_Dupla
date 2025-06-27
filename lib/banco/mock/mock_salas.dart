import 'package:spin_flow/dto/dto_sala.dart';

List<DTOSala> mockSalas = [
  DTOSala(
    id: 1,
    nome: 'Sala Spinning Principal',
    numeroBikes: 20,
    numeroFilas: 4,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
    ],
    ativa: true,
  ),
  DTOSala(
    id: 2,
    nome: 'Sala Spinning Compacta',
    numeroBikes: 12,
    numeroFilas: 3,
    limiteBikesPorFila: 4,
    gradeBikes: [
      [false, true, false, false], // Fila 0 (professora)
      [true, true, true, true],    // Fila 1
      [true, true, true, true],    // Fila 2
      [true, true, true, true],    // Fila 3
    ],
    ativa: true,
  ),
  DTOSala(
    id: 3,
    nome: 'Sala Spinning Premium',
    numeroBikes: 25,
    numeroFilas: 5,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
      [true, true, true, true, true],     // Fila 5
    ],
    ativa: true,
  ),
  DTOSala(
    id: 4,
    nome: 'Sala Spinning Express',
    numeroBikes: 8,
    numeroFilas: 2,
    limiteBikesPorFila: 4,
    gradeBikes: [
      [false, true, false, false], // Fila 0 (professora)
      [true, true, true, true],    // Fila 1
      [true, true, true, true],    // Fila 2
    ],
    ativa: true,
  ),
  DTOSala(
    id: 5,
    nome: 'Sala Spinning Elite',
    numeroBikes: 30,
    numeroFilas: 6,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
      [true, true, true, true, true],     // Fila 5
      [true, true, true, true, true],     // Fila 6
    ],
    ativa: true,
  ),
  DTOSala(
    id: 6,
    nome: 'Sala Spinning Studio',
    numeroBikes: 15,
    numeroFilas: 3,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
    ],
    ativa: true,
  ),
  DTOSala(
    id: 7,
    nome: 'Sala Spinning Power',
    numeroBikes: 18,
    numeroFilas: 4,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
    ],
    ativa: true,
  ),
  DTOSala(
    id: 8,
    nome: 'Sala Spinning Energy',
    numeroBikes: 22,
    numeroFilas: 5,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
      [true, true, true, true, true],     // Fila 5
    ],
    ativa: true,
  ),
  DTOSala(
    id: 9,
    nome: 'Sala Spinning Core',
    numeroBikes: 10,
    numeroFilas: 2,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
    ],
    ativa: true,
  ),
  DTOSala(
    id: 10,
    nome: 'Sala Spinning Max',
    numeroBikes: 35,
    numeroFilas: 7,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
      [true, true, true, true, true],     // Fila 5
      [true, true, true, true, true],     // Fila 6
      [true, true, true, true, true],     // Fila 7
    ],
    ativa: true,
  ),
  DTOSala(
    id: 11,
    nome: 'Sala Spinning Pro',
    numeroBikes: 16,
    numeroFilas: 4,
    limiteBikesPorFila: 4,
    gradeBikes: [
      [false, true, false, false], // Fila 0 (professora)
      [true, true, true, true],    // Fila 1
      [true, true, true, true],    // Fila 2
      [true, true, true, true],    // Fila 3
      [true, true, true, true],    // Fila 4
    ],
    ativa: true,
  ),
  DTOSala(
    id: 12,
    nome: 'Sala Spinning Fit',
    numeroBikes: 14,
    numeroFilas: 3,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
    ],
    ativa: true,
  ),
  DTOSala(
    id: 13,
    nome: 'Sala Spinning Turbo',
    numeroBikes: 24,
    numeroFilas: 5,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
      [true, true, true, true, true],     // Fila 5
    ],
    ativa: true,
  ),
  DTOSala(
    id: 14,
    nome: 'Sala Spinning Rush',
    numeroBikes: 12,
    numeroFilas: 3,
    limiteBikesPorFila: 4,
    gradeBikes: [
      [false, true, false, false], // Fila 0 (professora)
      [true, true, true, true],    // Fila 1
      [true, true, true, true],    // Fila 2
      [true, true, true, true],    // Fila 3
    ],
    ativa: true,
  ),
  DTOSala(
    id: 15,
    nome: 'Sala Spinning Force',
    numeroBikes: 20,
    numeroFilas: 4,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
    ],
    ativa: true,
  ),
  DTOSala(
    id: 16,
    nome: 'Sala Spinning Pulse',
    numeroBikes: 18,
    numeroFilas: 4,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
    ],
    ativa: true,
  ),
  DTOSala(
    id: 17,
    nome: 'Sala Spinning Drive',
    numeroBikes: 26,
    numeroFilas: 6,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
      [true, true, true, true, true],     // Fila 5
      [true, true, true, true, true],     // Fila 6
    ],
    ativa: true,
  ),
  DTOSala(
    id: 18,
    nome: 'Sala Spinning Boost',
    numeroBikes: 15,
    numeroFilas: 3,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
    ],
    ativa: true,
  ),
  DTOSala(
    id: 19,
    nome: 'Sala Spinning Charge',
    numeroBikes: 22,
    numeroFilas: 5,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
      [true, true, true, true, true],     // Fila 5
    ],
    ativa: true,
  ),
  DTOSala(
    id: 20,
    nome: 'Sala Spinning Peak',
    numeroBikes: 28,
    numeroFilas: 6,
    limiteBikesPorFila: 5,
    gradeBikes: [
      [false, false, true, false, false], // Fila 0 (professora)
      [true, true, true, true, true],     // Fila 1
      [true, true, true, true, true],     // Fila 2
      [true, true, true, true, true],     // Fila 3
      [true, true, true, true, true],     // Fila 4
      [true, true, true, true, true],     // Fila 5
      [true, true, true, true, true],     // Fila 6
    ],
    ativa: true,
  ),
]; 
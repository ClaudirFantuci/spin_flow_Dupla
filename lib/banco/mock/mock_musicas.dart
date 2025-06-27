import 'package:spin_flow/dto/dto_musica.dart';
import 'mock_artistas_bandas.dart';
import 'mock_categorias_musica.dart';

List<DTOMusica> mockMusicas = [
  DTOMusica(
    id: 1,
    nome: 'Eye of the Tiger',
    artista: mockArtistasBandas[0], // Survivor
    categorias: [mockCategoriasMusica[0], mockCategoriasMusica[15]], // Cadência, Motivação
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=btPJPFnesV4',
        descricao: 'Tutorial Eye of the Tiger - Treino de Cadência',
      ),
    ],
    descricao: 'Música icônica para treinos de cadência e motivação',
    ativo: true,
  ),
  DTOMusica(
    id: 2,
    nome: 'We Will Rock You',
    artista: mockArtistasBandas[1], // Queen
    categorias: [mockCategoriasMusica[5], mockCategoriasMusica[11]], // Ritmo, Explosão
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=-tJYN-eG1zk',
        descricao: 'We Will Rock You - Treino de Explosão',
      ),
    ],
    descricao: 'Clássico do Queen para treinos explosivos',
    ativo: true,
  ),
  DTOMusica(
    id: 3,
    nome: 'Thunderstruck',
    artista: mockArtistasBandas[2], // AC/DC
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[11]], // Força, Explosão
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=v2AC41dglnM',
        descricao: 'Thunderstruck - Treino de Força',
      ),
    ],
    descricao: 'Riff poderoso para treinos de força',
    ativo: true,
  ),
  DTOMusica(
    id: 4,
    nome: 'Lose Yourself',
    artista: mockArtistasBandas[3], // Eminem
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[16]], // Motivação, Recuperação
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=_Yhyp-_hX2s',
        descricao: 'Lose Yourself - Treino Motivacional',
      ),
    ],
    descricao: 'Música motivacional para superar limites',
    ativo: true,
  ),
  DTOMusica(
    id: 5,
    nome: 'Believer',
    artista: mockArtistasBandas[4], // Imagine Dragons
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[19]], // Força, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=7wtfhZwyrcc',
        descricao: 'Believer - Treino de Força e Energia',
      ),
    ],
    descricao: 'Música energética para treinos intensos',
    ativo: true,
  ),
  DTOMusica(
    id: 6,
    nome: 'Stronger',
    artista: mockArtistasBandas[5], // Kanye West
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[15]], // Força, Motivação
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=PsO6ZnUZI0g',
        descricao: 'Stronger - Treino de Força',
      ),
    ],
    descricao: 'Música para treinos de força e superação',
    ativo: true,
  ),
  DTOMusica(
    id: 7,
    nome: 'Can\'t Hold Us',
    artista: mockArtistasBandas[8], // Macklemore
    categorias: [mockCategoriasMusica[0], mockCategoriasMusica[19]], // Cadência, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=2zNSgSzhBfM',
        descricao: 'Can\'t Hold Us - Treino de Cadência',
      ),
    ],
    descricao: 'Música energética para manter o ritmo',
    ativo: true,
  ),
  DTOMusica(
    id: 8,
    nome: 'Remember the Name',
    artista: mockArtistasBandas[3], // Eminem (Fort Minor)
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[11]], // Motivação, Explosão
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=VDvr08sCPOc',
        descricao: 'Remember the Name - Treino Explosivo',
      ),
    ],
    descricao: 'Música para treinos explosivos e motivacionais',
    ativo: true,
  ),
  DTOMusica(
    id: 9,
    nome: 'Till I Collapse',
    artista: mockArtistasBandas[3], // Eminem
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[13]], // Força, Endurance
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=8CdcCD5V-d8',
        descricao: 'Till I Collapse - Treino de Resistência',
      ),
    ],
    descricao: 'Música para treinos de resistência e força',
    ativo: true,
  ),
  DTOMusica(
    id: 10,
    nome: 'Born to Run',
    artista: mockArtistasBandas[1], // Bruce Springsteen
    categorias: [mockCategoriasMusica[13], mockCategoriasMusica[17]], // Endurance, Velocidade
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=IxuThNgl3YA',
        descricao: 'Born to Run - Treino de Endurance',
      ),
    ],
    descricao: 'Música para treinos de resistência',
    ativo: true,
  ),
  DTOMusica(
    id: 11,
    nome: 'Jump',
    artista: mockArtistasBandas[1], // Van Halen
    categorias: [mockCategoriasMusica[11], mockCategoriasMusica[19]], // Explosão, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=SwYN7mTi6HM',
        descricao: 'Jump - Treino Explosivo',
      ),
    ],
    descricao: 'Música energética para treinos explosivos',
    ativo: true,
  ),
  DTOMusica(
    id: 12,
    nome: 'Radioactive',
    artista: mockArtistasBandas[4], // Imagine Dragons
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[19]], // Força, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=ktvTqknDobU',
        descricao: 'Radioactive - Treino de Força',
      ),
    ],
    descricao: 'Música para treinos de força e energia',
    ativo: true,
  ),
  DTOMusica(
    id: 13,
    nome: 'Can\'t Stop',
    artista: mockArtistasBandas[13], // Red Hot Chili Peppers
    categorias: [mockCategoriasMusica[0], mockCategoriasMusica[5]], // Cadência, Ritmo
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=8DyziWtkfBw',
        descricao: 'Can\'t Stop - Treino de Cadência',
      ),
    ],
    descricao: 'Música para manter o ritmo constante',
    ativo: true,
  ),
  DTOMusica(
    id: 14,
    nome: 'The Greatest',
    artista: mockArtistasBandas[9], // Sia
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // Motivação, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=GLvohMXgcBo',
        descricao: 'The Greatest - Treino Motivacional',
      ),
    ],
    descricao: 'Música motivacional para superar desafios',
    ativo: true,
  ),
  DTOMusica(
    id: 15,
    nome: 'Born This Way',
    artista: mockArtistasBandas[14], // Lady Gaga
    categorias: [mockCategoriasMusica[7], mockCategoriasMusica[15]], // Animação, Motivação
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=wV1FrqwZyKw',
        descricao: 'Born This Way - Treino Animado',
      ),
    ],
    descricao: 'Música animada e motivacional',
    ativo: true,
  ),
  DTOMusica(
    id: 16,
    nome: 'Fight Song',
    artista: mockArtistasBandas[9], // Rachel Platten
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // Motivação, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=xo1VInw-SKc',
        descricao: 'Fight Song - Treino Motivacional',
      ),
    ],
    descricao: 'Música para lutar e superar obstáculos',
    ativo: true,
  ),
  DTOMusica(
    id: 17,
    nome: 'High Hopes',
    artista: mockArtistasBandas[18], // Panic! At The Disco
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // Motivação, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=IPXIgEAGe4U',
        descricao: 'High Hopes - Treino Motivacional',
      ),
    ],
    descricao: 'Música motivacional com alta energia',
    ativo: true,
  ),
  DTOMusica(
    id: 18,
    nome: 'Invincible',
    artista: mockArtistasBandas[19], // Two Steps From Hell
    categorias: [mockCategoriasMusica[2], mockCategoriasMusica[15]], // Força, Motivação
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=2Z4m4lnvxkY',
        descricao: 'Invincible - Treino de Força',
      ),
    ],
    descricao: 'Música épica para treinos de força',
    ativo: true,
  ),
  DTOMusica(
    id: 19,
    nome: 'Centuries',
    artista: mockArtistasBandas[6], // Fall Out Boy
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // Motivação, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=LBr7kECsjcQ',
        descricao: 'Centuries - Treino Motivacional',
      ),
    ],
    descricao: 'Música motivacional para deixar legado',
    ativo: true,
  ),
  DTOMusica(
    id: 20,
    nome: 'Hall of Fame',
    artista: mockArtistasBandas[7], // The Script
    categorias: [mockCategoriasMusica[15], mockCategoriasMusica[19]], // Motivação, Energia
    linksVideoAula: [
      DTOLinkVideoAula(
        url: 'https://youtube.com/watch?v=mk48xRzuNvA',
        descricao: 'Hall of Fame - Treino Motivacional',
      ),
    ],
    descricao: 'Música para entrar no hall da fama',
    ativo: true,
  ),
]; 
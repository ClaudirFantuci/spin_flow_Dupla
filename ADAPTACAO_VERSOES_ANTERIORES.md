# Adaptação para Versões Anteriores do Flutter/Dart

## **Versão Atual vs Versão Anterior**
- **Atual**: Flutter 3.24.0+ / Dart 3.8.1+
- **Anterior**: Flutter 3.0.0 - 3.23.x / Dart 3.0.0 - 3.7.x

## **Principais Incompatibilidades e Adaptações**

### 1. **Métodos de Drag & Drop (form_sala.dart)**
```dart
// ATUAL (Flutter 3.14+)
onWillAcceptWithDetails: (details) { ... }
onAcceptWithDetails: (details) { ... }

// ADAPTAÇÃO para versões anteriores
onWillAccept: (data) { ... }
onAccept: (data) { ... }
```

### 2. **Método withValues() (form_sala.dart)**
```dart
// ATUAL (Flutter 3.24+)
color: Colors.blue.withValues(alpha: 0.7)

// ADAPTAÇÃO para versões anteriores
color: Colors.blue.withOpacity(0.7)
```

### 3. **flutter_lints 5.0.0**
```yaml
# ATUAL (pubspec.yaml)
flutter_lints: ^5.0.0

# ADAPTAÇÃO para versões anteriores
flutter_lints: ^3.0.0
```

### 4. **SDK Dart**
```yaml
# ATUAL (pubspec.yaml)
environment:
  sdk: ^3.8.1

# ADAPTAÇÃO para versões anteriores
environment:
  sdk: '>=3.0.0 <4.0.0'
```

## **Passos de Adaptação**

### **Passo 1: Atualizar pubspec.yaml**
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'

dev_dependencies:
  flutter_lints: ^3.0.0
```

### **Passo 2: Corrigir form_sala.dart**
```dart
// Substituir onWillAcceptWithDetails
onWillAccept: (data) {
  if (data == null) return false;
  return (fila != data['fila'] || bike != data['bike']) &&
         gradeBikes[fila][bike] == false;
},

// Substituir onAcceptWithDetails
onAccept: (data) {
  moverBike(fila, bike, data['fila']!, data['bike']!);
},

// Substituir withValues
color: Colors.blue.withOpacity(0.7),
```

### **Passo 3: Executar comandos**
```bash
flutter clean
flutter pub get
flutter analyze
```

## **Funcionalidades que Funcionam em Versões Anteriores**
- ✅ `super.key` (Dart 3.0+)
- ✅ `FormField` e `TextFormField`
- ✅ Todas as dependências (`mask_text_input_formatter`, `sqflite`, etc.)
- ✅ Estrutura de DTOs e mocks
- ✅ Todos os formulários e componentes

## **Limitações em Versões Anteriores**
- ⚠️ Warnings de depreciação para `onWillAccept`/`onAccept`
- ⚠️ Warnings de depreciação para `withOpacity`
- ⚠️ Lints menos rigorosos (versão 3.x vs 5.x)

## **Versão Mínima Recomendada**
- **Flutter**: 3.0.0
- **Dart**: 3.0.0

Esta adaptação mantém toda a funcionalidade do projeto, apenas com alguns warnings de depreciação que não afetam o funcionamento.

## **Arquivos Afetados**
- `pubspec.yaml` - Configuração de SDK e dependências
- `lib/widget/form_sala.dart` - Métodos de drag & drop e withValues()

## **Teste de Compatibilidade**
Após as adaptações, execute:
```bash
flutter doctor
flutter analyze
flutter test
```

Para verificar se não há erros de compatibilidade. 
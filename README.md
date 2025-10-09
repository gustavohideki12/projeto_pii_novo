# Projeto PI - Sistema de Registro de Obras

Aplicativo Flutter para registro e acompanhamento de obras/canteiros de obras com funcionalidades de captura de imagens.

## 📋 Etapa 1: Estrutura Base e Captura de Imagens ✅

### ✅ Funcionalidades Implementadas

#### 🏗️ Estrutura do Projeto
- **Projeto Flutter** criado com estrutura organizada
- **Pastas organizadas**: `screens`, `widgets`, `models`, `services`, `utils`, `providers`
- **Tema personalizado** com cores consistentes e design profissional

#### 🎨 Tema e Design
- **Cores definidas**: Azul profissional, verde água, laranja
- **Tipografia** consistente em toda aplicação
- **Sombras e elevações** para melhor experiência visual
- **Componentes reutilizáveis** com design system

#### 📱 Tela Principal (Dashboard)
- **Interface limpa e intuitiva** para listagem de obras
- **Estado vazio** com mensagem explicativa quando não há projetos
- **Botão flutuante (FAB)** para iniciar processo de registro
- **Cards informativos** mostrando detalhes das obras

#### 📷 Captura de Imagens
- **Acesso à câmera** do dispositivo para tirar fotos
- **Seleção da galeria** para escolher imagens existentes
- **Validação de formato** (JPG, JPEG, PNG)
- **Controle de tamanho** (máximo 10MB)
- **Criação automática** de projeto com imagem capturada

#### 💾 Gerenciamento de Dados
- **Modelo de Projeto** com todos os campos necessários
- **Serviço de persistência** usando SharedPreferences
- **Provider** para gerenciamento de estado
- **Criação e salvamento** automático de projetos

#### 🛠️ Serviços Implementados
- **ProjectService**: CRUD completo para projetos
- **ImageService**: Captura e validação de imagens
- **Validações robustas** e tratamento de erros

### 🚀 Como Executar

1. **Instalar dependências:**
   ```bash
   flutter pub get
   ```

2. **Executar o aplicativo:**
   ```bash
   flutter run
   ```

### 📦 Dependências Utilizadas

- **image_picker**: ^1.0.4 - Para captura de imagens da câmera e galeria
- **camera**: ^0.10.5+5 - Para acesso avançado à câmera
- **provider**: ^6.1.1 - Para gerenciamento de estado
- **shared_preferences**: ^2.2.2 - Para armazenamento local
- **iconsax**: ^0.0.8 - Para ícones modernos

### 🎯 Funcionalidades da Etapa 1

✅ **Estrutura base criada**
✅ **Tema básico definido**
✅ **Dashboard implementado**
✅ **Captura por câmera**
✅ **Seleção da galeria**
✅ **Validações implementadas**
✅ **Persistência de dados**
✅ **Estado vazio tratado**

### 📋 Próximas Etapas (Planejadas)

- **Etapa 2**: Formulário completo para edição de projetos
- **Etapa 3**: Visualização detalhada de projetos
- **Etapa 4**: Sincronização com backend
- **Etapa 5**: Relatórios e exportação de dados

### 🔧 Estrutura de Arquivos

```
lib/
├── models/
│   └── project.dart              # Modelo de Projeto
├── providers/
│   └── project_provider.dart     # Gerenciamento de estado
├── screens/
│   └── dashboard_screen.dart     # Tela principal
├── services/
│   ├── project_service.dart      # Persistência de projetos
│   └── image_service.dart        # Captura de imagens
├── utils/
│   ├── app_theme.dart           # Tema da aplicação
│   └── app_constants.dart       # Constantes
└── widgets/
    ├── project_card.dart        # Card de projeto
    └── empty_state.dart         # Estado vazio
```

### 📱 Telas Implementadas

1. **Dashboard**: Lista todas as obras registradas
2. **Estado Vazio**: Quando não há projetos
3. **Diálogo de Captura**: Escolha entre câmera e galeria

O aplicativo está pronto para uso básico e expansão futura com as próximas etapas planejadas.
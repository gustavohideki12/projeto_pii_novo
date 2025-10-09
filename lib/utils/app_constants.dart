class AppConstants {
  // Textos da aplicação
  static const String appName = 'Registro de Obras';
  static const String appDescription = 'Sistema para registro e acompanhamento de obras';

  // Textos da tela principal
  static const String dashboardTitle = 'Obras';
  static const String noProjectsMessage = 'Nenhuma obra registrada ainda';
  static const String addProjectMessage = 'Toque no botão + para adicionar uma nova obra';

  // Textos dos botões
  static const String addButtonTooltip = 'Adicionar obra';
  static const String cameraButton = 'Câmera';
  static const String galleryButton = 'Galeria';
  static const String cancelButton = 'Cancelar';

  // Textos de captura de imagem
  static const String captureImageTitle = 'Capturar Imagem';
  static const String chooseImageSource = 'Escolha a fonte da imagem';
  static const String takePhoto = 'Tirar Foto';
  static const String chooseFromGallery = 'Escolher da Galeria';

  // Mensagens de erro
  static const String cameraPermissionDenied = 'Permissão de câmera negada';
  static const String galleryPermissionDenied = 'Permissão de galeria negada';
  static const String imageSelectionFailed = 'Falha ao selecionar imagem';
  static const String cameraError = 'Erro ao acessar câmera';

  // Mensagens de sucesso
  static const String imageCaptured = 'Imagem capturada com sucesso';
  static const String imageSelected = 'Imagem selecionada com sucesso';

  // Labels de formulário (para futuras funcionalidades)
  static const String projectNameLabel = 'Nome da Obra';
  static const String projectDescriptionLabel = 'Descrição';
  static const String projectLocationLabel = 'Localização';
  static const String projectStartDateLabel = 'Data de Início';
  static const String projectEndDateLabel = 'Data de Fim';
  static const String projectStatusLabel = 'Status';

  // Status da obra
  static const String statusPlanning = 'Planejamento';
  static const String statusInProgress = 'Em Andamento';
  static const String statusCompleted = 'Concluída';
  static const String statusPaused = 'Pausada';
  static const String statusCancelled = 'Cancelada';

  // Validação
  static const String fieldRequired = 'Este campo é obrigatório';
  static const String invalidDate = 'Data inválida';

  // Configurações
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];

  // Chaves para SharedPreferences
  static const String projectsKey = 'projects';
  static const String settingsKey = 'settings';
  static const String userPreferencesKey = 'user_preferences';
}

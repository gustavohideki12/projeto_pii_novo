import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SafeImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const SafeImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  State<SafeImage> createState() => _SafeImageState();
}

class _SafeImageState extends State<SafeImage> {
  String? _authenticatedUrl;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAuthenticatedUrl();
  }

  Future<void> _loadAuthenticatedUrl() async {
    try {
      // Se a URL é do Firebase Storage, tentar obter URL autenticada
      if (widget.imageUrl.contains('firebasestorage.googleapis.com')) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          try {
            // Obter referência do arquivo a partir da URL
            final ref = FirebaseStorage.instance.refFromURL(widget.imageUrl);
            // Obter URL com token de autenticação (válida por 1 hora)
            final authenticatedUrl = await ref.getDownloadURL();
            if (mounted) {
              setState(() {
                _authenticatedUrl = authenticatedUrl;
                _isLoading = false;
              });
            }
            return;
          } catch (e) {
            print('Erro ao obter URL autenticada: $e');
            // Se falhar, usar URL original
          }
        }
      }
      
      // Se não for Firebase Storage ou falhar, usar URL original
      if (mounted) {
        setState(() {
          _authenticatedUrl = widget.imageUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao processar URL da imagem: $e');
      if (mounted) {
        setState(() {
          _authenticatedUrl = widget.imageUrl;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ??
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: widget.borderRadius,
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
    }

    if (_hasError || _authenticatedUrl == null) {
      return widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: widget.borderRadius,
            ),
            child: Icon(
              Icons.broken_image_outlined,
              size: (widget.height != null && widget.height! < 60) ? widget.height! * 0.4 : 40,
              color: Colors.grey[400],
            ),
          );
    }

    Widget imageWidget = Image.network(
      _authenticatedUrl!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return widget.placeholder ??
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: widget.borderRadius,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        print('Erro ao carregar imagem: $error');
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
        return widget.errorWidget ??
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: widget.borderRadius,
              ),
              child: Icon(
                Icons.broken_image_outlined,
                size: (widget.height != null && widget.height! < 60) ? widget.height! * 0.4 : 40,
                color: Colors.grey[400],
              ),
            );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );

    if (widget.borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}


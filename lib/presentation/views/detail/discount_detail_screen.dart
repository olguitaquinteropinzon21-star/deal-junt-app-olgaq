import 'package:flutter/material.dart';

class DiscountDetailScreen extends StatefulWidget {
  const DiscountDetailScreen({super.key});

  @override
  State<DiscountDetailScreen> createState() => _DiscountDetailScreenState();
}

class _DiscountDetailScreenState extends State<DiscountDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // 1. Contenido principal con Scroll
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen de Banner Superior
                _buildBannerImage(size),

                // Contenedor de Información Principal
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categoría o Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'RESTAURANTES',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Título del beneficio
                      const Text(
                        '30% de Descuento en todo el menú de Hamburguesas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Nombre del establecimiento
                      const Text(
                        'Burger Master Co.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Tarjeta del Código de Barras / QR para escanear
                      _buildBarcodeCard(),
                      const SizedBox(height: 24),

                      // 3. TabBar para Información y Términos (Corregido para Material 3)
                      TabBar(
                        controller: _tabController,
                        indicatorColor: const Color(0xFF6200EE),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: const Color(0xFF6200EE),
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: 'Información'),
                          Tab(text: 'Términos y condiciones'),
                        ],
                      ),

                      // Contenido de las pestañas
                      SizedBox(
                        height: 250,
                        child: TabBarView(
                          controller: _tabController,
                          children: [_buildInfoTab(), _buildTermsTab()],
                        ),
                      ),

                      // Espaciado extra para que el botón de abajo no tape el texto
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Barra superior de acciones flotante (Back y Favorito con spaceBetween)
          _buildFloatingAppBar(context),

          // 5. Botón de acción fijo en la parte inferior (.styleFrom)
          _buildBottomActionButton(size),
        ],
      ),
    );
  }

  // Widget para la imagen superior del comercio
  Widget _buildBannerImage(Size size) {
    return Container(
      height: size.height * 0.32,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1000',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.4), Colors.transparent],
          ),
        ),
      ),
    );
  }

  // Widget de la barra de navegación flotante (Corregido MainAxisAlignment)
  Widget _buildFloatingAppBar(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // <-- ¡Corregido aquí!
        children: [
          // Botón Atrás
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Botón Favorito
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget de la tarjeta que contiene el código de barras/cupón
  Widget _buildBarcodeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Muestra este código en la caja del local',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.line_weight_rounded,
              size: 50,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'CÓDIGO: BURGER30OFF',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Vista de la pestaña de Información
  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Text(
          'Disfruta de un espectacular descuento en todo nuestro menú de hamburguesas artesanales preparados con carne 100% Angus e ingredientes frescos del campo.',
          style: TextStyle(height: 1.5, color: Colors.black87),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Vence el: 31 de Diciembre, 2026',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  // Vista de la pestaña de Términos y Condiciones
  Widget _buildTermsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Text(
          '• Válido únicamente para consumo en el establecimiento.',
          style: TextStyle(height: 1.6),
        ),
        Text(
          '• No acumulable con otras promociones o descuentos vigentes.',
          style: TextStyle(height: 1.6),
        ),
        Text(
          '• Aplica un cupón por mesa o por cuenta.',
          style: TextStyle(height: 1.6),
        ),
        Text(
          '• Sujeto a disponibilidad de stock en el local comercial.',
          style: TextStyle(height: 1.6),
        ),
      ],
    );
  }

  // Botón inferior flotante
  Widget _buildBottomActionButton(Size size) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6200EE),
          minimumSize: Size(double.infinity, size.height * 0.065),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
        onPressed: () {
          // Acción para redimir el beneficio
        },
        child: const Text(
          'Redimir Cupón',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

# Pasta `home/`

Define as telas principais de navegação e descoberta do aplicativo, como a tela inicial (`HomeScreen`) com categorias e promoções, e a tela de resultados de busca (`SearchResultsScreen`) que exibe restaurantes filtrados a partir de uma palavra-chave.

| Home Screen | Search Results Screen | 
|--------------|---------------------|
| ![Splash](assets/screenshots/home_screen.png) | ![Home](assets/screenshots/search_results_screen.png)

---

## `home_screen.dart`

### Funcionalidade

Exibe a tela principal do aplicativo após o splash. Mostra o logotipo do app, uma saudação, barra de busca, categorias clicáveis, um banner promocional e uma lista de restaurantes recomendados ou filtrados pela categoria selecionada.

### Decisões Técnicas

- Usa `StatefulWidget` para permitir a seleção dinâmica de categorias.
- Integra o `Provider` para acessar os dados dos restaurantes.
- Filtra os restaurantes com base na categoria selecionada ou na avaliação (estrelas).
- Utiliza widgets personalizados para manter o código limpo e modular (`CategoryWidget`, `RestaurantWidget`, `SearchBarWidget`, `HomeDrawer`).
- Interface adaptável com rolagem vertical e horizontal para categorias.

### Código comentado

```dart
// Tela principal do aplicativo, exibida após o splash
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Categoria atualmente selecionada
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    // Acesso ao provedor de dados dos restaurantes
    RestaurantData restaurantData = Provider.of<RestaurantData>(context);

    return Scaffold(
      // Menu lateral personalizado
      drawer: const HomeDrawer(),

      // AppBar personalizada
      appBar: getAppBar(context: context),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25.0),
              
              // Logotipo centralizado
              Column(
                children: [
                  Center(child: Image.asset('assets/logo.png', width: 160)),
                  const SizedBox(height: 25.0),
                ],
              ),

              // Saudação
              const Text(
                "Boas-vindas!",
                style: TextStyle(
                  color: AppColors.highlightTextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16.0),

              // Barra de busca
              const SearchBarWidget(),

              const SizedBox(height: 24.0),

              // Título das categorias
              const Text(
                "Escolha por categoria:",
                style: TextStyle(
                  color: AppColors.highlightTextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 12.0),

              // Lista horizontal de categorias
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    CategoriesData.listCategories.length,
                    (index) {
                      final category = CategoriesData.listCategories[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CategoryWidget(
                          category: category,
                          isSelected: selectedCategory == category,
                          onTap: () {
                            // Atualiza a categoria selecionada
                            setState(() {
                              if (selectedCategory == category) {
                                selectedCategory = '';
                              } else {
                                selectedCategory = category;
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Banner promocional
              Image.asset("assets/banners/banner_promo.png"),

              const SizedBox(height: 24.0),

              // Título da seção de restaurantes
              Text(
                selectedCategory.isEmpty
                    ? "Bem avaliados"
                    : "Resultados para: $selectedCategory",
                style: const TextStyle(
                  color: AppColors.highlightTextColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16.0),

              // Lista de restaurantes filtrados
              Column(
                children: restaurantData.listRestaurant
                    .where((restaurant) {
                      if (selectedCategory.isEmpty) {
                        return restaurant.stars >= 4.0;
                      } else {
                        return restaurant.categories.contains(selectedCategory);
                      }
                    })
                    .map(
                      (restaurant) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: RestaurantWidget(restaurant: restaurant),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}

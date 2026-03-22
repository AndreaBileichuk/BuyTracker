import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/ThemeProvider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Налаштування'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              "Оформлення додатку",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildThemeCard(context, themeProvider, 'light', 'Світла (Класика)', const Color(0xFF667EEA), const Color(0xFFF5F7FA)),
                _buildThemeCard(context, themeProvider, 'dark', 'Темна (Класика)', const Color(0xFF667EEA), const Color(0xFF1E1E2C)),
                _buildThemeCard(context, themeProvider, 'emerald', 'Смарагд', const Color(0xFF11998E), const Color(0xFFF1F8F6)),
                _buildThemeCard(context, themeProvider, 'sunset', 'Захід сонця', const Color(0xFFFF512F), const Color(0xFFFFF7F5)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeProvider provider, String themeId, String label, Color accentColor, Color bgColor) {
    final isSelected = provider.themeName == themeId;
    
    return GestureDetector(
      onTap: () => provider.setTheme(themeId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.withOpacity(0.3),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            if (isSelected)
               BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          accentColor,
                          accentColor.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: themeId == 'dark' ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: accentColor, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}

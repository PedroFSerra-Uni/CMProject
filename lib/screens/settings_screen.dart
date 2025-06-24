import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Estados para as configurações de privacidade
  bool showPhoneNumber = true;
  bool showExactLocation = false;

  // Estados para as notificações
  bool newOrdersNotification = true;
  bool newReviewsAlert = true;
  bool newsletter = false;

  // Estados para ajuda por voz
  bool voiceAssistantEnabled = true;

  // Idioma selecionado
  String selectedLanguage = 'Português';
  String selectedVoiceLanguage = 'Português';

  // Lista de idiomas disponíveis
  final List<String> languages = [
    'Português',
    'Inglês',
    'Espanhol',
    'Francês',
    'Alemão',
    'Italiano'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A815E), Color(0xFF2A815E)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Idioma'),
            _buildLanguageSetting(),

            _buildSectionHeader('Privacidade'),
            _buildPrivacySettings(),

            _buildSectionHeader('Notificações'),
            _buildNotificationSettings(),

            _buildSectionHeader('Ajuda por voz'),
            _buildVoiceHelpSettings(),

            _buildSectionHeader('Perguntas Frequentes'),
            _buildFaqSetting(),

            _buildSectionHeader('Termos e condições'),
            _buildTermsSetting(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2A815E), // Alterado para verde
        ),
      ),
    );
  }

  Widget _buildLanguageSetting() {
    return _buildSettingCard(
      children: [
        _buildSelectableItem(
          title: 'Alterar idioma',
          value: selectedLanguage,
          icon: Icons.language,
          onTap: () => _showLanguageSelector(false),
          hasDivider: false,
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return _buildSettingCard(
      children: [
        _buildToggleSetting(
          title: 'Mostrar número de telefone',
          value: showPhoneNumber,
          onChanged: (value) => setState(() => showPhoneNumber = value),
          icon: Icons.phone_android,
          hasDivider: true,
        ),
        _buildToggleSetting(
          title: 'Mostrar localização exata',
          value: showExactLocation,
          onChanged: (value) => setState(() => showExactLocation = value),
          icon: Icons.location_on,
          hasDivider: false,
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingCard(
      children: [
        _buildToggleSetting(
          title: 'Notificações de novas encomendas',
          value: newOrdersNotification,
          onChanged: (value) => setState(() => newOrdersNotification = value),
          icon: Icons.shopping_bag,
          hasDivider: true,
        ),
        _buildToggleSetting(
          title: 'Alertas de novas avaliações',
          value: newReviewsAlert,
          onChanged: (value) => setState(() => newReviewsAlert = value),
          icon: Icons.star_border,
          hasDivider: true,
        ),
        _buildToggleSetting(
          title: 'Newsletter: novidades e promoções',
          value: newsletter,
          onChanged: (value) => setState(() => newsletter = value),
          icon: Icons.email,
          hasDivider: false,
        ),
      ],
    );
  }

  Widget _buildVoiceHelpSettings() {
    return _buildSettingCard(
      children: [
        _buildToggleSetting(
          title: 'Ativar assistente de voz para ajuda rápida',
          value: voiceAssistantEnabled,
          onChanged: (value) => setState(() => voiceAssistantEnabled = value),
          icon: Icons.mic,
          hasDivider: true,
        ),
        _buildSelectableItem(
          title: 'Idioma da voz',
          value: selectedVoiceLanguage,
          icon: Icons.record_voice_over,
          onTap: () => _showLanguageSelector(true),
          hasDivider: false,
        ),
      ],
    );
  }

  Widget _buildFaqSetting() {
    return _buildSettingCard(
      children: [
        _buildSettingItem(
          title: 'Frequentes',
          value: '',
          icon: Icons.help_outline,
          hasDivider: false,
          trailingIcon: Icons.arrow_forward_ios,
          onTap: () => _showComingSoon(context),
        ),
      ],
    );
  }

  Widget _buildTermsSetting() {
    return _buildSettingCard(
      children: [
        _buildSettingItem(
          title: 'Termos e condições',
          value: '',
          icon: Icons.description,
          hasDivider: true,
          trailingIcon: Icons.arrow_forward_ios,
          onTap: () => _showComingSoon(context),
        ),
        _buildSettingItem(
          title: 'Terminar sessão',
          value: '',
          icon: Icons.exit_to_app,
          color: Colors.red,
          hasDivider: false,
          trailingIcon: Icons.arrow_forward_ios,
          onTap: () => _confirmLogout(context),
        ),
      ],
    );
  }

  Widget _buildSettingCard({required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String value,
    required IconData icon,
    Color color = const Color(0xFF2A815E), // Alterado para verde
    bool hasDivider = true,
    IconData? trailingIcon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailingIcon != null)
                  Icon(trailingIcon, color: Colors.grey.shade400, size: 18),
              ],
            ),
          ),
          if (hasDivider) const Divider(height: 0, thickness: 1, indent: 20, endIndent: 20),
        ],
      ),
    );
  }

  Widget _buildSelectableItem({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    bool hasDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: _buildSettingItem(
        title: title,
        value: value,
        icon: icon,
        hasDivider: hasDivider,
        trailingIcon: Icons.arrow_forward_ios,
      ),
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    bool hasDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A815E).withOpacity(0.1), // Verde com opacidade
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF2A815E), size: 24), // Verde
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Switch(
                value: value,
                activeColor: const Color(0xFF2A815E),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (hasDivider) const Divider(height: 0, thickness: 1, indent: 20, endIndent: 20),
      ],
    );
  }

  void _showLanguageSelector(bool isVoiceLanguage) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: languages.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            String lang = languages[index];
            bool isSelected = isVoiceLanguage
                ? lang == selectedVoiceLanguage
                : lang == selectedLanguage;

            return ListTile(
              title: Text(lang),
              trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF2A815E)) : null,
              onTap: () {
                setState(() {
                  if (isVoiceLanguage) {
                    selectedVoiceLanguage = lang;
                  } else {
                    selectedLanguage = lang;
                  }
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento...')),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Terminar sessão'),
        content: const Text('Tem a certeza que quer terminar a sessão?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Terminar sessão', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Implementa a lógica de logout aqui
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sessão terminada.')),
    );
  }
}

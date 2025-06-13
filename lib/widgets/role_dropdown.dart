import 'package:flutter/material.dart';

class RoleDropdown extends StatelessWidget {
  final String? selectedRole;
  final void Function(String?) onChanged;

  const RoleDropdown({super.key, required this.selectedRole, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedRole,
      decoration: const InputDecoration(labelText: 'Tipo de usuário'),
      items: const [
        DropdownMenuItem(value: 'produtor', child: Text('Produtor')),
        DropdownMenuItem(value: 'utilizador', child: Text('Utilizador')),
        DropdownMenuItem(value: 'admin', child: Text('Administrador')),
      ],
      onChanged: onChanged,
      validator: (value) => value == null ? 'Selecione um tipo de usuário' : null,
    );
  }
}

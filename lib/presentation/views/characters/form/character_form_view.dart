import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/models/character_entity.dart';
import '../../../controllers/characters_view_model.dart';

class CharacterFormView extends StatefulWidget {
  final CharactersViewModel viewModel;
  final Character? characterToEdit;

  const CharacterFormView({
    super.key,
    required this.viewModel,
    this.characterToEdit,
  });

  @override
  State<CharacterFormView> createState() => _CharacterFormViewState();
}

class _CharacterFormViewState extends State<CharacterFormView> {
  final _formKey = GlobalKey<FormState>();

  // unico texto
  late final TextEditingController _nameController;

  // seleçao de enums
  late CharacterClass _selectedClass;
  late CharacterRarity _selectedRarity;
  late CharacterAlignment _selectedAlignment;

  // numericos
  double _level = 1;
  double _stars = 1;
  late final TextEditingController _threatController;
  late final TextEditingController _attackController;
  late final TextEditingController _healthController;

  @override
  void initState() {
    super.initState();
    final char = widget.characterToEdit;

    _nameController = TextEditingController(text: char?.name ?? '');
    _selectedClass = char?.characterClass ?? CharacterClass.agilidade;
    _selectedRarity = char?.rarity ?? CharacterRarity.prata;
    _selectedAlignment = char?.alignment ?? CharacterAlignment.heroi;

    _level = (char?.level ?? 1).toDouble();
    _stars = (char?.stars ?? 1).toDouble();

    // valores minimos que encontrei na factory
    _threatController = TextEditingController(
      text: char?.threat.toString() ?? '100',
    );
    _attackController = TextEditingController(
      text: char?.attack.toString() ?? '50',
    );
    _healthController = TextEditingController(
      text: char?.health.toString() ?? '100',
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final character = Character(
      id: widget.characterToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text,
      characterClass: _selectedClass,
      rarity: _selectedRarity,
      level: _level.toInt(),
      threat: int.tryParse(_threatController.text) ?? 0,
      attack: int.tryParse(_attackController.text) ?? 0,
      health: int.tryParse(_healthController.text) ?? 0,
      stars: _stars.toInt(),
      alignment: _selectedAlignment,
      createdAt: widget.characterToEdit?.createdAt ?? now,
      updatedAt: now,
    );

    await widget.viewModel.commands.addCharacter(character);
    // await widget.viewModel.commands.addCharacterCommand.executeWith(character);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ficha do Personagem')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                showCursor: true,
                cursorWidth: 3.0,
                cursorColor: Colors.red,
                decoration: const InputDecoration(
                  labelText: 'Nome do Personagem',
                ),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<CharacterClass>(
                      initialValue: _selectedClass,
                      decoration: const InputDecoration(labelText: 'Classe'),
                      items: CharacterClass.values
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text(e.name)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedClass = v!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<CharacterRarity>(
                      initialValue: _selectedRarity,
                      decoration: const InputDecoration(labelText: 'Raridade'),
                      items: CharacterRarity.values
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text(e.name)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedRarity = v!),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              Text('Nível: ${_level.toInt()}'),
              Slider(
                value: _level,
                min: 1,
                max: 80,
                divisions: 79,
                activeColor: Colors.blueAccent,
                label: _level.toInt().toString(),
                onChanged: (v) => setState(() => _level = v),
              ),

              const SizedBox(height: 10),
              Text('Estrelas: ${_stars.toInt()}'),
              Slider(
                value: _stars,
                min: 1,
                max: 14,
                divisions: 13,
                activeColor: Colors.amber,
                label: _stars.toInt().toString(),
                onChanged: (v) => setState(() => _stars = v),
              ),

              const SizedBox(height: 20),
              // Atributos Numéricos
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _attackController,
                      cursorColor: Colors.redAccent,
                      cursorWidth: 3.0,
                      showCursor: true,
                      decoration: const InputDecoration(
                        labelText: 'Ataque (50-1000)',
                      ),
                      keyboardType: TextInputType.number,
                      // Quando o usuário terminar de digitar:
                      onEditingComplete: () {
                        final val = int.tryParse(_attackController.text) ?? 50;
                        // Trava entre 50 e 1000
                        _attackController.text = val.clamp(50, 1000).toString();
                        FocusScope.of(context).unfocus(); // Fecha o teclado
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _healthController,
                      cursorColor: Colors.redAccent,
                      cursorWidth: 3.0,
                      showCursor: true,
                      decoration: const InputDecoration(
                        labelText: 'Vida (100-5000)',
                      ),
                      keyboardType: TextInputType.number,
                      // Quando o usuário terminar de digitar:
                      onEditingComplete: () {
                        final val = int.tryParse(_healthController.text) ?? 100;
                        // Trava entre 100 e 5000
                        _healthController.text = val
                            .clamp(100, 5000)
                            .toString();
                        FocusScope.of(context).unfocus(); // Fecha o teclado
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  widget.characterToEdit == null
                      ? 'CRIAR'
                      : 'SALVAR ALTERAÇÕES',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

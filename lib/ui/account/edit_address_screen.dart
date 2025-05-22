import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myapp/model/address.dart';
import 'package:myapp/ui/_core/app_colors.dart';

class EditAddressScreen extends StatefulWidget {
  final Address? address;
  final Function(Address) onSave;

  const EditAddressScreen({super.key, this.address, required this.onSave});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController streetController;
  late TextEditingController numberController;
  late TextEditingController neighborhoodController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController cepController;
  late TextEditingController labelController;
  late TextEditingController descriptionController;
  late bool isPrimary;

  final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'\d')},
  );
  final numberFormatter = FilteringTextInputFormatter.digitsOnly;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    streetController = TextEditingController(text: address?.street ?? '');
    numberController = TextEditingController(text: address?.number ?? '');
    neighborhoodController = TextEditingController(
      text: address?.neighborhood ?? '',
    );
    cityController = TextEditingController(text: address?.city ?? '');
    stateController = TextEditingController(text: address?.state ?? '');
    cepController = TextEditingController(text: address?.cep ?? '');
    labelController = TextEditingController(text: address?.label ?? '');
    descriptionController = TextEditingController(
      text: address?.description ?? '',
    );
    isPrimary = address?.isPrimary ?? false;
  }

  @override
  void dispose() {
    streetController.dispose();
    numberController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    stateController.dispose();
    cepController.dispose();
    labelController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = true,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.cardTextColor),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.backgroundCardTextColor,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: AppColors.cardTextColor),
      validator:
          requiredField
              ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              }
              : null,
    );
  }

  Widget _buildCardField({required Widget child}) {
    return Card(
      color: AppColors.lightBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(padding: const EdgeInsets.all(12.0), child: child),
    );
  }

  void _saveAddress() {
    final street = streetController.text.trim();
    final number = numberController.text.trim();
    final neighborhood = neighborhoodController.text.trim();
    final city = cityController.text.trim();
    final state = stateController.text.trim();
    final cepRaw = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final label = labelController.text.trim();
    final description = descriptionController.text.trim();

    String? error;

    if (street.isEmpty ||
        number.isEmpty ||
        neighborhood.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        cepRaw.isEmpty ||
        label.isEmpty) {
      error = 'Todos os campos obrigatórios devem ser preenchidos.';
    } else if (int.tryParse(number) == null || int.parse(number) <= 0) {
      error = 'Número inválido. Deve ser um valor numérico positivo.';
    } else if (cepRaw.length != 8) {
      error = 'CEP inválido. Deve conter exatamente 8 dígitos numéricos.';
    }

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final newAddress = Address(
      street: street,
      number: number,
      neighborhood: neighborhood,
      city: city,
      state: state,
      cep: cepRaw,
      label: label,
      description: description,
      isPrimary: isPrimary,
    );

    widget.onSave(newAddress);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Endereço' : 'Novo Endereço',
          style: const TextStyle(color: AppColors.highlightTextColor),
        ),
        backgroundColor: AppColors.lightBackgroundColor,
        iconTheme: const IconThemeData(color: AppColors.highlightTextColor),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildCardField(
                child: _buildField(controller: streetController, label: 'Rua'),
              ),
              _buildCardField(
                child: _buildField(
                  controller: numberController,
                  label: 'Número',
                  keyboardType: TextInputType.number,
                  inputFormatters: [numberFormatter],
                ),
              ),
              _buildCardField(
                child: _buildField(
                  controller: neighborhoodController,
                  label: 'Bairro',
                ),
              ),
              _buildCardField(
                child: _buildField(controller: cityController, label: 'Cidade'),
              ),
              _buildCardField(
                child: _buildField(
                  controller: stateController,
                  label: 'Estado',
                ),
              ),
              _buildCardField(
                child: _buildField(
                  controller: cepController,
                  label: 'CEP',
                  keyboardType: TextInputType.number,
                  inputFormatters: [cepFormatter],
                ),
              ),
              _buildCardField(
                child: _buildField(
                  controller: labelController,
                  label: 'Rótulo (ex: Casa, Trabalho)',
                ),
              ),
              _buildCardField(
                child: _buildField(
                  controller: descriptionController,
                  label: 'Descrição adicional',
                  requiredField: false,
                ),
              ),
              _buildCardField(
                child: CheckboxListTile(
                  title: const Text(
                    'Definir como endereço principal',
                    style: TextStyle(color: AppColors.cardTextColor),
                  ),
                  value: isPrimary,
                  activeColor: AppColors.buttonsColor,
                  onChanged: (value) {
                    setState(() {
                      isPrimary = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonsColor,
                  foregroundColor: AppColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveAddress();
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/_core/app_text_styles.dart';
import 'package:myapp/ui/_core/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class EditUserDataScreen extends StatefulWidget {
  const EditUserDataScreen({super.key});

  @override
  State<EditUserDataScreen> createState() => _EditUserDataScreenState();
}

class _EditUserDataScreenState extends State<EditUserDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: '');
  final _cpfController = TextEditingController(text: '000.000.000-00');
  final _phoneController = TextEditingController(text: '(XX) 9XXXX-XXXX');

  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final _phoneFormatter = MaskTextInputFormatter(mask: '(##) #####-####');

  @override
  void initState() {
    super.initState();
    final userData = Provider.of<UserDataProvider>(context, listen: false);
    _nameController.text = userData.fullName;
    _cpfController.text =
        userData.cpf.isNotEmpty ? userData.cpf : '000.000.000-00';
    _phoneController.text =
        userData.phone.isNotEmpty ? userData.phone : '(XX) 9XXXX-XXXX';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11 || RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

    int calcDigit(List<int> digits, int factor) {
      int sum = 0;
      for (var d in digits) {
        sum += d * factor--;
      }
      int mod = (sum * 10) % 11;
      return mod == 10 ? 0 : mod;
    }

    final digits = cpf.split('').map(int.parse).toList();
    final d1 = calcDigit(digits.sublist(0, 9), 10);
    final d2 = calcDigit(digits.sublist(0, 10), 11);

    return d1 == digits[9] && d2 == digits[10];
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserDataProvider>(
        context,
        listen: false,
      );

      userProvider.updateFullName(_nameController.text.trim());
      userProvider.updateCPF(_cpfController.text.trim());
      userProvider.updatePhone(_phoneController.text.trim());

      Navigator.of(context).pop(); // volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundCardTextColor,
        iconTheme: const IconThemeData(color: AppColors.mainColor),
        title: const Text('Editar dados', style: AppTextStyles.titleLargeWhite),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildStylizedField(
                  label: 'Nome:',
                  hint: 'Ex: Ana Souza',
                  controller: _nameController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe seu nome'
                              : null,
                ),
                _buildStylizedField(
                  label: 'CPF:',
                  hint: '000.000.000-00',
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_cpfFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Informe o CPF';
                    if (!_isValidCPF(value)) {
                      return 'CPF inválido! Digite novamente:';
                    }
                    return null;
                  },
                ),
                _buildStylizedField(
                  label: 'Telefone:',
                  hint: '(XX) XXXX-XXX',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneFormatter],
                  validator: (value) {
                    final cleaned = value?.replaceAll(RegExp(r'\D'), '');
                    if (cleaned == null || cleaned.length != 11) {
                      return 'Telefone inválido! Digite novamente:';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Salvar',
                      style: AppTextStyles.titleButtonSplash,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStylizedField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      color: AppColors.lightBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: InputBorder.none,
          ),
          validator: validator,
        ),
      ),
    );
  }
}

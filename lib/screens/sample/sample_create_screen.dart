import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/sample/sample_create_controller.dart';
import 'package:unisinos_usp_app/models/sample_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class SampleCreateScreen extends StatefulWidget {
  const SampleCreateScreen({super.key});

  @override
  State<SampleCreateScreen> createState() => _SampleCreateScreenState();
}

class _SampleCreateScreenState extends State<SampleCreateScreen> {
  final SampleCreateController _controller = Get.find<SampleCreateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sampleStringController = TextEditingController();
  final TextEditingController _sampleUniqueController = TextEditingController();
  final TextEditingController _nullableStringController = TextEditingController();
  final TextEditingController _sampleDoubleController = TextEditingController();
  final DateTimeController _sampleDateController = DateTimeController();
  final TextEditingController _orderNumberController = TextEditingController(text: '0');
  final TextEditingController _sampleDetailIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo sample'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputText(
                hintText: 'Nome',
                controller: _nameController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
                  PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
                ]).val(),
              ),
              Insets.large.height,
              InputText(
                hintText: 'Sample string',
                controller: _sampleStringController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
                  PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
                ]).val(),
              ),
              Insets.large.height,
              InputText(
                hintText: 'Sample unique',
                controller: _sampleUniqueController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
                  PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
                ]).val(),
              ),
              Insets.large.height,
              InputText(
                hintText: 'Nullable string (opcional)',
                controller: _nullableStringController,
                validator: (value) => PValidator([
                  PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
                ]).val(),
              ),
              Insets.large.height,
              InputNumber(
                label: 'Sample detail id',
                controller: _sampleDetailIdController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
                  PRuleInteger(value, message: 'Use um número inteiro'),
                ]).val(),
              ),
              Insets.large.height,
              InputNumber(
                label: 'Sample double',
                controller: _sampleDoubleController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
                  PRuleNumeric(value, message: 'Use um número válido'),
                ]).val(),
              ),
              Insets.large.height,
              InputFormDate(
                label: 'Sample date',
                controller: _sampleDateController,
                validator: (value) => PValidator([
                  PRuleRequiredDate(value, message: 'Use uma data válida'),
                ]).val(),
              ),
              Insets.large.height,
              InputNumber(
                label: 'Ordem',
                controller: _orderNumberController,
                validator: (value) => PValidator([
                  PRuleInteger(value, message: 'Use um número inteiro'),
                ]).val(),
              ),
              Insets.extraLarge.height,
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final bool loading = _controller.isLoading.value;
                  final String buttonTitle = loading ? 'Salvando...' : 'Salvar';
                  return ActionButton(
                    theme: ActionButtonTheme.blue,
                    title: buttonTitle,
                    onPressed: loading ? null : _save,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final double parsedDouble = double.parse(_sampleDoubleController.text.trim());
    final int parsedOrder = int.parse(_orderNumberController.text.trim());
    final int parsedDetailId = int.parse(_sampleDetailIdController.text.trim());

    final model = SampleModel(
      id: 0,
      name: _nameController.text.trim(),
      sampleString: _sampleStringController.text.trim(),
      sampleUnique: _sampleUniqueController.text.trim(),
      nullableString: _nullableStringController.text.trim().isEmpty
          ? null
          : _nullableStringController.text.trim(),
      sampleDetailId: parsedDetailId,
      sampleDouble: parsedDouble,
      sampleDate: _sampleDateController.value!,
      orderNumber: parsedOrder,
    );

    final bool saved = await _controller.save(model);
    if (saved) {
      Get.secureBack(result: true);
    }
  }
}

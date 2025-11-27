import 'package:unisinos_usp_app/controllers/controllers.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets_spo/utils.dart';

class HelpScreen extends StatelessWidget {
  final ConfigurationController _controller = Get.find<ConfigurationController>();

  HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Ajuda',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Insets.extraLarge.height,
              const Text(
                'Perguntas Frequentes (FAQ)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Insets.medium.height,
              Obx(() {
                final phone = _controller.getValueByTag('phone_contact');
                return _buildFAQItem(
                  'Como faço para me inscrever em um curso?',
                  'Caso queira comprar uma Formação de forma individual (não no formato de escola), ACESSE o menu no início do site e adquira sua formação de preferência (de acordo com as que estão liberadas para compra individual).\n'
                      'Caso queira algum projeto para sua empresa, entre em contato com nosso time pelo número $phone',
                );
              }),
              Insets.medium.height,
              _buildFAQItem(
                'Onde encontro meu certificado?',
                'Basta navegar até a área MEUS CERTIFICADOS, lá estarão listados todos os seus Certificados.\nAo selecionar uma opção, será aberto a pré-visualização e você poderá realizar o download.',
              ),
              Insets.medium.height,
              _buildFAQItem('Como posso redefinir minha senha?',
                  "Navegue até a tela de USUÁRIO, lá você encontrará um botão 'Alterar senha', ao clicar, será navegado para a tela responsável por permitir a alteração"),
              Insets.medium.height,
              _buildFAQItem(
                'Quais são as formas de pagamento?',
                'Cartão de crédito, débito e Pix para compras individuais.\n'
                    'Em caso de projetos, existe uma negociação que pode abrir a opção de boletos...',
              ),
              Insets.extraLarge.height,
              const Text(
                'Precisa de mais ajuda?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Insets.small.height,
              const Text(
                'Se sua dúvida não foi respondida, entre em contato conosco pelo botão abaixo.',
              ),
              Insets.extraLarge.height,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Obx(() {
                      String phone = _controller.getValueByTag('phone_contact');
                      return SizedBox(
                        width: double.infinity,
                        child: ActionButton(
                          theme: ActionButtonTheme.blue,
                          title: 'Suporte',
                          onPressed: () => openWhatsApp(phone),
                        ),
                      );
                    }),
                    Insets.medium.height,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openWhatsApp(String phone) async {
    final whatsappScheme = Uri.parse('whatsapp://send?phone=$phone}');
    final waMe = Uri.parse('https://wa.me/$phone');

    if (await canLaunchUrl(whatsappScheme)) {
      await launchUrl(whatsappScheme, mode: LaunchMode.externalApplication);
      return;
    }

    if (await canLaunchUrl(waMe)) {
      await launchUrl(waMe, mode: LaunchMode.externalApplication);
      return;
    }
  }

  Widget _buildFAQItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: primaryTextStyle(size: 16, color: Colors.black),
        ),
        Text(
          answer,
          style: secondaryTextStyle(size: 14),
        )
      ],
    );
  }
}

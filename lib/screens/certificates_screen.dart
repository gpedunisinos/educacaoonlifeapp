import 'package:unisinos_usp_app/controllers/certificate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/button_rect_default.dart';
import 'package:widgets_spo/widgets/paginated_separated_listview.dart';

class CertificatesScreen extends StatelessWidget {
  final CertificateController _controller = Get.find<CertificateController>();

  CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Meus Certificados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Certificados',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Insets.small.height,
              Text('Acesse seus certificados de conclusão de Trilha.', style: secondaryTextStyle(size: 16)),
              Insets.large.height,
              Obx(() {
                return PaginatedSeparatedListView(
                  items: _controller.certificates,
                  isLoading: _controller.isLoading.value,
                  onFetchMore: (offset) => _controller.fetch(offset: offset),
                  separatorBuilder: (context, _) => Insets.small.height,
                  shrinkWrap: true,
                  itemBuilder: (context, certificate, index) {
                    return ButtonRectDefault(
                      color: Color(0xFF084cec),
                      icon: Icon(
                        Icons.description_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: Row(
                        children: [
                          Text(
                            certificate.file.name!,
                            style: primaryTextStyle(
                              size: 14,
                              color: Colors.white,
                              weight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      borderColor: Color(0xFFf2f2f2),
                      borderRadius: 12,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      onPressed: () => {
                        if (certificate.file.extension == 'pdf')
                          {
                            Get.toNamed('/pdf_preview', arguments: {'url': certificate.file.publicUrl})
                          }
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:unisinos_usp_app/controllers/notification_controller.dart';
import 'package:unisinos_usp_app/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/paginated_separated_listview.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationController _controller = Get.find<NotificationController>();

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Text(
            'Notificações',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              Insets.extraLarge.height,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Notificações',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Obx(() {
                  return PaginatedSeparatedListView(
                    items: _controller.notifications,
                    isLoading: _controller.isloading.value,
                    onFetchMore: (offset) => _controller.fetch(offset: offset),
                    separatorBuilder: (context, _) => Insets.large.height,
                    itemBuilder: (context, notification, index) {
                      return NotificationItem(
                        title: notification.title,
                        subtitle: notification.content,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Revise todos os validators em sample considerando a documentação da API
Date: test with DateTime.tryParse
Email: email validate
Max numeric: check max number
Max string: check max string size
Min numeric: check min number
Min string: check min string size
Numeric: check value is numeric
Regexp: validate with regular expression
Required: check if exist value
RequiredDate: check if exist value
Requiredif: check if exist value if
Same: value must be same
Size string: value size check
Minimum date time: parse string and check is date is after the minimum
maximum date time: parse string and check is date is before the maximum
Size string: value size check
Integer: check value is a integer
Only one: check if only one value was entered

Revise todos as screens sample considerando que na lib widgets_spo há os seguintes componentes
Input_image.dart
Input_images.dart
button_back_component.dart
button_default.dart
button_new_component.dart
button_outlined.dart
button_rect_default.dart
chip_dropdown_api.dart
comment_card.dart
custom_switch.dart
error_alert.dart
file_preview_component.dart
file_selector.dart
grid_files.dart
grid_list_builder.dart
input_base.dart
input_checkbox.dart
input_checkbox_multiple.dart
input_currency.dart
input_date.dart
input_duration_picker.dart
input_file.dart
input_files.dart
input_form_date.dart
input_form_date_small.dart
input_links.dart
input_number.dart
input_quill.dart
input_search.dart
input_select.dart
input_select_api.dart
input_select_api_multiple.dart
input_select_multiple.dart
input_text.dart
item_select.dart
items_dialog_api.dart
loading_dialog.dart
menu_item.dart
paginated_listview.dart
paginated_separated_listview.dart
reordearble_paginated_listview.dart
show_quill.dart
sortable_data_table.dart
video_player_widget.dart

Crie o arquivo lib/routes/auth.dart e mova todas as rotas relativas a autenticação para este arquivo.

Em lib/controllers/sample/sample_create_controller.dart e lib/controllers/sample/sample_update_controller.dart, altere para que os métodos, ao invés de receber os atributos já recebam o objeto estruturado para inserção. Os atributos devem ser atribuídos na screen.

Crie um objeto SampleDetail. Integre ao lib/models/sample_model.dart. Em lib/screens/sample/sample_create_screen.dart e lib/screens/sample/sample_update_screen.dart utilize o componente input select para buscar estes registros da API e preencher
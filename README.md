# unisinos_usp_app

A new Flutter project.

### Keytool

keytool -genkey -v -keystore unisinos_usp_app.jks -keyalg RSA -keysize 2048 -validity 10000 -alias unisinos_usp_app
CN=SPO Tecnologia, OU=Mobile, O=SPO Tecnologia, L=Tupandi, ST=Rio Grande do Sul, C=BR
Senha em key.properties

### Deploy app 
flutter build web
scp -i /home/odair/Documentos/chaves/aws_spo.pem -r build/web/* ubuntu@18.230.235.236:/var/www/unisinos_usp_app
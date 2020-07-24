cd X:\Code\stand_app
x:
flutter build appbundle
copy /y X:\Code\stand_app\build\app\outputs\bundle\release\app-release.aab X:\Code\_Builds\stand_app\app-release.aab
cd ../_Builds/stand_app
java -jar bundletool-all-1.0.0.jar build-apks --bundle=app-release.aab --output=stand_app.apks --overwrite --ks=../../stand_app/android/app/key.jks --ks-pass=file:keypass.txt --ks-key-alias=key --key-pass=file:keypass.txt --local-testing --connected-device
java -jar bundletool-all-1.0.0.jar install-apks --apks=stand_app.apks

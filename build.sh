#!/bin/sh

#keytool -genkey -v -keystore mykeys.keystore -alias mykey -keyalg RSA -keysize 2048 -validity 10000

#echo "stage 0: generate R.java"
#aapt p -m -J build -S src/main/res -M src/main/AndroidManifest.xml -I /usr/lib/android-sdk/platforms/android-23/android.jar

echo "stage 1: compile Java files"
javac -d build -source 1.7 -target 1.7 -classpath src/main/java:build -bootclasspath /usr/lib/android-sdk/platforms/android-23/android.jar src/main/java/net/example/helloworld/*.java

echo "stage 2: generate dalvik classes.dex"
/usr/lib/android-sdk/build-tools/24.0.0/dx --dex --output=classes.dex build

echo "stage 3: generating the apk2"
aapt package -f -m -F build/helloworld.unaligned.apk -M src/main/AndroidManifest.xml -I /usr/lib/android-sdk/platforms/android-23/android.jar
aapt add build/helloworld.unaligned.apk classes.dex

echo "stage 4: align the apk"
zipalign -f 4 build/helloworld.unaligned.apk bin/helloworld.apk

echo "stage 5: sign the apk"
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore mykeys.keystore -storepass 123456 bin/helloworld.apk mykey

echo "stage 6: clean up"
rm classes.dex
rm build/helloworld.unaligned.apk

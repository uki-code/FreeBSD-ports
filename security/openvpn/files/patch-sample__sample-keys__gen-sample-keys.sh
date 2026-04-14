--- sample/sample-keys/gen-sample-keys.sh.orig     2026-04-13 17:03:19
+++ sample/sample-keys/gen-sample-keys.sh  2026-04-13 17:04:15
@@ -15,7 +15,9 @@
 fi

 # Generate static key for tls-auth (or static key mode)
-$(dirname ${0})/../../src/openvpn/openvpn --genkey tls-auth ta.key
+if [ ! -f ta.key ]; then
+    $(dirname ${0})/../../src/openvpn/openvpn --genkey tls-auth ta.key
+fi

 # Create required directories and files
 mkdir -p sample-ca

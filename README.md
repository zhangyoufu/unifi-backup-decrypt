# UniFi backup file (.unf) decryption

## Requirement

* openssl
* zip

## Hint

If you want to view/edit the content of UniFi backup file, you may want to make
use of `mongorestore` and `mongodump`.

## Some code snippet

```
final Cipher instance = Cipher.getInstance("AES/CBC/NoPadding");
instance.init(2, new SecretKeySpec("bcyangkmluohmars".getBytes(), "AES"), new IvParameterSpec("ubntenterpriseap".getBytes()));
return new CipherInputStream(inputStream, instance);
```

malformed zip files require fixing before unzip

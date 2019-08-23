some code snippet

```
final Cipher instance = Cipher.getInstance("AES/CBC/NoPadding");
instance.init(2, new SecretKeySpec("bcyangkmluohmars".getBytes(), "AES"), new IvParameterSpec("ubntenterpriseap".getBytes()));
return new CipherInputStream(inputStream, instance);
```

malformed zip files require fixing before unzip

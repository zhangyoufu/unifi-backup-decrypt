import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class Extract
{
    private static InputStream decrypt(final InputStream inputStream) throws GeneralSecurityException {
        final Cipher instance = Cipher.getInstance("AES/CBC/NoPadding");
        instance.init(2, new SecretKeySpec("bcyangkmluohmars".getBytes(), "AES"), new IvParameterSpec("ubntenterpriseap".getBytes()));
        return new CipherInputStream(inputStream, instance);
    }

    private static int extract_file(final InputStream inputStream, final File file) {
        try {
            final FileOutputStream fileOutputStream = new FileOutputStream(file);
            final byte[] array = new byte[4096];
            int n = 0;
            int read;
            while ((read = inputStream.read(array)) != -1) {
                fileOutputStream.write(array, 0, read);
                n += read;
            }
            try {
                fileOutputStream.close();
            }
            catch (Exception ex2) {}
            return n;
        }
        catch (Exception ex) {
            System.out.println(ex);
            return 0;
        }
    }

    private static boolean extract(final File dest, final InputStream inputStream) {
        try {
            final ZipInputStream zipInputStream = new ZipInputStream(decrypt(inputStream));
            ZipEntry nextEntry;
            while ((nextEntry = zipInputStream.getNextEntry()) != null) {
                System.out.println("unzipDir: " + nextEntry.getName());
                if (nextEntry.isDirectory()) {
                    new File(dest, nextEntry.getName()).mkdirs();
                }
                else {
                    extract_file(zipInputStream, new File(dest, nextEntry.getName()));
                }
                zipInputStream.closeEntry();
            }
            return true;
        }
        catch (Exception ex) {
            System.out.println("unzipDir error");
            System.out.println(ex);
            return false;
        }
    }
}

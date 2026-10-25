package util;

import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordUtil {
    private static final String PREFIX = "$pbkdf2-sha256$";
    private static final int ITERATIONS = 210000;
    private static final int SALT_BYTES = 16;
    private static final int KEY_BITS = 256;
    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordUtil() {
    }

    public static String hash(String password) throws GeneralSecurityException {
        byte[] salt = new byte[SALT_BYTES];
        RANDOM.nextBytes(salt);
        byte[] derived = derive(password, salt, ITERATIONS);
        Base64.Encoder encoder = Base64.getUrlEncoder().withoutPadding();
        return PREFIX + ITERATIONS + "$" + encoder.encodeToString(salt) + "$"
                + encoder.encodeToString(derived);
    }

    public static boolean verify(String password, String stored)
            throws GeneralSecurityException {
        if (!isHashed(stored)) {
            return MessageDigest.isEqual(password.getBytes(StandardCharsets.UTF_8),
                    stored.getBytes(StandardCharsets.UTF_8));
        }

        String[] parts = stored.split("\\$", -1);
        if (parts.length != 5) {
            return false;
        }

        try {
            int iterations = Integer.parseInt(parts[2]);
            byte[] salt = Base64.getUrlDecoder().decode(parts[3]);
            byte[] expected = Base64.getUrlDecoder().decode(parts[4]);
            byte[] actual = derive(password, salt, iterations);
            return MessageDigest.isEqual(expected, actual);
        } catch (IllegalArgumentException exception) {
            return false;
        }
    }

    public static boolean isHashed(String stored) {
        return stored != null && stored.startsWith(PREFIX);
    }

    private static byte[] derive(String password, byte[] salt, int iterations)
            throws GeneralSecurityException {
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, KEY_BITS);
        try {
            return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
                    .generateSecret(spec).getEncoded();
        } finally {
            spec.clearPassword();
        }
    }
}

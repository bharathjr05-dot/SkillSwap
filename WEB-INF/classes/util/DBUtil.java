package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBUtil {
    private DBUtil() {
    }

    public static Connection getConnection() throws Exception {
        String host = required("DB_HOST");
        String port = System.getenv().getOrDefault("DB_PORT", "3306");
        String database = required("DB_NAME");
        String user = required("DB_USER");
        String password = required("DB_PASSWORD");
        String sslMode = Boolean.parseBoolean(System.getenv().getOrDefault("DB_SSL", "false"))
                ? "VERIFY_IDENTITY" : "PREFERRED";
        String url = "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?sslMode=" + sslMode + "&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, password);
    }

    private static String required(String name) throws SQLException {
        String value = System.getenv(name);
        if (value == null || value.trim().isEmpty()) {
            throw new SQLException("Missing required database setting: " + name);
        }
        return value;
    }
}

# SkillSwap

SkillSwap is a JSP application for campus peer-to-peer skill exchanges. It uses Apache Tomcat 10.1 and MySQL-compatible SQL.

Users can create profiles, list skills to teach or learn, browse other students, manage swap requests, share contact details after a swap is accepted, leave reviews, and view activity analytics.

## Run locally with Docker

1. Install Docker Desktop and wait for the engine to start.
2. Copy `.env.example` to `.env` and replace both values with long, unique passwords.
3. From this directory, run `docker compose up --build`.
4. Open `http://localhost:8080/` and register an account.

Docker Compose initializes MySQL and stores its data in a named volume. To stop the app, press `Ctrl+C`; to start it again, run `docker compose up`.

## Free cloud deployment: Render and TiDB Cloud Starter

Render hosts the Docker web app, and TiDB Cloud Starter provides a MySQL-compatible database. Keep TiDB's monthly spending limit at zero and do not add a payment method. Within the free quotas, this setup does not require payment.

1. Push this project to the GitHub repository you will connect to Render.
2. Create a TiDB Cloud Starter instance in **MySQL Compatible** mode. Keep its spending limit at zero and note its host, port, username, password, and database name. TiDB usernames include an instance prefix.
3. Import `skillswap.sql` into that database using the connection settings from TiDB. Use TLS and certificate verification; the SQL creates tables but no demo accounts.
4. In Render, create a **Web Service** from the repository, select **Docker** as the runtime, and choose the **Free** instance type.
5. Add these environment variables to the Render service, using the values from TiDB:

   - `DB_HOST`
   - `DB_PORT`
   - `DB_NAME`
   - `DB_USER`
   - `DB_PASSWORD`
   - `DB_SSL=true`

6. Deploy and open the `onrender.com` URL. Register the first account in the app.

Render free web services sleep after 15 minutes without traffic and can take about a minute to wake. They have a monthly instance-hour allowance and may be suspended if free usage limits are exceeded. The app uses an external database, so keep usage modest. TiDB Starter requires TLS; the app verifies the database certificate when `DB_SSL=true`.

## Security notes

- Database credentials come from environment variables; do not commit `.env`.
- New passwords use PBKDF2-HMAC-SHA256. A successful login also upgrades a legacy plaintext password in an existing database.
- Debug and password-check JSPs are not included in this deployment copy.
- The SQL schema does not include demo accounts or passwords.

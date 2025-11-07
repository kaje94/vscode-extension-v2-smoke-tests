import ballerina/log;
import ballerina/sql;

public function main() returns error? {
    do {
        // Create the hospital_db database
        sql:ExecutionResult createDbResult = check postgresqlClient->execute(`CREATE DATABASE hospital_db`);
        log:printInfo("Database created successfully", affectedRowCount = createDbResult.affectedRowCount);

        // Create user with password
        sql:ExecutionResult createUserResult = check postgresqlClient->execute(`CREATE USER 'user'@'localhost' IDENTIFIED BY 'password'`);
        log:printInfo("User created successfully", affectedRowCount = createUserResult.affectedRowCount);

        // Grant privileges to the user
        sql:ExecutionResult grantPrivilegesResult = check postgresqlClient->execute(`GRANT ALL PRIVILEGES ON hospital_db.* TO 'user'@'localhost'`);
        log:printInfo("Privileges granted successfully", affectedRowCount = grantPrivilegesResult.affectedRowCount);

        // Create doctors table if it doesn't exist
        sql:ExecutionResult createTableResult = check postgresqlClient->execute(`
            CREATE TABLE IF NOT EXISTS doctors (
                id SERIAL PRIMARY KEY,
                name VARCHAR(50) DEFAULT NULL,
                hospital VARCHAR(50) DEFAULT NULL,
                speciality VARCHAR(50) DEFAULT NULL,
                availability VARCHAR(50) DEFAULT NULL,
                charge INTEGER DEFAULT NULL,
                sync INTEGER DEFAULT 0
            )
        `);
        log:printInfo("Doctors table created successfully", affectedRowCount = createTableResult.affectedRowCount);

        // Insert doctor records
        sql:ExecutionResult insertResult1 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('thomas collins', 'grand oak community hospital', 'surgery', '9.00 a.m - 11.00 a.m', 7000)`);
        sql:ExecutionResult insertResult2 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('henry parker', 'grand oak community hospital', ' ent', '9.00 a.m - 11.00 a.m', 4500)`);
        sql:ExecutionResult insertResult3 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('abner jones', 'grand oak community hospital', 'gynaecology', '8.00 a.m - 10.00 a.m', 11000)`);
        sql:ExecutionResult insertResult4 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('abner jones', 'grand oak community hospital', 'ent', '8.00 a.m - 10.00 a.m', 6750)`);
        sql:ExecutionResult insertResult5 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('anne clement', 'clemency medical center', 'surgery', '8.00 a.m - 10.00 a.m', 12000)`);
        sql:ExecutionResult insertResult6 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('thomas kirk', 'clemency medical center', 'gynaecology', '9.00 a.m - 11.00 a.m', 8000)`);
        sql:ExecutionResult insertResult7 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('cailen cooper', 'clemency medical center', 'paediatric', '9.00 a.m - 11.00 a.m', 5500)`);
        sql:ExecutionResult insertResult8 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('seth mears', 'pine valley community hospital', 'surgery', '3.00 p.m - 5.00 p.m', 8000)`);
        sql:ExecutionResult insertResult9 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('emeline fulton', 'pine valley community hospital', 'cardiology', '8.00 a.m - 10.00 a.m', 4000)`);
        sql:ExecutionResult insertResult10 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('jared morris', 'willow gardens general hospital', 'cardiology', '9.00 a.m - 11.00 a.m', 10000)`);
        sql:ExecutionResult insertResult11 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('henry foster', 'willow gardens general hospital', 'paediatric', '8.00 a.m - 10.00 a.m', 10000)`);
        sql:ExecutionResult insertResult12 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('chris brown', 'pine valley community hospital', 'surgery', '9.00 a.m - 11.00 a.m', 5500)`);
        sql:ExecutionResult insertResult13 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('victor ivan', 'pine valley community hospital', 'ent', '9.00 a.m - 11.00 a.m', 5500)`);
        sql:ExecutionResult insertResult14 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('jimmy carter', 'willow gardens general hospital', 'ent', '9.00 a.m - 11.00 a.m', 2500)`);
        sql:ExecutionResult insertResult15 = check postgresqlClient->execute(`INSERT INTO doctors (name, hospital, speciality, availability, charge) VALUES ('peter simon', 'clemency medical center', 'cardiology', '9.00 a.m - 11.00 a.m', 6000)`);
        
        int totalInserted = (insertResult1.affectedRowCount ?: 0) + (insertResult2.affectedRowCount ?: 0) + (insertResult3.affectedRowCount ?: 0) + 
                           (insertResult4.affectedRowCount ?: 0) + (insertResult5.affectedRowCount ?: 0) + (insertResult6.affectedRowCount ?: 0) + 
                           (insertResult7.affectedRowCount ?: 0) + (insertResult8.affectedRowCount ?: 0) + (insertResult9.affectedRowCount ?: 0) + 
                           (insertResult10.affectedRowCount ?: 0) + (insertResult11.affectedRowCount ?: 0) + (insertResult12.affectedRowCount ?: 0) + 
                           (insertResult13.affectedRowCount ?: 0) + (insertResult14.affectedRowCount ?: 0) + (insertResult15.affectedRowCount ?: 0);
        
        log:printInfo("Doctor records inserted successfully", totalRecords = totalInserted);

        log:printInfo("Database setup completed successfully");
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}

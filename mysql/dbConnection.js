const mysql = require('mysql');

const mysqlConnection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'vidly',
    multipleStatements: true,
});

mysqlConnection.connect((error) => {
    if (!error) {
        console.log(`Database connected!`);
    } else {
        console.log(`Failed to connect to the database!`);
    }
});


module.exports = mysqlConnection;
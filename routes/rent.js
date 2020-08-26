const mysqlConnection = require('../mysql/dbConnection');
const express = require('express');
const Router = express.Router();

Router.post('/', (req, res) => {
    let body = req.body;
    let phoneNumber = body.phone;

    let query = "select customer_id from customers where phone_number = ?"
    mysqlConnection.query(query, [phoneNumber], (err, rows, fields) => {
        if (!err) {

            res.status(200).send(rows[0]);
            console.log(rows);

        } else {
            res.status(500).send(`Failed to load user!`);
            console.log(err);
        }

    })
})

module.exports = Router;
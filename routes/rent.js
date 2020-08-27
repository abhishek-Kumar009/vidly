const mysqlConnection = require('../mysql/dbConnection');
const express = require('express');
const {
    response
} = require('express');
const Router = express.Router();

Router.post('/', (req, res) => {
    let body = req.body;
    let phoneNumber = body.phone;
    let movies = [];
    delete body.phone;
    for (key in body) {
        movies.push(body[key]);
    }

    //Get the customer_id of the user
    let query = "select customer_id from customers where phone_number = ?"
    mysqlConnection.query(query, [phoneNumber], (err, rows, fields) => {
        if (!err) {
            let customer_id = rows[0].customer_id.toString();
            let rents = [];
            let items = [];
            for (let i = 0; i < movies.length; i++) {
                items.push(customer_id);
                items.push(movies[i]);
                items.push('1');
                items.push('2020-08-21');
                rents.push(items);
                items = [];
            }
            query = "insert into rents(customer_id, bar_code, return_status_code, issue_date) values ?";
            mysqlConnection.query(query, [rents], (err, response) => {
                if (!err) {
                    res.send(`Rents created!`);
                    console.log(response);
                } else {
                    res.send(`Rents creation failed!`);
                }
            });

        } else {
            res.status(500).send(`Failed to load user!`);
            console.log(err);
        }

    });

});

module.exports = Router;
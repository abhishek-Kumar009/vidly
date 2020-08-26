const mysqlConnection = require('../mysql/dbConnection');
const express = require('express');
const Router = express.Router();

Router.post('/', (req, res) => {
    try {
        let body = req.body;
        //Extract the new customers data
        let newCustomer = [];
        let data = [];
        for (key in body) {
            newCustomer.push(body[key]);
        }
        data.push(newCustomer);
        // console.log(data);

        let query = "insert into customers values ?";
        mysqlConnection.query(query, [data], (error, response) => {
            if (!error) {
                res.status(200).send(`Customer added!`);
                console.log(response);
            } else {
                res.status(500).send(`Internal server error!`);
                console.log(error);
            }
        });

    } catch (error) {
        res.send(`Failed to add user!`);
    }


});

module.exports = Router;
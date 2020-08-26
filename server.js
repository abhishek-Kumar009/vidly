const express = require('express');
const bodyParser = require('body-parser');
const userRoute = require('./routes/user');

var app = express();

app.use(bodyParser.json());

const port = process.env.PORT || 3000;

app.use('/user', userRoute);


app.listen(port, () => {
    console.log(`Listening on port ${port}`);
});
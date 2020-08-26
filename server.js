const express = require('express');
const bodyParser = require('body-parser');
const userRoute = require('./routes/user');
const rentRoute = require('./routes/rent');

var app = express();

app.use(bodyParser.json());

const port = process.env.PORT || 3000;

app.use('/user', userRoute);
app.use('/rent', rentRoute);


app.listen(port, () => {
    console.log(`Listening on port ${port}`);
});
const express = require('express');
const bodyParser = require('body-parser');

var app = express();

app.use(bodyParser.json());

const port = process.env.PORT || 3000;



app.listen(port, () => {
    console.log(`Listening on port ${port} `)
})
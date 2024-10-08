const express = require('express');
const app = express();
const dotenv = require('dotenv').config();
const PORT = process.env.PORT || 3000;
const conn = require('./db')();
const cors = require('cors');
const router = require('./router');

app.use(express.json());
app.use(cors()); //Cors for middleware - To avoid blocks
app.use('/', router);

app.listen(PORT, () => {
    console.log('API is active on ', PORT);
})
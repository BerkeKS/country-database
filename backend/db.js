const mongoose = require('mongoose');

async function conn(){
    try{
        await mongoose.connect(process.env.DB_CONN);
        console.log("Database is connected");
    }catch(err){
        console.log("Error: ", err);
    }
}

module.exports = conn;
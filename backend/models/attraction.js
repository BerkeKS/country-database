const mongoose = require('mongoose')
const schema = mongoose.Schema

const attractionSchema = new schema({
    name : String,
    description: String,
    address: String
})

const attraction = mongoose.model("Attraction", attractionSchema)
module.exports = attraction
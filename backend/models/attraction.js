const mongoose = require('mongoose')
const { images } = require('../map')
const schema = mongoose.Schema

const attractionSchema = new schema({
    name : String,
    description: String,
    address: String,
    image: String
})

const attraction = mongoose.model("Attraction", attractionSchema)
module.exports = attraction
const { default: mongoose, Schema } = require("mongoose")

const schema = require("mongoose").Schema

const countrySchema = new schema ({
    name: String,
    intro: String,
    timezone: String,

    images: {
        type: Array,
        required: true
    },

    attractions: [{
        //Equal to DBRef annotation in Java Spring Boot
        type: "ObjectId", 
        ref: 'Attraction'
    }],

    soccerLeagues: {
        type: Array,
    }
})

const country = mongoose.model("Country", countrySchema)
module.exports = country
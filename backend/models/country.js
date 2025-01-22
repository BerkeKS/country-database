const { default: mongoose } = require("mongoose")
const { soccerLeagues } = require("../map")

const schema = require("mongoose").Schema

const countrySchema = new schema ({
    name: {
    },

    intro: {
        type: String
    },

    timezone: {
        type: String,
    },

    images: {
        type: Array,
        required: true
    },

    attractions: {
        type : Array,
        default : []
    },

    soccerLeagues: {
        type: Array,
    }
})

const country = mongoose.model("Country", countrySchema)
module.exports = country
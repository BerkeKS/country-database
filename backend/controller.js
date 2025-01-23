const images = require("./map").images
const timezones = require("./map").timezones
const soccerLeagues = require("./map").soccerLeagues
const attraction = require("./models/attraction")
const country = require("./models/country")

//For database updates - NOT accessible from frontend
const addCountries = async(req, res) => {
    images.forEach(async (value, key) => {
        var leagueArray = []
        if (soccerLeagues.has(key)) {
            leagueArray = soccerLeagues.get(key)
        }
        var countryIntro = ""
        var countryTimezone = timezones.get(key)
        var ctr = new country({
            name: key,
            intro: countryIntro,
            timezone: countryTimezone,
            images: value,
            attractions: [],
            soccerLeagues: leagueArray
        })
        await ctr.save()
    })
    return res.status(200).json({
        message: "Added!"
    })
}

const getCountry = async (req, res) => {
    var countryName = req.params
    country.findById("66e9534678952d9215828276")
    .populate("attractions.attraction")
    .then((document) => {
        return res.status(200).json({
            doc : document
        })
    })
    .catch((error) => {
        return res.status(400).json({
            err : error
        })
    })
    //.then((doc) => console.log(doc)).catch((err) => console.log(err))
    /*
    if (!responseCountry) {
        return res.status(404).json({
            message : "No country found"
        })
    }
    return res.status(200).json({
        message : responseCountry.name
    })
        */
}

//For database updates - NOT accessible from frontend
const addAttraction = async (req, res) => {
    try {
        const place = await attraction.findById("6792709243240507ce62c6c2")
        await country.findOneAndUpdate(
            {_id: "66e9534678952d9215828276"},
            {$addToSet: {attractions : place}}
        )
        return res.status(200).json({
            message: "Added!"
        })
    } catch (error) {
        return res.status(400).json({
            message : error
        })
    }
}
module.exports = {getCountry, addAttraction}
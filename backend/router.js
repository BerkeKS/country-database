const router = require('express').Router()
const controller = require('./controller')

router.get("/getcountry", controller.getCountry)

module.exports = router
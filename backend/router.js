const router = require('express').Router()
const controller = require('./controller')

router.get("/getcountry/:countryName", controller.getCountry)
router.post("/createattraction", controller.createAttraction)
router.get("/addattraction", controller.addAttraction)

module.exports = router
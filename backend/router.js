const router = require('express').Router()
const controller = require('./controller')

router.get("/getcountry", controller.getCountry)
router.post("/createattraction", controller.createAttraction)
router.get("/addattraction/:country_id", controller.addAttraction)

module.exports = router
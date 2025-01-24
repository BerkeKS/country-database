const router = require('express').Router()
const controller = require('./controller')

router.get("/getcountry/:country_id", controller.getCountry)
router.post("/createattraction", controller.createAttraction)
router.get("/addattraction", controller.addAttraction)

module.exports = router
const router = require('express').Router()
const controller = require('./controller')

router.get("/getCountry", controller.getCountry)

module.exports = router
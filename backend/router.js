const router = require('express').Router()
const controller = require('./controller')

router.get("/get", controller.getCountry)

module.exports = router
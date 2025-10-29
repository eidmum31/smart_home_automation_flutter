const express = require("express");
const router = express.Router();
const userController = require("../controllers/humidityController");

router
  .route("/:id")
  .get(userController.getHumidity)

  .post(userController.postHumidity);

module.exports = router;

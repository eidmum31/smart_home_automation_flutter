const express = require("express");
const router = express.Router();
const tempController = require("../controllers/tempController");

router
  .route("/:id")
  .get(tempController.getAllTemp)
  .post(tempController.checkBody, tempController.postTemp);

module.exports = router;

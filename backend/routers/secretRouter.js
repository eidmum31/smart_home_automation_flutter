const express = require("express");
const router = express.Router();
const secretController = require("../controllers/secretController");

router.route("/:id").post(secretController.secretGenerator);

module.exports = router;

const express = require("express");
const router = express.Router();
const ledController = require("../controllers/ledController");

router.route("/").get(ledController.getState).patch(ledController.updateState);
module.exports = router;

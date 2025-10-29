const express = require("express");
const router = express.Router();
const fanController = require("../controllers/fanController");

router.route("/").get(fanController.getState).patch(fanController.updateState);
module.exports = router;

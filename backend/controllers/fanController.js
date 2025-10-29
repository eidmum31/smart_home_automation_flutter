const { set } = require("../app");
const Fan = require("../models/fanModel");
exports.getState = async (req, res) => {
  const state = await Fan.findOne({ name: "fan" });
  res.status(200).json({ state });
};
exports.updateState = async (req, res) => {
  console.log(req.body);
  const a = await Fan.updateOne({ name: req.body.name }, { $set: req.body });

  res.status(200).json({ message: "successfull" });
};

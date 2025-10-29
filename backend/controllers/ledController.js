const { set } = require("../app");
const Led = require("../models/ledModel");
exports.getState = async (req, res) => {
  const state = await Led.findOne({ name: "light" });
  res.status(200).json({ state });
};
exports.updateState = async (req, res) => {
  const a = await Led.updateOne({ name: req.body.name }, { $set: req.body });
  res.status(200).json({ message: "successfull" });
};

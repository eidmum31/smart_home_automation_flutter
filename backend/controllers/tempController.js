// route handlers
const Temp = require("../models/tempModel");
//check the body
exports.checkBody = (req, res, next) => {
  const data = req.body;
  if (!data.temp) {
    return res.status(400).json({
      status: "bad request",
    });
  }
  next();
};

//get temp by the id
exports.getAllTemp = async (req, res) => {
  const id = req.params.id;
  console.log(id);
  try {
    const temps = await Temp.find({ userId: id });
    console.log(temps);
    res.status(200).json(temps);
  } catch (err) {
    res.status(404).json({
      status: "fail",
      err: err,
    });
  }
};
//post new temp
exports.postTemp = async (req, res) => {
  try {
    const newTemp = new Temp(req.body);
    const id = req.params.id;
    console.log(id);
    let timeString = new Date().toISOString().split("T");

    newTemp.time = timeString[1];
    newTemp.date = timeString[0];

    newTemp.userId = id;
    const temp = await newTemp.save();
    res.status(201).json({
      status: "success",
      results: 1,
      data: {
        temp: newTemp,
      },
    });
  } catch (err) {
    res.status(404).json({
      status: "fail",
      err,
    });
  }
};

// route handlers

const Humidity = require("../models/humidityModel");

//checking if the body is empty
exports.checkBody = (req, res, next) => {
  const data = req.body;
  if (!data.name || !data.price) {
    return res.status(400).json({
      status: "bad request",
    });
  }
  next();
};

//getting all the humidity

//get humidity by id
exports.getHumidity = async (req, res) => {
  const id = req.params.id;
  console.log(id);
  try {
    const humidity = await Humidity.find({ userId: id });
    console.log(humidity);
    res.status(200).json(humidity);
  } catch (err) {
    res.status(404).json({
      status: "fail",
      err: err,
    });
  }
};
//post new humidity
exports.postHumidity = async (req, res) => {
  try {
    const newHumidity = new Humidity(req.body);
    const id = req.params.id;
    console.log(id);
    let timeString = new Date().toISOString().split("T");

    newHumidity.time = timeString[1];
    newHumidity.date = timeString[0];
    newHumidity.userId = id;
    const humidity = await newHumidity.save();
    res.status(201).json(humidity);
  } catch (err) {
    res.status(404).json({
      status: "fail",
      err,
    });
  }
};
//update humidity

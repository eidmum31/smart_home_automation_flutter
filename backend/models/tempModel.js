const moongose = require("mongoose");
const tempSchema = new moongose.Schema({
  temp: {
    type: Number,
    required: true,
  },
  time: {
    type: String,
  },
  date: {
    type: String,
  },
  userId: {
    type: String,
  },
});
const Temp = moongose.model("Temp", tempSchema);
module.exports = Temp;

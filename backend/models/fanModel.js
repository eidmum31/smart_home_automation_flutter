const moongose = require("mongoose");
const fanSchema = new moongose.Schema({
  name: {
    type: String,
    required: true,
  },
  state: Number,
});
const Fan = moongose.model("Fan", fanSchema);
module.exports = Fan;

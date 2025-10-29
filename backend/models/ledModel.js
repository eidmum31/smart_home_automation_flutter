const moongose = require("mongoose");
const ledSchema = new moongose.Schema({
  name: {
    type: String,
    required: true,
  },
  state: Number,
});
const Led = moongose.model("Led", ledSchema);
module.exports = Led;

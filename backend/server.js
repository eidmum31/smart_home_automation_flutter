const moongose = require("mongoose");

const app = require("./app");

const port = 3000;
const DB = `mongodb+srv://Eidmum:12345@cluster0.wgjscsm.mongodb.net/?retryWrites=true&w=majority`;

//DB connection
moongose.connect(DB).then((con) => {
  console.log("sucessfully connected to database");
});

app.listen(port, () => {
  console.log(`listening to port ${port}`);
});

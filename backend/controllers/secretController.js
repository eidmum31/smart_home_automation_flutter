var jwt = require("jsonwebtoken");
exports.secretGenerator = async (req, res) => {
  console.log(req.body);
  const userId = req.params.id;
  const token = await jwt.sign({ userId: req.body.userId }, "eidmum1111");
  res.status(200).json({ toke: token });
};

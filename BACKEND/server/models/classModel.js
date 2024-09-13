const mongoose = require("mongoose");

const classSchema = mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  className: {
    type: String,
    required: true,
  },
  subjectName: {
    type: String,
    required: true,
  },
});
const Class = mongoose.model("Class", classSchema);

module.exports = Class;

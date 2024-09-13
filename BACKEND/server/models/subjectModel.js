const mongoose = require("mongoose");

const subjectSchema = mongoose.Schema({
    grade: {
        type: String,
        required: true,
  
    },
    subjectName: {
    type: String,
    required: true,
  },
  topicName: {
    type: String,
    required: true,
  },
  subtopic: [{
    type: String,
    required: true,
  }],
});
const Subject = mongoose.model("Subject", subjectSchema);

module.exports = Subject;

const mongoose = require("mongoose");

const emailSchema = mongoose.Schema({
  
    text: {
    type: String,
    required: true,
  },
  subject: {
    type: String,
    required: true,
  },
  recipients: [{
    type: String,
    required: true,
  }],
});
const Email = mongoose.model("Email", emailSchema);

module.exports = Email;
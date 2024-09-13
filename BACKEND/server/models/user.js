const mongoose = require("mongoose");
const cron = require('node-cron');

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    required: true,
    type: String,
  },
  phoneNumber: {
    required: true,
    type: String,
  },
  address: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    default:'user',
  },
  verificationCode: { type: String },
  verified: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now }
});
userSchema.index({ createdAt: 1 }, { expireAfterSeconds: 600 });

const User = mongoose.model("User", userSchema);



module.exports = User;

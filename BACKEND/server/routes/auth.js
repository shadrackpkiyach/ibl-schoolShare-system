const express = require("express");
const User = require("../models/user");
const Message = require("../models/messageModel");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");
const crypto = require("crypto");
const nodemailer = require("nodemailer");
const Email = require("../models/emailModel");


// SIGN UP

function generateVerificationCode() {
  return Math.floor(100000 + Math.random() * 900000);
}
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password, phoneNumber, } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    const verificationCode = generateVerificationCode();
    
       console.log("Verification Code:", verificationCode)

    let user = new User({
      email,
      password: hashedPassword,
      name,
      phoneNumber,
      type:'user',
      verificationCode, 
      verified: false,
      
    });
    user = await user.save();
    const transporter = nodemailer.createTransport({
      service: "Gmail",
      auth: {
        user: "kyleapps88@gmail.com",
      pass: "ugkvdwzouwcwugps",
      },
    });

    const mailOptions = {
      from: "kyleapps88@gmail.com",
      to: email,
      subject: "Email Verification Code",
      text: `Your verification code is: ${verificationCode}`,
    };

    transporter.sendMail(mailOptions, function (error, info) {
      if (error) {
        console.log("Error occurred:", error);
        // Handle the error when sending the verification code email
        res.status(500).json({ error: "Failed to send verification code." });
      } else {
        console.log("Verification code sent successfully!", info.response);
        res.json(user); // Return the user data in the response
      }
    });

    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/verify", async (req, res) => {
  try {
    const { email, verificationCode } = req.body;

    const user = await User.findOne({ email, verificationCode });
    if (!user) {
      return res.status(400).json({ error: "Invalid verification code." });
    }

    // If the verification code matches, set verified to true
    user.verified = true;
    await user.save();
   
    res.json({ message: "Email verified successfully!" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// Sign In Route
// Exercise
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    if (!user.verified) {
      return res.status(400).json({ msg: "Account not verified. Please verify your email." });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// get user data
authRouter.get("/getUserProfile", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});

authRouter.get("/",auth,async (req,res)=>{
  try {
      const user = await User.findById(req.user.id)               //({email: req.email})
      res.json(user)
  } catch (e) {
    res.status(500).json({error:e.message})  
  }
},
)

authRouter.get("/usersAdmin", async (req, res) => {
  try {
    const users = await User.find({ type: "admin" });
    res.json(users);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


authRouter.get("/usersOnly", async (req, res) => {
  try {
    const users = await User.find({ type: "user" });
    res.json(users);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.get("/emails", async (req, res) => {
  try {
    const emails = await Email.find();
    res.json(emails);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch emails" });
  }
});

authRouter.get("/usersAll", async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.get("/usersMessages", async (req, res) => {

  const { senderId , targetId} = req.query;
  try {
    const message = await Message.find({senderId:senderId,targetId:targetId});
    res.json(message);
   
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.get("/usersMessage", async (req, res) => {

  const { senderId , targetId} = req.query;
  try {
    const message = await Message.find({senderId:senderId,targetId:targetId});
    res.json(message);
    //console.log(targetId);
    //console.log(senderId);
    //console.log(message);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


authRouter.get("/everMessages", async (req, res) => {

  const { senderId } = req.query;
  try {
    const message = await Message.find({senderId:senderId});
    res.json(message);
    //console.log(targetId);
    //console.log(senderId);
    //console.log(message);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});






module.exports = authRouter;

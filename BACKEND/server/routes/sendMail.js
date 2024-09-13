const express = require("express");
const sendMessageRouter = express.Router();
const nodemailer = require("nodemailer");
const Email = require("../models/emailModel");

sendMessageRouter.post("/sendMail", async (req, res) => {

    try{
  const { recipients, subject, text } = req.body;

  let email = new Email({
    recipients,
    subject,
    text
    
  });
  email = await email.save();
  res.json(email);


  const transporter = nodemailer.createTransport({
    service: "Gmail",
    auth: {
      user: "kyleapps88@gmail.com",
      pass: "ugkvdwzouwcwugps",
    },
  });

  const mailOptions = {
    from: "kyleapps88@gmail.com",
    to: recipients.join(", "),
    subject: subject,
    text: text,
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log("Error occurred:", error);
      res.status(500).json({ error: "Failed to send email." });
    } else {
      console.log("Email sent successfully!", info.response);
      res.status(200).json({ message: "Email sent successfully!" });
    }
  });
}
 catch (e) {
    res.status(500).json({ error: e.message });
  }
}

);

module.exports = sendMessageRouter;

const express = require("express");
const adminRouter = express.Router();
const bcryptjs = require("bcryptjs");
const Class = require("../models/classModel");
const User = require("../models/user");
const Subject = require("../models/subjectModel");

adminRouter.post("/api/addClass", async (req, res) => {
    try {
      const {email, className, subjectName } = req.body;
  
     
     
  
      let classModel = new Class({
        email,
        className,
       
        subjectName
        
      });
      classModel = await classModel.save();
      res.json(classModel);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  adminRouter.post("/api/addAdmin", async (req, res) => {
    try {
      const { name, email, password, phoneNumber} = req.body;
  
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res
          .status(400)
          .json({ msg: "User with same email already exists!" });
      }
  
      const hashedPassword = await bcryptjs.hash(password, 8);
  
      let user = new User({
        email,
        password: hashedPassword,
        name,
        phoneNumber,
        type:'admin',
        verified: true
        
      });
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  
  adminRouter.post("/api/addTopics", async (req, res) => {
    try {
      const {grade, subjectName, topicName, subtopic } = req.body;
  
     
     
  
      let subjectModel = new Subject({
        grade,
        subjectName,
       
        topicName,
        subtopic
        
      });
      subjectModel = await subjectModel.save();
      res.json(subjectModel);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  adminRouter.get("/getClasses", async (req, res) => {
    const { email } = req.query; // Access the email from req.query instead of req.body
    try {
      const classes = await Class.find({ email });
      res.json(classes);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  adminRouter.post("/deleteClass", async (req, res) => {
    try {
      const { email, grade , subject} = req.body;
  
      // Assuming you have a "Class" model/schema defined
      // with properties like "email" and "grade"
      const deletedClass = await Class.deleteMany({  email:email,grade:grade,subject:subject });
  
      if (deletedClass.deletedCount === 0) {
        return res.status(404).json({ error: "No items found matching the criteria." });
      }
  
      res.json({ message: `${deletedClass.deletedCount} item(s) deleted successfully.` });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  
  
  
  
  module.exports = adminRouter;
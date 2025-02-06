import jwt from "jsonwebtoken";
import { User } from "../models/user.js";
import { jwtSecret } from "../config/config.js";
import { hashPassword, comparePassword } from "../utils/utils.js";

export async function registerUser(req, res) {
  const { email, name, password } = req.body;
  try {
    const isUserExists = await User.findOne({ email });
    if (isUserExists) {
      return res.status(400).json({ message: "User already exists , lets go" });
    }
    const hashedPassword = await hashPassword(password);
    const user = new User({ email, password: hashedPassword, name });

    await user.save();
    res.status(201).json({ message: "User created successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server Error" });
  }
}

export async function loginUser(req, res) {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "Invalid Credentials" });
    }

    const isMatch = await comparePassword(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ message: "Invalid Credentials" });
    }

    const payload = { user: user._id };
    const token = jwt.sign(payload, jwtSecret, {
      expiresIn: "1d",
    });
    user.password = undefined;
    res.status(200).json({ token, user });
  } catch (error) {
    res.status(500).json({ message: "Server Error" });
  }
}

export const user = async (req, res) => {
  try {
    const id = req.user;
    const user = await User.findById(id);
    user.password = undefined;
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({
      message: "Error fetching user analysis Internal server error",
    });
  }
};

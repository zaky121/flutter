import express from "express";
import {
  loginUser,
  registerUser,
  user,
} from "../controllers/authController.js";
import { auth } from "../middlewares/middleware.js";

const router = express.Router();

router.post("/register", registerUser);

router.post("/login", loginUser);

router.get("/", auth, user);

export default router;

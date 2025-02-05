import jwt from "jsonwebtoken";
import { jwtSecret } from "../config/config.js";
export function auth(req, res, next) {
  try {
    const token = req.header("Authorization").replace("Bearer ", "");

    if (!token) {
      return res
        .status(401)
        .json({ message: "No token, authorization denied" });
    }

    jwt.verify(token, jwtSecret, (err, decoded) => {
      if (err) {
        res.status(401).json({ message: "Token is not valid" });
      }

      req.user = decoded.user;

      next();
    });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
}

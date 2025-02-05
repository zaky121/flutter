import chalk from "chalk";
import compression from "compression";
import cookieParser from "cookie-parser";
import cors from "cors";
import express from "express";
import rateLimit from "express-rate-limit";
import helmet from "helmet";
import morgan from "morgan";
import { nodeEnv, port } from "./config/config.js";
import connectDB from "./config/db.js";
import authRoutes from "./routes/authRoutes.js";
import taskRoutes from "./routes/taskRoute.js";

const app = express();
app.use(cookieParser());

app.use(helmet());

app.use(cors());

if (nodeEnv === "development") {
  app.use(morgan("dev"));
}

app.use(compression());

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
});
app.use(limiter);

app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/tasks", taskRoutes);

app.get("/", (req, res) => {
  res.status(200).json({ message: "Hello World" });
});

app.use((err, req, res, next) => {
  console.error(chalk.red(err.stack));
  res.status(err.status || 500).json({
    message: err.message || "Internal Server Error",
    error: {},
  });
});

connectDB();

app.listen(port, () => {
  console.log(`${chalk.green.bold("Server")} is listening on port ${port}`);
});

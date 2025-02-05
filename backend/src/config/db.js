import chalk from "chalk";
import { connect } from "mongoose";
import { dbName, dbUrl } from "./config.js";
export const connectDB = async () => {
  connect(dbUrl, { dbName })
    .then(() => {
      console.log(`${chalk.green.bold("Connected")} to the database`);
    })
    .catch((error) => {
      console.log(`${chalk.red.bold("Error")} connecting to database`, error);
      process.exit(1);
    });
};
export default connectDB;

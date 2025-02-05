import { Task } from "../models/task.js";
import { dateSpecified, monthSpecified } from "../utils/utils.js";

export const dailyTasksAnalysis = async (req, res) => {
  try {
    const user = req.user;

    const day = new Date();

    const { startOfDay, endOfDay } = dateSpecified(day);

    const tasks = await Task.find({
      $and: [{ user }, { createdAt: { $gt: startOfDay, $lte: endOfDay } }],
    }).sort({ createdAt: -1 });

    let done = 0;
    let unDone = 0;

    tasks.forEach((task) => (task.isDone ? done++ : unDone++));

    res.status(200).json({ done, unDone });
  } catch (error) {
    res.status(500).json({
      message: "Error fetching tasks analysis Internal server error",
    });
  }
};
export const overAllTasksAnalysis = async (req, res) => {
  try {
    const user = req.user;

    const tasks = await Task.find({ user }).sort({ createdAt: -1 });

    let done = 0;
    let unDone = 0;

    tasks.forEach((task) => (task.isDone ? done++ : unDone++));

    res.status(200).json({ done, unDone });
  } catch (error) {
    res.status(500).json({
      message: "Error fetching tasks analysis Internal server error",
    });
  }
};

export const overDueTask = async (req, res) => {
  try {
    const user = req.user;
    const date = new Date();

    const { startOfDay } = dateSpecified(date);

    const tasks = await Task.find({
      $and: [{ user }, { due: { $lt: startOfDay } }, { isDone: false }],
    }).sort({ createdAt: -1 });

    res.status(200).json(tasks.length);
  } catch (error) {
    res.status(500).json({
      message: "Error fetching tasks analysis Internal server error",
    });
  }
};

export const monthlyTaskAnalysis = async (req, res) => {
  try {
    const user = req.user;

    const { date } = req.params;

    const { startOfMonth, endOfMonth } = monthSpecified(new Date(date));

    const tasks = await Task.find({
      $and: [{ user }, { createdAt: { $gte: startOfMonth, $lte: endOfMonth } }],
    });

    console.log({ startOfMonth, endOfMonth });

    const data = {};

    tasks.forEach((task) => {
      const label = task.createdAt.toLocaleString().split(",")[0];
      if (data[label]) {
        data[label] += 1;
      } else {
        data[label] = 1;
      }
    });

    const labels = Object.keys(data);
    const counts = Object.values(data);

    res.status(200).json({ labels, counts });
  } catch (error) {
    res.status(500).json({
      message: "Error fetching tasks analysis Internal server error",
    });
  }
};

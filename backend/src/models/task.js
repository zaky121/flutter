import { Schema, Types, model } from "mongoose";

const taskSchema = new Schema(
  {
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
    },
    due: {
      type: Date,
      required: true,
    },
    user: {
      type: Types.ObjectId,
      required: true,
    },
    isDone: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

export const Task = model("Task", taskSchema);

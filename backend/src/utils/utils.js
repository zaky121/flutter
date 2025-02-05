import bcrypt from "bcrypt";

export const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(12);
  const hashedPassword = await bcrypt.hash(password, salt);
  return hashedPassword;
};

export const comparePassword = async (password, hashedPassword) => {
  return await bcrypt.compare(password, hashedPassword);
};

export const dateSpecified = (date) => {
  const startOfDay = new Date(date);
  startOfDay.setHours(0, 0, 0, 0);

  const endOfDay = new Date(date);
  endOfDay.setHours(23, 59, 59, 999);

  return { startOfDay, endOfDay };
};
export const monthSpecified = (date) => {
  const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 2);
  startOfMonth.setHours(0, 0, 0, 0);

  const endOfMonth = new Date(
    startOfMonth.getFullYear(),
    startOfMonth.getMonth() + 1,
    0
  );
  endOfMonth.setHours(23, 59, 59, 999);

  return { startOfMonth, endOfMonth };
};

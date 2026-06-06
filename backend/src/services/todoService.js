const Todo = require('../models/Todo');

async function listTodos() {
  return Todo.find().sort({ createdAt: -1 });
}

async function createTodo(title) {
  return Todo.create({ title });
}

async function toggleTodo(todoId) {
  const todo = await Todo.findById(todoId);

  if (!todo) {
    return null;
  }

  todo.completed = !todo.completed;
  await todo.save();

  return todo;
}

async function deleteTodo(todoId) {
  return Todo.findByIdAndDelete(todoId);
}

module.exports = {
  listTodos,
  createTodo,
  toggleTodo,
  deleteTodo
};
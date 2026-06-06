module.exports = {
  async up(db) {
    const todos = db.collection('todos');
    const count = await todos.countDocuments();

    if (count === 0) {
      await todos.insertOne({
        title: 'Initial demo todo',
        completed: false,
        createdAt: new Date(),
        updatedAt: new Date()
      });
    }
  },

  async down(db) {
    await db.collection('todos').deleteOne({ title: 'Initial demo todo' });
  }
};
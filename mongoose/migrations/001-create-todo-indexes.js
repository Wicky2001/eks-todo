module.exports = {
  async up(db) {
    await db.collection('todos').createIndex({ completed: 1, createdAt: -1 });
  },

  async down(db) {
    await db.collection('todos').dropIndex('completed_1_createdAt_-1').catch(() => {});
  }
};
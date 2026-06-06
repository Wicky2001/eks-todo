const fs = require('fs');
const path = require('path');
const mongoose = require('mongoose');

require('dotenv').config({ path: path.resolve(__dirname, '.env') });

const migrationsDir = path.join(__dirname, 'migrations');
const direction = process.argv[2] === 'down' ? 'down' : 'up';

async function run() {
  const uri = process.env.MONGODB_URI;

  if (!uri) {
    throw new Error('MONGODB_URI is required');
  }

  await mongoose.connect(uri, { serverSelectionTimeoutMS: 5000 });

  const db = mongoose.connection.db;
  const migrations = fs
    .readdirSync(migrationsDir)
    .filter((fileName) => fileName.endsWith('.js'))
    .sort();

  const logCollection = db.collection('migrations');
  const appliedMigrations = await logCollection.find({}).toArray();
  const appliedNames = new Set(appliedMigrations.map((migration) => migration.name));

  if (direction === 'up') {
    for (const fileName of migrations) {
      if (appliedNames.has(fileName)) {
        continue;
      }

      const migration = require(path.join(migrationsDir, fileName));

      if (typeof migration.up !== 'function') {
        throw new Error(`Migration ${fileName} does not export an up function`);
      }

      await migration.up(db);
      await logCollection.insertOne({ name: fileName, appliedAt: new Date() });
      console.log(`Applied ${fileName}`);
    }
  } else {
    const orderedApplied = appliedMigrations.map((migration) => migration.name).reverse();

    for (const fileName of orderedApplied) {
      const migration = require(path.join(migrationsDir, fileName));

      if (typeof migration.down === 'function') {
        await migration.down(db);
      }

      await logCollection.deleteOne({ name: fileName });
      console.log(`Reverted ${fileName}`);
    }
  }

  await mongoose.disconnect();
}

run().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
# Mongoose migrations

This folder holds a simple migration runner and example migration files.

Run migrations with:

```bash
npm run migrate --workspace mongoose
```

The runner reads `mongoose/.env` and expects `MONGODB_URI` to point at the local database.
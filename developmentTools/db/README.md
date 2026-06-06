# Local DocumentDB

This folder contains the Docker Compose setup for the local DocumentDB-compatible database used by the todo app.

If you prefer the single-container command, use:

```bash
docker run -dt -p 10260:10260 --name docdb ghcr.io/documentdb/documentdb/documentdb-local:latest --username demo --password demo
```

For the app scaffold, the backend expects a `MONGODB_URI` value that points at the local database on port `10260`.
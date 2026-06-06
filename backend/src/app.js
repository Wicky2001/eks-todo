const express = require('express');
const cors = require('cors');
const morgan = require('morgan');

const todoRoutes = require('./routes/todoRoutes');
const { notFound, errorHandler } = require('./middleware/errorHandler');

const app = express();
app.set("trust proxy", true);
const allowedOrigin = process.env.CORS_ORIGIN || 'http://localhost:8080';



const whitelist = process.env.CORS_ORIGINS.split(",")
  .map((origin) => origin.trim())
  .filter(Boolean);

const corsOptions = {
  credentials: true,
  origin: function (origin, callback) {
    if (!origin || whitelist.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error("Not Allowed by CORS"));
    }
  },
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(morgan('dev'));

app.get('/health', (_request, response) => {
  response.json({ status: 'ok' });
});

app.use('/api/todos', todoRoutes);

app.use(notFound);
app.use(errorHandler);

module.exports = app;
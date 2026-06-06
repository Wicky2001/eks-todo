function notFound(_request, response, next) {
  const error = new Error('Route not found');
  error.statusCode = 404;
  next(error);
}

function errorHandler(error, _request, response, _next) {
  const statusCode = response.statusCode && response.statusCode !== 200 ? response.statusCode : error.statusCode || 500;

  response.status(statusCode).json({
    message: error.message || 'Internal Server Error'
  });
}

module.exports = {
  notFound,
  errorHandler
};
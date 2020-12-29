// https://blog.elmah.io/asp-net-core-request-logging-middleware/
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

namespace dotnet_core_test
{
    public class RequestLoggingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger _logger;

        public RequestLoggingMiddleware(RequestDelegate next, ILoggerFactory loggerFactory)
        {
            _next = next;
            _logger = loggerFactory.CreateLogger<RequestLoggingMiddleware>();
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            finally
            {
                _logger.LogInformation(
                    "Request {method} {url} {user-agent} => {statusCode}",
                    context.Request?.Method,
                    context.Request?.Path.Value,
                    context.Request?.Headers["User-Agent"].ToString(),
                    context.Response?.StatusCode);
            }
        }
    }
}
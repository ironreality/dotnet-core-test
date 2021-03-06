using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Prometheus;

namespace dotnet_core_test
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddHealthChecks();
            services.AddControllers();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            var counter_api_paths_requests = Metrics.CreateCounter("meteoservice_api_paths_requests_total", "Counts requests to the API endpoints", new CounterConfiguration
            {
                LabelNames = new[] { "method", "endpoint"}
            });

            app.Use((context, next) =>
            {
                counter_api_paths_requests.WithLabels(context.Request.Method, context.Request.Path).Inc();
                return next();
            });

            // request logger
            app.UseMiddleware<RequestLoggingMiddleware>();

            // Use the Prometheus middleware
            // need to use /prometheus in order to collaborate with Keptn CD tool
            app.UseMetricServer("/prometheus");
            app.UseHealthChecks("/healthz");
            app.UseHealthChecks("/health");

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRouting();
            app.UseHttpMetrics();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}

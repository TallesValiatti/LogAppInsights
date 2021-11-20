using Microsoft.AspNetCore.Mvc;

namespace LogAppInsights.Controllers;

[ApiController]
[Route("[controller]")]
public class LoggingController : ControllerBase
{
    private readonly ILogger<LoggingController> _logger;
   public LoggingController(ILogger<LoggingController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public IActionResult Get()
    {
        _logger.LogTrace("Log information message.");
        _logger.LogDebug("Log information message.");
        _logger.LogInformation("Log information message.");
        _logger.LogWarning("Log warning message.");
        _logger.LogError("Log error message.");
        _logger.LogCritical("Log critical message.");
        
        return Ok();
    }
}

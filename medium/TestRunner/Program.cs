using Npgsql;
using System.Data;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace TestRunner;

class Program
{
    static async Task<int> Main(string[] args)
    {
        Console.WriteLine("=" + new string('=', 59));
        Console.WriteLine("🎓 SQL Practice Platform - Test Runner");
        Console.WriteLine("=" + new string('=', 59));

        var runner = new SQLTestRunner();
        await runner.RunAllTestsAsync();

        return 0;
    }
}

public class SQLTestRunner
{
    private readonly string _connectionString;
    private readonly string _usersDir;
    private readonly string _solutionsDir;
    private readonly string _resultsDir;

    public SQLTestRunner()
    {
        var serverName = Environment.GetEnvironmentVariable("POSTGRES_HOST") ?? "localhost";

        _connectionString = new NpgsqlConnectionStringBuilder
        {
            Host = serverName,
            Port = 5432,
            Database = "sqlpracticedb",
            Username = "postgres",
            Password = "postgres"
        }.ConnectionString;

        _usersDir = Path.Combine(Directory.GetCurrentDirectory(), "users");
        _solutionsDir = Path.Combine(Directory.GetCurrentDirectory(), "solution-script");
        _resultsDir = Path.Combine(Directory.GetCurrentDirectory(), "results");

        Directory.CreateDirectory(_resultsDir);
    }

    private async Task<NpgsqlConnection> ConnectDbAsync()
    {
        try
        {
            var connection = new NpgsqlConnection(_connectionString);
            await connection.OpenAsync();
            return connection;
        }
        catch (Exception e)
        {
            Console.WriteLine($"Error connecting to database: {e.Message}");
            throw;
        }
    }

    private async Task<QueryResult> ExecuteQueryAsync(NpgsqlConnection conn, string query)
    {
        try
        {
            using var command = new NpgsqlCommand(query, conn);
            using var reader = await command.ExecuteReaderAsync();

            var results = new List<Dictionary<string, object?>>();
            var columns = new List<string>();

            for (int i = 0; i < reader.FieldCount; i++)
            {
                columns.Add(reader.GetName(i));
            }

            while (await reader.ReadAsync())
            {
                var row = new Dictionary<string, object?>();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    var value = reader.GetValue(i);

                    if (value is double doubleValue)
                        value = Math.Round(doubleValue, 2);
                    else if (value is decimal decimalValue)
                        value = Math.Round(decimalValue, 2);
                    else if (value is DBNull)
                        value = null;

                    row[columns[i]] = value;
                }
                results.Add(row);
            }

            return new QueryResult
            {
                Success = true,
                Data = results,
                Columns = columns
            };
        }
        catch (Exception e)
        {
            return new QueryResult
            {
                Success = false,
                Error = e.Message
            };
        }
    }

    private List<Dictionary<string, object?>> NormalizeResults(List<Dictionary<string, object?>> results)
    {
        if (results == null || results.Count == 0)
            return new List<Dictionary<string, object?>>();

        try
        {
            return results.OrderBy(x => JsonSerializer.Serialize(x, new JsonSerializerOptions
            {
                WriteIndented = false
            })).ToList();
        }
        catch
        {
            return results;
        }
    }

    private (bool Passed, double Score, string Message) CompareResults(QueryResult userResults, QueryResult expectedResults)
    {
        if (!userResults.Success)
            return (false, 0.0, $"Query execution failed: {userResults.Error}");

        if (!expectedResults.Success)
            return (false, 0.0, $"Expected solution failed: {expectedResults.Error}");

        var userData = NormalizeResults(userResults.Data);
        var expectedData = NormalizeResults(expectedResults.Data);

        var userColumns = new HashSet<string>(userResults.Columns);
        var expectedColumns = new HashSet<string>(expectedResults.Columns);
        
        var score = 0.0;
        var totalPoints = 0.0;
        var messages = new List<string>();

        totalPoints += 30;
        if (userColumns.SetEquals(expectedColumns))
        {
            score += 30;
            messages.Add("✅ Column structure correct");
        }
        else
        {
            var missingColumns = expectedColumns.Except(userColumns);
            var extraColumns = userColumns.Except(expectedColumns);
            
            if (missingColumns.Any())
                messages.Add($"❌ Missing columns: [{string.Join(", ", missingColumns)}]");
            if (extraColumns.Any())
                messages.Add($"❌ Extra columns: [{string.Join(", ", extraColumns)}]");
                
            // Partial credit for having some correct columns
            var correctColumns = userColumns.Intersect(expectedColumns).Count();
            var partialScore = (double)correctColumns / expectedColumns.Count * 30;
            score += partialScore;
            messages.Add($"⚠️  Partial column credit: {correctColumns}/{expectedColumns.Count} columns correct");
        }

        totalPoints += 20;
        if (userData.Count == expectedData.Count)
        {
            score += 20;
            messages.Add($"✅ Row count correct ({userData.Count} rows)");
        }
        else
        {
            messages.Add($"❌ Row count mismatch. Expected {expectedData.Count} rows, got {userData.Count} rows");
            // Partial credit based on how close the row count is
            if (expectedData.Count > 0)
            {
                var rowRatio = Math.Min(1.0, (double)userData.Count / expectedData.Count);
                var partialScore = rowRatio * 20;
                score += partialScore;
                messages.Add($"⚠️  Partial row count credit: {partialScore:F1}/20 points");
            }
        }

        // Data accuracy evaluation (50% of total score)
        totalPoints += 50;
        if (userData.Count > 0 && expectedData.Count > 0 && userColumns.Intersect(expectedColumns).Any())
        {
            var commonColumns = userColumns.Intersect(expectedColumns).ToList();
            var maxRowsToCheck = Math.Min(userData.Count, expectedData.Count);
            var totalCells = maxRowsToCheck * commonColumns.Count;
            var correctCells = 0;

            for (int i = 0; i < maxRowsToCheck; i++)
            {
                var userRow = userData[i];
                var expectedRow = expectedData[i];

                foreach (var col in commonColumns)
                {
                    var userValue = userRow.ContainsKey(col) ? userRow[col] : null;
                    var expectedValue = expectedRow.ContainsKey(col) ? expectedRow[col] : null;

                    if (userValue == null && expectedValue == null)
                    {
                        correctCells++;
                        continue;
                    }
                    if (userValue != null && expectedValue != null && 
                        userValue.ToString()!.Equals(expectedValue.ToString()))
                    {
                        correctCells++;
                    }
                }
            }

            if (totalCells > 0)
            {
                var dataAccuracy = (double)correctCells / totalCells;
                var dataScore = dataAccuracy * 50;
                score += dataScore;
                messages.Add($"📊 Data accuracy: {correctCells}/{totalCells} cells correct ({dataAccuracy:P1})");
                
                if (dataAccuracy == 1.0)
                    messages.Add("✅ All data values match!");
                else if (dataAccuracy > 0.8)
                    messages.Add($"⚠️  Minor data discrepancies detected");
                else
                    messages.Add($"❌ Significant data discrepancies detected");
            }
        }
        else if (userData.Count == 0 && expectedData.Count == 0)
        {
            score += 50;
            messages.Add("✅ Both queries return empty results (correct)");
        }

        var finalScore = Math.Round(score / totalPoints * 100, 1);
        var passed = finalScore >= 70.0; // Consider 70% as passing threshold
        
        var message = string.Join(" | ", messages);
        return (passed, finalScore, $"Score: {finalScore}% - {message}");
    }

    private (string? ProblemId, string? Email) ParseFilename(string filename)
    {
        try
        {
            var name = Path.GetFileNameWithoutExtension(filename);
            var parts = name.Split('_', 3);

            if (parts.Length >= 3 && parts[0] == "problem")
            {
                return (parts[1], parts[2]);
            }
        }
        catch { }

        return (null, null);
    }

    private async Task<TestResult?> TestUserSolutionAsync(string userFile)
    {
        var (problemId, email) = ParseFilename(Path.GetFileName(userFile));

        if (problemId == null || email == null)
        {
            Console.WriteLine($"❌ Invalid filename format: {Path.GetFileName(userFile)}");
            Console.WriteLine("   Expected format: -<id>_<email>.sql");
            return null;
        }

        string userQuery;
        try
        {
            userQuery = await File.ReadAllTextAsync(userFile);
        }
        catch (Exception e)
        {
            Console.WriteLine($"❌ Error reading user file: {e.Message}");
            return null;
        }

        var solutionFile = Path.Combine(_solutionsDir, $"solution-{problemId}.sql");
        if (!File.Exists(solutionFile))
        {
            Console.WriteLine($"❌ Solution file not found: {solutionFile}");
            return null;
        }

        string expectedQuery;
        try
        {
            expectedQuery = await File.ReadAllTextAsync(solutionFile);
        }
        catch (Exception e)
        {
            Console.WriteLine($"❌ Error reading solution file: {e.Message}");
            return null;
        }

        using var conn = await ConnectDbAsync();

        try
        {
            Console.WriteLine($"\n📝 Testing Problem {problemId} for {email}");
            var userResults = await ExecuteQueryAsync(conn, userQuery);

            var expectedResults = await ExecuteQueryAsync(conn, expectedQuery);

            var (passed, score, message) = CompareResults(userResults, expectedResults);

            var result = new TestResult
            {
                Email = email,
                ProblemId = problemId,
                Passed = passed,
                Score = score,
                Message = message,
                Timestamp = DateTime.Now,
                UserFile = userFile
            };

            if (passed)
                Console.WriteLine($"✅ PASSED - {message}");
            else
                Console.WriteLine($"❌ FAILED - {message}");

            return result;
        }
        catch (Exception e)
        {
            Console.WriteLine($"❌ Error during test execution: {e.Message}");
            return null;
        }
    }

    private async Task SaveResultsAsync(List<TestResult> results)
    {
        if (results.Count == 0)
            return;

        var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
        var resultFile = Path.Combine(_resultsDir, $"test_results_{timestamp}.json");

        try
        {
            var options = new JsonSerializerOptions
            {
                WriteIndented = true,
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            };

            var json = JsonSerializer.Serialize(results, options);
            await File.WriteAllTextAsync(resultFile, json);
            Console.WriteLine($"\n📊 Results saved to: {resultFile}");
        }
        catch (Exception e)
        {
            Console.WriteLine($"❌ Error saving results: {e.Message}");
        }
    }

    public async Task RunAllTestsAsync()
    {
        if (!Directory.Exists(_usersDir))
        {
            Console.WriteLine($"❌ Users directory not found: {_usersDir}");
            return;
        }

        var userFiles = Directory.GetFiles(_usersDir, "*.sql");

        if (userFiles.Length == 0)
        {
            Console.WriteLine($"⚠️  No user solutions found in {_usersDir}");
            return;
        }

        Console.WriteLine($"🚀 Found {userFiles.Length} user solution(s)");

        var allResults = new List<TestResult>();
        foreach (var userFile in userFiles)
        {
            var result = await TestUserSolutionAsync(userFile);
            if (result != null)
                allResults.Add(result);
        }

        await SaveResultsAsync(allResults);

        Console.WriteLine("\n" + new string('=', 60));
        Console.WriteLine("📈 SUMMARY");
        Console.WriteLine(new string('=', 60));
        var passed = allResults.Count(r => r.Passed);
        var failed = allResults.Count - passed;
        var averageScore = allResults.Count > 0 ? allResults.Average(r => r.Score) : 0;
        
        Console.WriteLine($"Total: {allResults.Count} | Passed (≥70%): {passed} | Failed (<70%): {failed}");
        Console.WriteLine($"Average Score: {averageScore:F1}%");
        
        if (allResults.Count > 0)
        {
            Console.WriteLine("\n📊 Individual Scores:");
            foreach (var result in allResults.OrderByDescending(r => r.Score))
            {
                var status = result.Passed ? "✅" : "❌";
                Console.WriteLine($"   {status} {result.Email} - Problem {result.ProblemId}: {result.Score:F1}%");
            }
        }
        Console.WriteLine(new string('=', 60));
    }
}

public class QueryResult
{
    public bool Success { get; set; }
    public List<Dictionary<string, object?>> Data { get; set; } = new();
    public List<string> Columns { get; set; } = new();
    public string? Error { get; set; }
}

public class TestResult
{
    [JsonPropertyName("email")]
    public string Email { get; set; } = "";

    [JsonPropertyName("problem-id")]
    public string ProblemId { get; set; } = "";

    [JsonPropertyName("passed")]
    public bool Passed { get; set; }

    [JsonPropertyName("score")]
    public double Score { get; set; }

    [JsonPropertyName("message")]
    public string Message { get; set; } = "";

    [JsonPropertyName("timestamp")]
    public DateTime Timestamp { get; set; }

    [JsonPropertyName("user_file")]
    public string UserFile { get; set; } = "";
}

FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /app

COPY TestRunner.csproj .
RUN dotnet restore

COPY Program.cs .

RUN dotnet build -c Release

ENTRYPOINT ["dotnet", "run", "--no-build", "-c", "Release"]

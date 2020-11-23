FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY dotnet-core-test.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "dotnet-core-test.dll"]

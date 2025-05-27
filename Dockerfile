# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files
COPY ./AcademiaNovit/AcademiaNovit.csproj ./

# Restore the project dependencies
RUN dotnet restore

# Copy the rest of the application files
COPY ./AcademiaNovit ./

# Build the application
RUN dotnet publish -c Release -o /out

COPY ./AcademiaNovit/Data.db /out

# Use the official .NET runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /out .

# Expose the port the application runs on
EXPOSE 8080

# Set the entry point for the container
ENTRYPOINT ["dotnet", "AcademiaNovit.dll"]
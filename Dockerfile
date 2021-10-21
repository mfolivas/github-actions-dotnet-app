FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
ARG DIST_DIR_NAME
WORKDIR /app
COPY app/src/Sample/bin/Debug/net5.0/Sample.dll ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
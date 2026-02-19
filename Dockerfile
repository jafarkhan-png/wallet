FROM dart:stable AS build
WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe main.dart -o bin/server

FROM debian:stable-slim
WORKDIR /app
COPY --from=build /runtime/ /runtime/
COPY --from=build /app/bin/server /app/server
ENV PATH="/runtime/bin:${PATH}"
EXPOSE 8080
CMD ["/app/server"]
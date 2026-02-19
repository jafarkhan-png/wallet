FROM dart:stable AS build
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get --offline || dart pub get
COPY main.dart ./
RUN mkdir -p bin && dart compile exe main.dart -o bin/server

FROM debian:stable-slim
WORKDIR /app
COPY --from=build /runtime/ /runtime/
COPY --from=build /app/bin/server /app/server
ENV PATH="/runtime/bin:${PATH}"
EXPOSE 8080
CMD ["/app/server"]
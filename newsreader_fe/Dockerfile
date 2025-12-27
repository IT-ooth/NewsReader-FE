# ----------------------------------------------------------------
# Stage 1: Flutter Build Web
# ----------------------------------------------------------------
FROM debian:latest AS build-env

# 필수 패키지 설치
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Flutter SDK 설치
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Flutter 웹 활성화 및 프리페치
RUN flutter config --enable-web
RUN flutter doctor

# 소스 코드 복사 및 빌드
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# ----------------------------------------------------------------
# Stage 2: Serve with Nginx
# ----------------------------------------------------------------
FROM nginx:alpine

# Nginx 설정 파일 복사 (SPA 지원용)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 빌드된 웹 파일 복사
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
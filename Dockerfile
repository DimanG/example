# Використовуємо офіційний Maven-образ як базовий
FROM maven:3.9.9-eclipse-temurin-17 AS build

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо файл pom.xml та завантажуємо залежності (щоб кешування працювало)
COPY pom.xml .
RUN mvn dependency:go-offline

# Копіюємо весь вихідний код у контейнер
COPY src ./src

# Збираємо JAR-файл
RUN mvn clean package -DskipTests

RUN ls -lah /app/target/

# Використовуємо офіційний JDK-образ для запуску застосунку
FROM eclipse-temurin:23-jdk

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо зібраний JAR-файл з попереднього контейнера
COPY --from=build ./out/artifacts/example_jar/example.jar /app/example.jar

# Вказуємо команду для запуску застосунку
CMD ["java", "-jar", "example.jar"]
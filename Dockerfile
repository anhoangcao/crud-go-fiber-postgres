# Stage 1: Build the Go app
FROM golang:1.20-alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build -o go-fiber-postgres .

# Stage 2: Run the Go app
FROM alpine:latest

# Install necessary packages (e.g., for connecting to PostgreSQL)
RUN apk --no-cache add ca-certificates

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the Pre-built binary file from the builder stage
COPY --from=builder /app/go-fiber-postgres .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./go-fiber-postgres"]

# Stage 1: Build the Go application
FROM golang:1.20 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files (go.mod and go.sum) to the working directory
COPY go.mod go.sum ./

# Download and cache the Go module dependencies
RUN go mod download

# Copy the rest of the application source code to the working directory
COPY . .

# Build the Go application with static linking
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o app .

# Stage 2: Create a minimal runtime image
FROM scratch

# Copy the built binary from the builder stage
COPY --from=builder /app/app /app/app

# Create a non-root user for running the application
#USER 1000

# Set the working directory inside the container
WORKDIR /app

# Expose a port if your application listens on a specific port
EXPOSE 9090


# Define the command to run your application when the container starts
CMD ["./app"]


# Use the official Go image as the base
FROM golang:1.21.0


# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files to download dependencies
COPY go.mod go.sum ./
COPY database/go.mod database/go.sum ./database/
COPY middleware/go.mod ./middleware/
COPY graph/go.mod graph/go.sum ./graph/

RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN go build -o waypoint

# Command to run the application
CMD ["./waypoint"]

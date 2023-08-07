# Use the official Rust nightly image as the build environment
FROM rustlang/rust:nightly as builder

# Create a new empty shell project
RUN USER=root cargo new --bin generate-code
WORKDIR /generate-code

# Copy over your manifest
COPY ./Cargo.toml ./Cargo.toml

# This build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# Copy your source tree
COPY ./src ./src

# Build for release
RUN rm ./target/release/deps/generate_code*
RUN cargo build --release

# Now, we need a minimal runtime environment
FROM debian:buster-slim

RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

# Copy the binary from the builder stage
COPY --from=builder /generate-code/target/release/generate-code /usr/local/bin

# Set the startup command to run your binary
CMD ["generate-code"]
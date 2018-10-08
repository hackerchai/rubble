FROM clux/muslrust:nightly as builder

COPY . /app

WORKDIR /app

RUN cargo build --release


FROM clux/diesel-cli

COPY --from=builder /app/target /application/target
COPY --from=builder /app/migrations /application/migrations
COPY --from=builder /app/Rocket.toml /application/Rocket.toml
COPY --from=builder /app/entrypoint.sh /application/entrypoint.sh
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/rubble /application/rubble

EXPOSE 8000
WORKDIR /application
CMD ["sh", "./entrypoint.sh"]
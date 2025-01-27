#!/bin/bash
set -e

# This script initializes null log tables using the same structure
# as the current version of the Otel Collector Clickhouse Exporter.
# The tables are useful for performing transforms on incoming data,
# (e.g. extracting resource attributes as columns) prior to storing
# in a persisted table.

clickhouse client <<-EOSQL
    CREATE DATABASE IF NOT EXISTS otel;
EOSQL

# Create the null log table for incoming otel logs
clickhouse client <<-EOSQL
    CREATE TABLE IF NOT EXISTS otel.otel_logs_null
    (
        Timestamp DateTime64(9) CODEC(Delta(8), ZSTD(1)),
        TraceId String CODEC(ZSTD(1)),
        SpanId String CODEC(ZSTD(1)),
        TraceFlags UInt8,
        SeverityText LowCardinality(String) CODEC(ZSTD(1)),
        SeverityNumber UInt8,
        ServiceName LowCardinality(String) CODEC(ZSTD(1)),
        Body String CODEC(ZSTD(1)),
        ResourceSchemaUrl LowCardinality(String) CODEC(ZSTD(1)),
        ResourceAttributes Map(LowCardinality(String), String) CODEC(ZSTD(1)),
        ScopeSchemaUrl LowCardinality(String) CODEC(ZSTD(1)),
        ScopeName String CODEC(ZSTD(1)),
        ScopeVersion LowCardinality(String) CODEC(ZSTD(1)),
        ScopeAttributes Map(LowCardinality(String), String) CODEC(ZSTD(1)),
        LogAttributes Map(LowCardinality(String), String) CODEC(ZSTD(1)),
    )
    ENGINE = Null;
EOSQL


# Create the null log table for incoming otel traces
clickhouse client <<-EOSQL
    CREATE TABLE IF NOT EXISTS otel.otel_traces_null (
        Timestamp DateTime64(9) CODEC(Delta, ZSTD(1)),
        TraceId String CODEC(ZSTD(1)),
        SpanId String CODEC(ZSTD(1)),
        ParentSpanId String CODEC(ZSTD(1)),
        TraceState String CODEC(ZSTD(1)),
        SpanName LowCardinality(String) CODEC(ZSTD(1)),
        SpanKind LowCardinality(String) CODEC(ZSTD(1)),
        ServiceName LowCardinality(String) CODEC(ZSTD(1)),
        ResourceAttributes Map(LowCardinality(String), String) CODEC(ZSTD(1)),
        ScopeName String CODEC(ZSTD(1)),
        ScopeVersion String CODEC(ZSTD(1)),
        SpanAttributes Map(LowCardinality(String), String) CODEC(ZSTD(1)),
        Duration UInt64 CODEC(ZSTD(1)),
        StatusCode LowCardinality(String) CODEC(ZSTD(1)),
        StatusMessage String CODEC(ZSTD(1)),
        Events Nested (
            Timestamp DateTime64(9),
            Name LowCardinality(String),
            Attributes Map(LowCardinality(String), String)
        ) CODEC(ZSTD(1)),
        Links Nested (
            TraceId String,
            SpanId String,
            TraceState String,
            Attributes Map(LowCardinality(String), String)
        ) CODEC(ZSTD(1)),
    )
    ENGINE = Null;
EOSQL

# Create the null log table for incoming otel metrics
clickhouse client <<-EOSQL
    CREATE TABLE IF NOT EXISTS otel.otel_metrics_null (
        Timestamp DateTime64(9) CODEC(Delta, ZSTD(1)),
        TraceId String CODEC(ZSTD(1)),
        SpanId String CODEC(ZSTD(1)),
        ParentSpanId String CODEC(ZSTD(1)),
        TraceState String CODEC(ZSTD(1)),
        SpanName LowCardinality(String) CODEC(ZSTD(1)),
        SpanKind LowCardinality(String) CODEC(ZSTD(1)),
        ServiceName LowCardinality(String) CODEC(ZSTD(1)),
        ResourceAttributes Map(LowCardinality(String), String) CODEC(ZSTD(1)),
        ScopeName String CODEC(ZSTD(1)),
        ScopeVersion String CODEC(ZSTD(1)),
        SpanAttributes Map(LowCardinality(String), String) CODEC(ZSTD(1)),
        Duration UInt64 CODEC(ZSTD(1)),
        StatusCode LowCardinality(String) CODEC(ZSTD(1)),
        StatusMessage String CODEC(ZSTD(1)),
        Events Nested (
            Timestamp DateTime64(9),
            Name LowCardinality(String),
            Attributes Map(LowCardinality(String), String)
        ) CODEC(ZSTD(1)),
        Links Nested (
            TraceId String,
            SpanId String,
            TraceState String,
            Attributes Map(LowCardinality(String), String)
        ) CODEC(ZSTD(1)),
    )
    ENGINE = Null;
EOSQL
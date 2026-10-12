-- Roles for the cash-flow database. Locally a superuser runs this; on Neon
-- `cash-flow-db provision` creates the same roles through the migrator.
--
-- cash_flow_migrator  owns the schema and runs migrations only.
-- cash_flow_api       the API at runtime: no superuser, no BYPASSRLS, owns nothing.
-- cash_flow_publisher sweeps and marks the outbox across workspaces; nothing else.

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'cash_flow_migrator') THEN
        CREATE ROLE cash_flow_migrator LOGIN NOSUPERUSER NOCREATEROLE NOBYPASSRLS;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'cash_flow_api') THEN
        CREATE ROLE cash_flow_api LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS NOINHERIT;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'cash_flow_publisher') THEN
        CREATE ROLE cash_flow_publisher LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS NOINHERIT;
    END IF;
END
$$;

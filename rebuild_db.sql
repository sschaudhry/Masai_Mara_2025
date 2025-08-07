-- Drop old tables if they exist
DROP TABLE IF EXISTS ibli_stock;
DROP TABLE IF EXISTS ibli_losses;
DROP TABLE IF EXISTS loss_agg;
DROP TABLE IF EXISTS livestock_summary;
DROP TABLE IF EXISTS mortality_summary;

-- Create stock table
CREATE TABLE ibli_stock (
    hhid TEXT,
    round INTEGER,
    comment TEXT,
    LivestockID TEXT,
    animaltype TEXT,
    gender TEXT,
    s6q1 TEXT,
    s6q2 TEXT,
    s6q3 TEXT,
    s6q4 TEXT,
    s6q5 TEXT,
    s6q6 TEXT,
    s6q7 TEXT,
    s6q66 TEXT,
    s6q67 TEXT
);

-- Create losses table
CREATE TABLE ibli_losses (
    hhid TEXT,
    round INTEGER,
    comment TEXT,
    lossevent TEXT,
    s6q20a TEXT,
    s6q20b TEXT,
    s6q21 TEXT,
    s6q22 TEXT,
    s6q22b TEXT,
    s6q23 TEXT,
    s6q24 TEXT,
    s6q24a TEXT,
    s6q25 TEXT
);

-- Import CSV data
\copy ibli_stock FROM '/workspaces/Masai_Mara_2025/S6A Livestock Stock.csv' WITH (FORMAT csv, HEADER);
\copy ibli_losses FROM '/workspaces/Masai_Mara_2025/S6C Livestock Losses.csv' WITH (FORMAT csv, HEADER);

-- Aggregate losses
CREATE TABLE loss_agg AS
SELECT
    hhid,
    round,
    s6q22 AS cause,
    SUM(COALESCE(NULLIF(regexp_replace(s6q24, '[^0-9]', '', 'g'), '')::INTEGER, 0)) AS total_losses
FROM ibli_losses
GROUP BY hhid, round, s6q22;

-- Combine stock + losses
CREATE TABLE livestock_summary AS
SELECT
    s.hhid,
    s.round,
    SUM(COALESCE(NULLIF(regexp_replace(s.s6q1, '[^0-9]', '', 'g'), ''), '0')::INTEGER) AS total_herd,
    COALESCE(SUM(l.total_losses), 0) AS total_losses
FROM ibli_stock s
LEFT JOIN loss_agg l
  ON s.hhid = l.hhid
  AND s.round = l.round
GROUP BY s.hhid, s.round;

-- Compute mortality by round
CREATE TABLE mortality_summary AS
SELECT
    round,
    SUM(total_losses) AS total_losses,
    SUM(total_herd) AS total_herd,
    CASE 
        WHEN SUM(total_herd) = 0 THEN 0
        ELSE ROUND(SUM(total_losses)::NUMERIC / SUM(total_herd) * 100, 2)
    END AS mortality_rate_pct
FROM livestock_summary
GROUP BY round
ORDER BY round;

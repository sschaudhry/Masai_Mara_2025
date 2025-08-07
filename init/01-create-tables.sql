CREATE TABLE ibli_stock (
    survey_no   TEXT,
    hhn         INTEGER,
    species     TEXT,
    livestock   INTEGER,
    date        DATE
);

CREATE TABLE ibli_losses (
    survey_no   TEXT,
    hhn         INTEGER,
    species     TEXT,
    loss_type   TEXT,
    loss_count  INTEGER,
    date        DATE
);

\copy ibli_stock FROM '/data/S6A_Livestock_Stock.csv' CSV HEADER;
\copy ibli_losses FROM '/data/S6C_Livestock_Losses.csv' CSV HEADER;

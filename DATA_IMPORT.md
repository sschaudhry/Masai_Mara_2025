# ILRI CSV Data Import
Link drought (SPI) with herd losses by loading two ILRI files:

- **S6A Livestock Stock.csv** – snapshot of herd size per household  
- **S6C Livestock Losses.csv** – counts of animals lost (drought, disease)

---

## A) Inspect the headers

In your workspace root run:

```bash
head -n1 "S6A Livestock Stock.csv"
head -n1 "S6C Livestock Losses.csv"
```

You should see:

```text
survey_no,hhn,species,livestock,date
survey_no,hhn,species,loss_type,loss_count,date
```

---

## B) Create the tables

Open psql:

```bash
docker compose exec db psql -U capstone_user -d capstone
```

Then execute:

```sql
-- Herd stock at survey time
CREATE TABLE ibli_stock (
  survey_no   TEXT,
  hhn         INTEGER,
  species     TEXT,
  livestock   INTEGER,
  date        DATE
);

-- Actual losses recorded
CREATE TABLE ibli_losses (
  survey_no   TEXT,
  hhn         INTEGER,
  species     TEXT,
  loss_type   TEXT,
  loss_count  INTEGER,
  date        DATE
);
```

---

## C) Import the CSVs

Still in the same psql session:

```sql
\copy ibli_stock
  FROM '/workspaces/Masai_Mara_2025/S6A Livestock Stock.csv'
  WITH (FORMAT csv, HEADER);

\copy ibli_losses
  FROM '/workspaces/Masai_Mara_2025/S6C Livestock Losses.csv'
  WITH (FORMAT csv, HEADER);
```

Verify:

```sql
SELECT COUNT(*) FROM ibli_stock;
SELECT COUNT(*) FROM ibli_losses;
```
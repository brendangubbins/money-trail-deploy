CREATE TABLE contribution (
	cmte_id VARCHAR(9) NOT NULL,
	amndt_ind VARCHAR(1),
	rpt_tp VARCHAR(3),
	transaction_pgi VARCHAR(5),
	image_num TEXT,
	transaction_tp VARCHAR(3),
	entity_tp VARCHAR(3),
	name VARCHAR(200),
	city VARCHAR(30),
	state VARCHAR(2),
	zip_code VARCHAR(9),
	employer VARCHAR(38),
	occupation VARCHAR(38),
	transaction_dt TEXT,
	transaction_amt NUMERIC,
	other_id VARCHAR(9),
	tran_id VARCHAR(32),
	file_num INT,
	memo_cd VARCHAR(1),
	memo_text VARCHAR(100),
  sub_id BIGINT PRIMARY KEY,
  transaction_dt_clean DATE
);

COPY contribution (
    cmte_id, amndt_ind, rpt_tp, transaction_pgi, image_num, transaction_tp, entity_tp,
    name, city, state, zip_code, employer, occupation, transaction_dt,
    transaction_amt, other_id, tran_id, file_num, memo_cd, memo_text, sub_id
)
FROM '/docker-entrypoint-initdb.d/contribution_data.txt'
WITH (FORMAT csv, HEADER true, DELIMITER E'|');

UPDATE contribution
SET transaction_dt_clean = TO_DATE(transaction_dt, 'MMDDYYYY')
WHERE transaction_dt IS NOT NULL;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX contribution_name_trgm_idx
ON contribution
USING gin (name gin_trgm_ops);

CREATE INDEX idx_contribution_amount ON contribution(transaction_amt);
CREATE INDEX idx_contribution_date ON contribution(transaction_dt_clean);
CREATE INDEX idx_contribution_city ON contribution(city);
CREATE INDEX idx_contribution_state ON contribution(state);
CREATE INDEX idx_contribution_entity_tp ON contribution(entity_tp);
CREATE INDEX idx_contribution_transaction_pgi ON contribution(transaction_pgi);
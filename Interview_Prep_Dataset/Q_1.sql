use [Interview_Practice];

CREATE TABLE exchange_rates (
    currency_code VARCHAR(3),
    date DATE,
    currency_exchange_rate DECIMAL(10, 2)
)

--Insert the records
INSERT INTO exchange_rates (currency_code, date, currency_exchange_rate) VALUES
('USD', '2024-06-01', 1.20),
('USD', '2024-06-02', 1.21),
('USD', '2024-06-03', 1.22),
('USD', '2024-06-04', 1.23),
('USD', '2024-07-01', 1.25),
('USD', '2024-07-02', 1.26),
('USD', '2024-07-03', 1.27),
('EUR', '2024-06-01', 1.40),
('EUR', '2024-06-02', 1.41),
('EUR', '2024-06-03', 1.42),
('EUR', '2024-06-04', 1.43),
('EUR', '2024-07-01', 1.45),
('EUR', '2024-07-02', 1.46),
('EUR', '2024-07-03', 1.47);

--For each currency, retrieve the starting and ending exchange rate within a given year and month.

select * from exchange_rates;

select DISTINCT
concat(currency_code, '_', year(date), '_', month(date)) date_code,
FIRST_VALUE(currency_exchange_rate) over(partition by concat(currency_code, '_', year(date), '_', month(date)) order by currency_exchange_rate asc) As Start_rate,
FIRST_VALUE(currency_exchange_rate) over(partition by concat(currency_code, '_', year(date), '_', month(date)) order by currency_exchange_rate DESC) as end_rate
from exchange_rates;
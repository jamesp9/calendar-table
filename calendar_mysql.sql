DROP TABLE IF EXISTS calendar;
DROP VIEW IF EXISTS v3;
DROP VIEW IF EXISTS v10;
DROP VIEW IF EXISTS v1000;

CREATE TABLE calendar (
  dt DATE NOT NULL PRIMARY KEY,
  y smallint NULL,
  q tinyint NULL,
  m tinyint NULL,
  d tinyint NULL,
  dw tinyint NULL,
  month_name varchar(9) NULL,
  day_name varchar(9) NULL,
  w tinyint NULL,
  is_weekday boolean NULL,
  is_holiday boolean NULL,
  holiday_desc text NULL
);

-- Generate and insert the series of daily dates
-- by using Views and Cross Joins to generate a cartisian product of 10,000 rows
CREATE VIEW v3 AS SELECT NULL UNION ALL SELECT NULL UNION ALL SELECT NULL;
CREATE VIEW v10 AS SELECT NULL FROM v3 a, v3 b UNION ALL SELECT NULL;
CREATE VIEW v1000 AS SELECT NULL FROM v10 a, v10 b, v10 c;
SET @n = 0;
-- INSERT INTO t1 SELECT now()-interval @n:=@n+1 second FROM v1000 a,v1000 b;
INSERT INTO calendar (dt) SELECT DATE('2008-12-31')+interval @n:=@n+1 day FROM v10 a,v1000 b;

-- Poplulate the columns
UPDATE calendar
  SET
    y = YEAR(DATE(dt)),
    q = quarter(dt),
    m = MONTH(dt),
    d = dayofmonth(dt),
    dw = dayofweek(dt),  -- Sunday (1) to Saturday (7)
    month_name = monthname(dt),
    day_name = dayname(dt),
    w = week(dt),
    is_weekday = CASE
      WHEN dayofweek(dt) IN (1,7)
        THEN 0
        ELSE 1
      END
;

-- Set holidays for Victoria Australia
UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'New Years Day'
  WHERE dt IN ('2017-01-01', '2017-01-02');

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Australia Day'
  WHERE dt = '2017-01-26';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Labour Day'
  WHERE dt = '2017-03-10';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Good Friday'
  WHERE dt = '2017-04-14';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Easter Monday'
  WHERE dt = '2017-04-17';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'ANZAC Day'
  WHERE dt = '2017-04-25';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Queens Birthday'
  WHERE dt = '2017-06-12';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Friday before the AFL Grand Final'
  WHERE dt = '2017-09-29';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Melbourne Cup'
  WHERE dt = '2017-11-07';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Christmas Day'
  WHERE dt = '2017-12-25';

UPDATE calendar SET is_holiday = TRUE, holiday_desc = 'Boxing Day'
  WHERE dt = '2017-12-26';

DROP VIEW IF EXISTS v3;
DROP VIEW IF EXISTS v10;
DROP VIEW IF EXISTS v1000;

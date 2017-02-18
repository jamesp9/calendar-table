DROP TABLE IF EXISTS calendar;

CREATE TABLE calendar (
  dt DATE NOT NULL PRIMARY KEY,
  y smallint NULL,
  q smallint NULL,
  m smallint NULL,
  d smallint NULL,
  dw smallint NULL,
  month_name varchar(9) NULL,
  day_name varchar(9) NULL,
  w smallint NULL,
  is_weekday boolean NULL,
  is_holiday boolean NULL,
  holiday_desc text NULL
);

-- Generate and insert the series of daily dates
INSERT INTO calendar (dt)
  SELECT (generate_series('2009-01-01', '2020-01-01', '1 day'::interval))::date;

-- Poplulate the columns
UPDATE calendar
  SET
    y = EXTRACT(year FROM dt::timestamp),
    q = EXTRACT(quarter FROM dt::timestamp),
    m = EXTRACT(month FROM dt::timestamp),
    d = EXTRACT(day FROM dt::timestamp),
    dw = EXTRACT(dow FROM dt::timestamp),  -- Sunday (0) to Saturday (6)
    month_name = to_char(dt::timestamp, 'Month'),
    day_name = to_char(dt::timestamp, 'Day'),
    w = EXTRACT(week FROM dt::timestamp),
    is_weekday = CASE
      WHEN EXTRACT(dow FROM dt::timestamp) IN (0,6)
        THEN FALSE
        ELSE TRUE
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

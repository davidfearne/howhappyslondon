CREATE EXTERNAL TABLE IF NOT EXISTS tweets_text(
  tweet_id bigint,
  created_unixtime bigint,
  created_time string,
  lang string,
  displayname string,
  time_zone string,
  msg string,
  fulltext string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "|"
LOCATION "/tmp/tweets_staging";

CREATE VIEW IF NOT EXISTS tweets_simple AS
SELECT
  tweet_id,
  cast ( from_unixtime( unix_timestamp(concat( '2015 ', substring(created_time,5,15)), 'yyyy MMM dd hh:mm:ss')) as timestamp) ts,
  msg,
  time_zone
FROM tweets_text;

CREATE VIEW IF NOT EXISTS tweets_clean AS
SELECT
  t.tweet_id,
  t.ts,
  t.msg,
  m.country
 FROM tweets_simple t LEFT OUTER JOIN time_zone_map m ON t.time_zone = m.time_zone;

-- Compute sentiment
create view IF NOT EXISTS l1 as select tweet_id, words from tweets_text lateral view explode(sentences(lower(msg))) dummy as words;

create view IF NOT EXISTS l2 as select tweet_id, word from l1 lateral view explode( words ) dummy as word;

create view IF NOT EXISTS l3 as select
    tweet_id,
    l2.word,
    case d.polarity
      when  'negative' then 0
      when 'positive' then 1
      else 0.5 end as polarity
 from l2 left outer join dictionary d on l2.word = d.word;

 create table IF NOT EXISTS tweets_sentiment stored as orc as select
  tweet_id,
  case
    when sum( polarity ) > 0 then 'positive'
    when sum( polarity ) < 0 then 'negative'
    else 'neutral' end as sentiment
 from l3 group by tweet_id;

CREATE TABLE IF NOT EXISTS tweetsbi
STORED AS ORC
AS SELECT
  t.*,
  case s.sentiment
    when 'positive' then 1
    when 'neutral' then 0.5
    when 'negative' then 0
  end as sentiment
FROM tweets_clean t LEFT OUTER JOIN tweets_sentiment s on t.tweet_id = s.tweet_id;

INSERT OVERWRITE DIRECTORY '/tmp/hive/' SELECT AVG(tweetsbi.sentiment) AS socailindex FROM tweetsbi;

DROP TABLE tweets_text;
DROP VIEW tweets_simple;
DROP VIEW tweets_clean;
DROP VIEW l1;
DROP VIEW l2;
DROP VIEW l3;
DROP TABLE tweets_sentiment;
DROP TABLE tweetsbi;
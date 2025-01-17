SELECT
    tagName AS 'tag:STRING',
    startDate AS 'startDate:DATE',
    endDate AS 'endDate:DATE'
FROM (
    SELECT
        tagName,
        startDate,
        endDate,
        abs(frequency - (SELECT percentile_disc(0.71) WITHIN GROUP (ORDER BY frequency) FROM tagAndWindowNumMessages)) diff
    FROM tagAndWindowNumMessages
    ORDER BY diff, tagName, startDate
    LIMIT 100
)
ORDER BY md5(concat(tagName, startDate))

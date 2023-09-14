WITH MY_DATA AS (
    SELECT
        MY_DATA.*
    FROM
        PROD.MY_DATA_WITH_A_LONG_TABLE_NAME AS MY_DATA
        INNER JOIN PROD.OTHER_THING
    WHERE
        MY_DATA.FILTER = 'my_filter'
), SOME_CTE AS (
    SELECT
        DISTINCT ID AS OTHER_ID,
        OTHER_FIELD_1,
        OTHER_FIELD_2,
        DATE_FIELD_AT,
        DATA_BY_ROW,
        FIELD_4,
        FIELD_5,
        LAG(OTHER_FIELD_2) OVER ( PARTITION BY OTHER_ID,
        OTHER_FIELD_1 ORDER BY 5 ) AS PREVIOUS_OTHER_FIELD_2
    FROM
        PROD.MY_OTHER_DATA
),
 /*
 this is a very long comment: it is good practice to leave comments in code to
 explain complex logic in ctes or business logic which may not be intuitive to
 someone who does not have intimate knowledge of the data source. this can help
 new users familiarize themselves with the code quickly.
 */ FINAL AS (
    SELECT -- this is a singel line comment
        MY_DATA.FIELD_1 AS DETAILED_FIELD_1,
        MY_DATA.FIELD_2 AS DETAILED_FIELD_2,
        MY_DATA.DETAILED_FIELD_3,
        DATE_TRUNC('month',
        SOME_CTE.DATE_FIELD_AT) AS DATE_FIELD_MONTH,
        IF( MY_DATA.DETAILED_FIELD_3 > MY_DATA.FIELD_2,
        TRUE,
        FALSE ) AS IS_BOOLEAN,
        CASE
            WHEN MY_DATA.CANCELLATION_DATE IS NULL AND MY_DATA.EXPIRATION_DATE IS NOT NULL THEN
                MY_DATA.EXPIRATION_DATE
            WHEN MY_DATA.CANCELLATION_DATE IS NULL THEN
                MY_DATA.START_DATE + 7 -- there is a reason for this number
            ELSE
                MY_DATA.CANCELLATION_DATE
        END AS ADJUSTED_CANCELLATION_DATE,
        COUNT(*) AS NUMBER_OF_RECORDS,
        SUM(SOME_CTE.FIELD_4) AS FIELD_4_SUM,
        MAX(SOME_CTE.FIELD_5) AS FIELD_5_MAX
    FROM
        MY_DATA
        LEFT JOIN SOME_CTE
        ON MY_DATA.ID = SOME_CTE.ID
    WHERE
        MY_DATA.FIELD_1 = 'abc'
        AND ( MY_DATA.FIELD_2 = 'def'
        OR MY_DATA.FIELD_2 = 'ghi' )
    GROUP BY
        1, 2, 3, 4, 5, 6
    HAVING
        COUNT(*) > 1
    ORDER BY
        8 DESC
)
SELECT
    *
FROM
    FINAL
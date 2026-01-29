----------------- LEAD -----------------------
----------------------------------------------


----- Case 1 -----
---Lead of EMPLOYEE_ID order by EMPLOYEE_ID

--- window function version
SELECT 
    "EMPLOYEE_ID"
    ,"AGE"
    ,"GENDER"
    ,"SALARY"
    ,lead("EMPLOYEE_ID") over(order by "EMPLOYEE_ID") as employee_id_lead
FROM salary_data 
order by 1


--- first principles version with self-join

SELECT 
    o1."EMPLOYEE_ID"
    ,o1."AGE"
    ,o1."GENDER"
    ,o1."SALARY"
    ,min(o2."EMPLOYEE_ID") as employee_id_lead
FROM salary_data o1
left JOIN salary_data o2 on (o1."EMPLOYEE_ID" < o2."EMPLOYEE_ID") 
group by 1,2,3,4

---- Case 2 -----
---Lead of SALARY order by SALARY and EMPLOYEE_ID


--- window function version
SELECT 
    "EMPLOYEE_ID"
    ,"AGE"
    ,"GENDER"
    ,"SALARY"
    ,lead("SALARY") over(order by "SALARY", "EMPLOYEE_ID") as salary_lead
FROM salary_data 
order by 4,1


--- first principles version with self-join
SELECT 
    o1."EMPLOYEE_ID"
    ,o1."AGE"
    ,o1."GENDER"
    ,o1."SALARY"
    ,min(o2."SALARY") as salary_lead
FROM salary_data o1
left JOIN salary_data o2 on (o1."SALARY" < o2."SALARY"
or (o1."SALARY" = o2."SALARY" and o1."EMPLOYEE_ID" < o2."EMPLOYEE_ID"))
group by 1,2,3,4
order by 4,1


---- Case 3 -----
---Lead of SALARY order by SALARY and EMPLOYEE_ID desc within the window frame AGE and GENDER


--- window function version

SELECT 
    "EMPLOYEE_ID"
    ,"AGE"
    ,"GENDER"
    ,"SALARY"
    ,lead("SALARY") over(partition by "AGE", "GENDER" 
                    order by "SALARY", "EMPLOYEE_ID" DESC) as salary_lead
FROM salary_data 
order by "AGE", "GENDER", "SALARY", "EMPLOYEE_ID"


--- first principles version with self-join
SELECT 
    o1."EMPLOYEE_ID"
    ,o1."AGE"
    ,o1."GENDER"
    ,o1."SALARY"
    ,min(o2."SALARY") as salary_lead
FROM salary_data o1
left JOIN salary_data o2 on ((o1."SALARY" < o2."SALARY" 
or (o1."SALARY" = o2."SALARY" and o1."EMPLOYEE_ID" > o2."EMPLOYEE_ID"))
and o1."AGE" = o2."AGE" and o1."GENDER" = o2."GENDER") 
group by 1,2,3,4
order by o1."AGE", o1."GENDER", o1."SALARY", o1."EMPLOYEE_ID"




---------------------------------------------------------------------------
----------------- LAG ------------------------
----------------------------------------------


----- Case 1 -----
---Lag of EMPLOYEE_ID order by EMPLOYEE_ID

--- window function version
SELECT 
    "EMPLOYEE_ID"
    ,"AGE"
    ,"GENDER"
    ,"SALARY"
    ,lag("EMPLOYEE_ID") over(order by "EMPLOYEE_ID") as employee_id_lag
FROM salary_data 
order by 1


--- first principles version with self-join

SELECT 
    o1."EMPLOYEE_ID"
    ,o1."AGE"
    ,o1."GENDER"
    ,o1."SALARY"
    ,max(o2."EMPLOYEE_ID") as employee_id_lag
FROM salary_data o1
left JOIN salary_data o2 on (o1."EMPLOYEE_ID" > o2."EMPLOYEE_ID") 
group by 1,2,3,4


---- Case 2 -----
---Lag of SALARY order by SALARY and EMPLOYEE_ID


--- window function version
SELECT 
    "EMPLOYEE_ID"
    ,"AGE"
    ,"GENDER"
    ,"SALARY"
    ,lag("SALARY") over(order by "SALARY", "EMPLOYEE_ID") as salary_lag
FROM salary_data 
order by 4,1


--- first principles version with self-join
SELECT 
    o1."EMPLOYEE_ID"
    ,o1."AGE"
    ,o1."GENDER"
    ,o1."SALARY"
    ,max(o2."SALARY") as salary_lead
FROM salary_data o1
left JOIN salary_data o2 on (o1."SALARY" > o2."SALARY"
or (o1."SALARY" = o2."SALARY" and o1."EMPLOYEE_ID" > o2."EMPLOYEE_ID"))
group by 1,2,3,4
order by 4,1



---- Case 3 -----
---Lag of SALARY order by SALARY and EMPLOYEE_ID desc within window frame AGE and GENDER



--- window function version

SELECT 
    "EMPLOYEE_ID"
    ,"AGE"
    ,"GENDER"
    ,"SALARY"
    ,lag("SALARY") over(partition by "AGE", "GENDER" 
                   order by "SALARY", "EMPLOYEE_ID" desc) as salary_
FROM salary_data 
order by "AGE" , "GENDER", "SALARY", "EMPLOYEE_ID"


--- first principles version with self-join
SELECT 
    o1."EMPLOYEE_ID"
    ,o1."AGE"
    ,o1."GENDER"
    ,o1."SALARY"
    ,max(o2."SALARY") as salary_lag
FROM salary_data o1
left JOIN salary_data o2 on ((o1."SALARY" > o2."SALARY" 
or (o1."SALARY" = o2."SALARY" and o1."EMPLOYEE_ID" < o2."EMPLOYEE_ID"))
and o1."AGE" = o2."AGE" and o1."GENDER" = o2."GENDER") 
where o1."AGE" = 23 and o1."GENDER" = 'Male'
group by 1,2,3,4
order by o1."AGE" , o1."GENDER", o1."SALARY",o1."EMPLOYEE_ID"